from build.ab import (
    Rule,
    Targets,
    normalrule,
    filenamesof,
    stripext,
    flatten,
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
    cflags=[],
    commands=["$(AR) cqs {outs[0]} {ins}"],
    label="AR",
):
    for f in filenamesof(srcs):
        if f.endswith(".h"):
            deps += [f]

    normalrule(
        replaces=self,
        ins=findsources(name, srcs, deps, cfile),
        outs=[basename(name) + ".a"],
        label=label,
        commands=commands,
    )

    dirs = set([dirname(f) for f in filenamesof(hdrs)])

    self.clibrary.hdrs = hdrs
    self.clibrary.dirs = dirs


def programimpl(
    self, name, srcs, deps, cflags, ldflags, commands, label, filerule, kind
):
    libraries = [d.outs for d in deps if hasattr(d, "clibrary")]

    for f in filenamesof(srcs):
        if f.endswith(".h"):
            deps += [f]

    normalrule(
        replaces=self,
        ins=findsources(name, srcs, deps, cflags, filerule),
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
