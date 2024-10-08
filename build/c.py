from build.ab import (
    Rule,
    Targets,
    TargetsMap,
    filenameof,
    filenamesof,
    flatten,
    simplerule,
    emit,
)
from build.utils import filenamesmatchingof, stripext, collectattrs
from os.path import *

emit(
    """
ifeq ($(OSX),no)
HOSTSTARTGROUP ?= -Wl,--start-group
HOSTENDGROUP ?= -Wl,--end-group
endif
STARTGROUP ?= $(HOSTSTARTGROUP)
ENDGROUP ?= $(HOSTENDGROUP)
"""
)


class Toolchain:
    label = ""
    cfile = ["$(CC) -c -o {outs[0]} {ins[0]} $(CFLAGS) {cflags}"]
    cxxfile = ["$(CXX) -c -o {outs[0]} {ins[0]} $(CFLAGS) {cflags}"]
    clibrary = ["$(AR) cqs {outs[0]} {ins}"]
    cxxlibrary = ["$(AR) cqs {outs[0]} {ins}"]
    cprogram = [
        "$(CC) -o {outs[0]} $(STARTGROUP) {ins} {ldflags} $(LDFLAGS) $(ENDGROUP)"
    ]
    cxxprogram = [
        "$(CXX) -o {outs[0]} $(STARTGROUP) {ins} {ldflags} $(LDFLAGS) $(ENDGROUP)"
    ]


class HostToolchain:
    label = "HOST "
    cfile = ["$(HOSTCC) -c -o {outs[0]} {ins[0]} $(HOSTCFLAGS) {cflags}"]
    cxxfile = ["$(HOSTCXX) -c -o {outs[0]} {ins[0]} $(HOSTCFLAGS) {cflags}"]
    clibrary = ["$(HOSTAR) cqs {outs[0]} {ins}"]
    cxxlibrary = ["$(HOSTAR) cqs {outs[0]} {ins}"]
    cprogram = [
        "$(HOSTCC) -o {outs[0]} $(HOSTSTARTGROUP) {ins} {ldflags} $(HOSTLDFLAGS) $(HOSTENDGROUP)"
    ]
    cxxprogram = [
        "$(HOSTCXX) -o {outs[0]} $(HOSTSTARTGROUP) {ins} {ldflags} $(HOSTLDFLAGS) $(HOSTENDGROUP)"
    ]


def cfileimpl(self, name, srcs, deps, suffix, commands, label, kind, cflags):
    outleaf = "=" + stripext(basename(filenameof(srcs[0]))) + suffix

    hdr_deps = set()
    for d in deps:
        hdr_deps.update(d.args.get("cheader_deps", {d}))
    cflags = collectattrs(
        targets=hdr_deps, name="caller_cflags", initial=cflags
    )

    t = simplerule(
        replaces=self,
        ins=srcs,
        deps=sorted(hdr_deps),
        outs=[outleaf],
        label=label,
        commands=commands,
        args={"cflags": cflags},
    )


@Rule
def cfile(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    cflags=[],
    suffix=".o",
    toolchain=Toolchain,
    commands=None,
    label=None,
):
    if not label:
        label = toolchain.label + "CC"
    if not commands:
        commands = toolchain.cfile
    cfileimpl(self, name, srcs, deps, suffix, commands, label, "cfile", cflags)


@Rule
def cxxfile(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    cflags=[],
    suffix=".o",
    toolchain=Toolchain,
    commands=None,
    label=None,
):
    if not label:
        label = toolchain.label + "CXX"
    if not commands:
        commands = toolchain.cxxfile
    cfileimpl(
        self, name, srcs, deps, suffix, commands, label, "cxxfile", cflags
    )


def findsources(name, srcs, deps, cflags, toolchain, filerule, cwd):
    for f in filenamesof(srcs):
        if f.endswith(".h") or f.endswith(".hh"):
            cflags = cflags + [f"-I{dirname(f)}"]

    objs = []
    for s in flatten(srcs):
        objs += [
            filerule(
                name=join(name, f.removeprefix("$(OBJ)/")),
                srcs=[f],
                deps=deps,
                cflags=sorted(set(cflags)),
                toolchain=toolchain,
                cwd=cwd,
            )
            for f in filenamesof([s])
            if f.endswith(".c")
            or f.endswith(".cc")
            or f.endswith(".cpp")
            or f.endswith(".S")
            or f.endswith(".s")
        ]
        if any(f.endswith(".o") for f in filenamesof([s])):
            objs += [s]

    return objs


