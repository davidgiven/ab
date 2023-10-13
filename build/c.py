from os.path import basename, join
from build.ab import (
    Rule,
    Targets,
    normalrule,
    filenamesof,
    stripext,
    ABException,
)
from os.path import *


def cfileimpl(self, name, srcs, deps, suffix, commands, label, kind, cflags):
    if not name:
        name = filenamesof(srcs)[1]

    dirs = []
    for d in deps:
        for f in filenamesof(d):
            if f.endswith(".h"):
                dirs += [dirname(f)]
        try:
            dirs += d.clibrary.dirs
        except:
            pass

    includeflags = set(["-I" + f for f in filenamesof(dirs)])

    outleaf = stripext(basename(name)) + suffix

    r = normalrule(
        replaces=self,
        ins=srcs,
        deps=deps,
        outs=[outleaf],
        label=label,
        commands=commands,
        cflags=cflags,
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
    ins = []
    for f in filenamesof(srcs):
        if f.endswith(".c") or f.endswith(".cc") or f.endswith(".cpp"):
            ins += [
                filerule(
                    name=name + "/" + basename(filenamesof(f)[0]),
                    srcs=[f],
                    deps=deps,
                    cflags=cflags,
                )
            ]
        else:
            ins += [f]
    return ins


@Rule
def clibrary(
    self,
    name,
    srcs: Targets = [],
    deps: Targets = [],
    hdrs: Targets = [],
    hdrprefix=None,
    cflags=[],
    commands=["$(AR) cqs {outs[0]} {ins}"],
    label="AR",
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

    c = commands if srcs else []
    hdrouts = []
    for hdr in filenamesof(hdrs):
        c += ["cp %s %s" % (hdr, join(objdir, hdr))]
        hdrouts += [basename(hdr)]

    normalrule(
        replaces=self,
        ins=findsources(name, srcs, deps + hdrs, cflags, cfile),
        outs=[basename(name) + ".a"] + hdrouts,
        label=label,
        commands=c,
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
