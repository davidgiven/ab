from os.path import basename, join
from build.ab import (
    ABException,
    Rule,
    Targets,
    TargetsMap,
    filenameof,
    flatten,
    filenamesof,
    normalrule,
    stripext,
)
from os.path import *


def cfileimpl(self, name, srcs, deps, suffix, commands, label, kind, cflags):
    dirs = []
    for d in deps + srcs:
        for f in filenamesof(d):
            if f.endswith(".h"):
                dirs += [dirname(f)]
        try:
            dirs += d.clibrary.dirs
        except:
            pass

    includeflags = ["-I" + f for f in set(filenamesof(dirs))]

    outleaf = stripext(basename(filenameof(srcs[0]))) + suffix

    normalrule(
        replaces=self,
        ins=srcs,
        deps=deps,
        outs=[outleaf],
        label=label,
        commands=commands,
        cflags=cflags + includeflags,
    )


@Rule
def cfile(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    cflags=[],
    suffix=".o",
    commands=["$(CC) -c -o {outs[0]} {ins[0]} $(CFLAGS) {cflags}"],
    label="CC",
):
    cfileimpl(self, name, srcs, deps, suffix, commands, label, "cfile", cflags)


@Rule
def cxxfile(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    cflags=[],
    suffix=".o",
    commands=["$(CXX) -c -o {outs[0]} {ins[0]} $(CFLAGS) {cflags}"],
    label="CXX",
):
    cfileimpl(
        self, name, srcs, deps, suffix, commands, label, "cxxfile", cflags
    )


def findsources(name, srcs, deps, cflags, filerule):
    objs = []
    for s in flatten(srcs):
        ff = [
            f
            for f in filenamesof(s)
            if f.endswith(".c") or f.endswith(".cc") or f.endswith(".cpp")
        ]
        if ff:
            for f in ff:
                objs += [
                    filerule(
                        name=join(name, f),
                        srcs=[f],
                        deps=deps,
                        cflags=cflags,
                    )
                ]
        else:
            if s not in objs:
                objs += [s]
    return objs


@Rule
def clibrary(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    hdrs: TargetsMap = {},
    cflags=[],
    commands=["$(AR) cqs {outs[0]} {ins}"],
    label="LIB",
):
    objdir = join("$(OBJ)", name)
    if not srcs and not hdrs:
        raise ABException(
            "clibrary contains no sources and no exported headers"
        )

    libraries = [d for d in deps if hasattr(d, "clibrary")]
    for library in libraries:
        if library.clibrary.cflags:
            cflags += library.clibrary.cflags
        if library.clibrary.ldflags:
            ldflags += library.clibrary.ldflags

    for f in filenamesof(srcs):
        if f.endswith(".h"):
            deps += [f]

    cs = []
    hdrins = list(hdrs.values())
    hdrouts = []
    for dest, src in hdrs.items():
        destf = join(objdir, filenameof(dest))
        dir = dirname(destf)
        if dir:
            cs += ["mkdir -p " + dir]

        s = filenamesof(src)
        if len(s) != 1:
            raise ABException(
                "a dependency of an export must have exactly one output file"
            )

        cs += ["cp %s %s" % (s[0], destf)]
        hdrouts += [destf]

    actualsrcs = findsources(name, srcs, deps + hdrins, cflags, cfile)
    cs += commands if actualsrcs else []

    normalrule(
        replaces=self,
        ins=actualsrcs,
        outs=[basename(name) + ".a"] + hdrouts,
        label=label,
        commands=cs,
    )

    self.clibrary.ldflags = []
    self.clibrary.cflags = ["-I" + objdir]


def programimpl(
    self, name, srcs, deps, cflags, ldflags, commands, label, filerule, kind
):
    libraries = [d for d in deps if hasattr(d, "clibrary")]
    for library in libraries:
        if library.clibrary.cflags:
            cflags += library.clibrary.cflags
        if library.clibrary.ldflags:
            ldflags += library.clibrary.ldflags

    deps += [f for f in filenamesof(srcs) if f.endswith(".h")]

    normalrule(
        replaces=self,
        ins=(
            findsources(name, srcs, deps, cflags, filerule)
            + [f for f in filenamesof(libraries) if f.endswith(".a")]
        ),
        outs=[basename(name)],
        deps=deps,
        label=label,
        commands=commands,
        ldflags=ldflags,
    )


@Rule
def cprogram(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    cflags=[],
    ldflags=[],
    commands=["$(CC) -o {outs[0]} {ins} {ldflags}"],
    label="CLINK",
):
    programimpl(
        self,
        name,
        srcs,
        deps,
        cflags,
        ldflags,
        commands,
        label,
        cfile,
        "cprogram",
    )


@Rule
def cxxprogram(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    cflags=[],
    ldflags=[],
    commands=["$(CXX) -o {outs[0]} {ins} {ldflags}"],
    label="CXXLINK",
):
    programimpl(
        self,
        name,
        srcs,
        deps,
        cflags,
        ldflags,
        commands,
        label,
        cxxfile,
        "cxxprogram",
    )