@Rule
def cheaders(
    self,
    name,
    hdrs: TargetsMap = {},
    caller_cflags=[],
    deps: Targets = [],
):
    cs = []
    ins = hdrs.values()
    outs = []
    i = 0
    for dest, src in hdrs.items():
        s = filenamesof([src])
        assert (
            len(s) == 1
        ), "the target of a header must return exactly one file"

        cs += ["$(CP) {ins[" + str(i) + "]} {outs[" + str(i) + "]}"]
        outs += ["=" + dest]
        i = i + 1

    hdr_deps = {self}
    lib_deps = set()
    for d in deps:
        hdr_deps.update(d.args.get("cheader_deps", {d}))
        lib_deps.update(d.args.get("clibrary_deps", {d}))

    simplerule(
        replaces=self,
        ins=ins,
        outs=outs,
        deps=deps,
        commands=cs,
        label="CHEADERS",
        args={
            "caller_cflags": caller_cflags + [f"-I{self.dir}"],
            "cheader_deps": hdr_deps,
            "clibrary_deps": lib_deps,
        },
    )


def libraryimpl(
    self,
    name,
    srcs,
    deps,
    hdrs,
    caller_cflags,
    caller_ldflags,
    cflags,
    ldflags,
    toolchain,
    commands,
    label,
    kind,
):
    hr = None
    if hdrs and not srcs:
        cheaders(
            replaces=self,
            hdrs=hdrs,
            caller_cflags=caller_cflags,
        )
        return
    if hdrs:
        hr = cheaders(
            name=self.localname + "_hdrs",
            hdrs=hdrs,
            caller_cflags=caller_cflags,
        )
        hr.materialise()
        deps = deps + [hr]

    objs = findsources(
        self.localname,
        srcs,
        deps,
        cflags,
        toolchain,
        kind,
        self.cwd,
    )

    hdr_deps = {hr} if hr else set()
    lib_deps = {self}
    for d in deps:
        hdr_deps.update(d.args.get("cheader_deps", {d}))
        lib_deps.update(d.args.get("clibrary_deps", {d}))

    simplerule(
        replaces=self,
        ins=objs,
        outs=[f"={self.localname}.a"],
        label=label,
        commands=commands,
        args={
            "caller_ldflags": caller_ldflags,
            "cheader_deps": hdr_deps,
            "clibrary_deps": lib_deps,
        },
        traits={"cheaders"},
    )


@Rule
def clibrary(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    hdrs: TargetsMap = None,
    caller_cflags=[],
    caller_ldflags=[],
    cflags=[],
    ldflags=[],
    toolchain=Toolchain,
    commands=None,
    label=None,
    cfilerule=cfile,
):
    if not label:
        label = toolchain.label + "LIB"
    if not commands:
        commands = toolchain.clibrary
    libraryimpl(
        self,
        name,
        srcs,
        deps,
        hdrs,
        caller_cflags,
        caller_ldflags,
        cflags,
        ldflags,
        toolchain,
        commands,
        label,
        cfilerule,
    )


@Rule
def cxxlibrary(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    hdrs: TargetsMap = None,
    caller_cflags=[],
    caller_ldflags=[],
    cflags=[],
    ldflags=[],
    toolchain=Toolchain,
    commands=None,
    label=None,
):
    if not label:
        label = toolchain.label + "LIB"
    if not commands:
        commands = toolchain.clibrary
    libraryimpl(
        self,
        name,
        srcs,
        deps,
        hdrs,
        caller_cflags,
        caller_ldflags,
        cflags,
        ldflags,
        toolchain,
        commands,
        label,
        cxxfile,
    )


def programimpl(
    self,
    name,
    srcs,
    deps,
    cflags,
    ldflags,
    toolchain,
    commands,
    label,
    filerule,
    kind,
):
    cfiles = findsources(
        self.localname, srcs, deps, cflags, toolchain, filerule, self.cwd
    )

    lib_deps = set()
    for d in deps:
        lib_deps.update(d.args.get("clibrary_deps", {d}))
    libs = sorted(filenamesmatchingof(lib_deps, "*.a"))
    ldflags = collectattrs(
        targets=lib_deps, name="caller_ldflags", initial=ldflags
    )

    simplerule(
        replaces=self,
        ins=cfiles + libs,
        outs=[f"={self.localname}$(EXT)"],
        deps=deps,
        label=toolchain.label + label,
        commands=commands,
        args={
            "ldflags": collectattrs(
                targets=lib_deps, name="caller_ldflags", initial=ldflags
            )
        },
    )


@Rule
def cprogram(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    cflags=[],
    ldflags=[],
    toolchain=Toolchain,
    commands=None,
    label="CLINK",
):
    if not commands:
        commands = toolchain.cprogram
    programimpl(
        self,
        name,
        srcs,
        deps,
        cflags,
        ldflags,
        toolchain,
        commands,
        label,
        cfile,
        "cprogram",
    )


@Rule
def cxxprogram(
    self,
    name,
    srcs: Targets = None,
    deps: Targets = None,
    cflags=[],
    ldflags=[],
    toolchain=Toolchain,
    commands=None,
    label="CXXLINK",
):
    if not commands:
        commands = toolchain.cxxprogram
    programimpl(
        self,
        name,
        srcs,
        deps,
        cflags,
        ldflags,
        toolchain,
        commands,
        label,
        cxxfile,
        "cxxprogram",
    )
