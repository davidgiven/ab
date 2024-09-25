from build.ab import (
    simplerule,
    error,
    Rule,
    Targets,
    TargetsMap,
    filenamesof,
    filenameof,
    emit,
)
from build.utils import targetswithtraitsof, collectattrs, filenamesmatchingof
from build.zip import zip
from os.path import *

emit(
    """
JAR ?= jar
JAVAC ?= javac
JFLAGS ?= -g
"""
)


def _manifestline(key, value):
    s = f"{key}: {value}"
    c = []
    while s:
        c += [("" if len(c) == 0 else " ") + s[:70]]
        s = s[70:]
    return c


def _batched(items, n):
    return (items[pos : pos + n] for pos in range(0, len(items), n))


@Rule
def jar(self, name, items: TargetsMap = {}):
    zip(replaces=self, items=items, extension="jar", flags="-0", label="JAR")


@Rule
def srcjar(self, name, items: TargetsMap = {}):
    zip(
        replaces=self,
        items=items,
        extension="srcjar",
        flags="-0",
        label="SRCJAR",
    )


@Rule
def externaljar(self, name, paths):
    for f in paths:
        if isfile(f):
            simplerule(
                replaces=self,
                ins=[],
                outs=[],
                commands=[],
                label="EXTERNALJAR",
                args={"jar": f, "caller_deps": [self]},
            )
            return
    error(f"None of {paths} exist")


@Rule
def javalibrary(
    self,
    name,
    srcitems: TargetsMap = {},
    dataitems: TargetsMap = {},
    deps: Targets = [],
):
    alldeps = collectattrs(targets=deps, name="caller_deps", initial=deps)
    externaldeps = targetswithtraitsof(alldeps, "externaljar")
    externaljars = [t.args["jar"] for t in externaldeps]
    internaldeps = targetswithtraitsof(alldeps, "javalibrary")
    srcdeps = targetswithtraitsof(alldeps, "srcjar")

    classpath = filenamesof(internaldeps) + externaljars
    srcfiles = filenamesmatchingof(srcitems.values(), "*.java")

    cs = (
        # Setup.
        [
            "rm -rf {dir}/src {dir}/objs {dir}/files.txt {outs[0]}",
            "mkdir -p {dir}/src {dir}/objs",
        ]
        # Decompress any srcjars into directories of their own.
        + [
            " && ".join(
                [
                    "(mkdir {dir}/src/" + str(i),
                    "cd {dir}/src/" + str(i),
                    "$(JAR) xf $(abspath " + f + "))",
                ]
            )
            for i, f in enumerate(filenamesof(srcdeps))
        ]
        # Copy any source data items.
        + [
            f"mkdir -p {{dir}}/objs/{dirname(dest)} && cp {filenameof(src)} {{dir}}/objs/{dest}"
            for dest, src in dataitems.items()
        ]
        # Construct the list of filenames (which can be too long to go on
        # the command line).
        + [
            "echo " + (" ".join(batch)) + " >> {dir}/files.txt"
            for batch in _batched(srcfiles, 100)
        ]
        + [
            # Find any source files in the srcjars (which we don't know
            # statically).
            "find {dir}/src -name '*.java' >> {dir}/files.txt",
            # Actually do the compilation.
            " ".join(
                [
                    "if [ -s {dir}/files.txt ]; then",
                    "$(JAVAC)",
                    "$(JFLAGS)",
                    "-d {dir}/objs",
                    (" -cp " + ":".join(classpath)) if classpath else "",
                    "@{dir}/files.txt",
                    "; fi",
                ]
            ),
            # jar up the result.
            "$(JAR) --create --no-compress --file {outs[0]} -C {self.dir}/objs .",
        ]
    )

    simplerule(
        replaces=self,
        ins=list(srcitems.values()) + deps,
        outs=[f"={self.localname}.jar"],
        commands=cs,
        label="JAVALIBRARY",
        args={"caller_deps": externaldeps + internaldeps},
    )


@Rule
def javaprogram(
    self,
    name,
    srcitems: TargetsMap = {},
    deps: Targets = [],
    mainclass=None,
    manifest={},
):
    alldeps = collectattrs(targets=deps, name="caller_deps", initial=deps)
    externaldeps = targetswithtraitsof(alldeps, "externaljar")
    externaljars = [t.args["jar"] for t in externaldeps]
    internaldeps = targetswithtraitsof(alldeps, "javalibrary")

    assert mainclass, "a main class must be specified for javaprogram"
    if srcitems:
        j = javalibrary(
            name=name + "_mainlib",
            srcitems=srcitems,
            deps=deps,
            cwd=self.cwd,
        )
        j.materialise()
        internaldeps += [j]
        alldeps += [j]

    mf = (
        _manifestline("Manifest-Version", "1.0")
        + _manifestline("Created-By", "ab")
        + _manifestline("Main-Class", mainclass)
        + (
            []
            if not externaljars
            else _manifestline("Class-Path", " ".join(externaljars))
        )
        + [_manifestline(k, v) for k, v in manifest.items()]
    )

    simplerule(
        replaces=self,
        ins=alldeps,
        outs=[f"={self.localname}.jar"],
        commands=[
            "rm -rf {dir}/objs {dir}/manifest.mf",
            "mkdir -p {dir}/objs",
        ]
        + [f"echo '{m}' >> {{dir}}/manifest.mf" for m in mf]
        + [
            "(cd {dir}/objs && $(JAR) xf $(abspath " + j + "))"
            for j in filenamesof(internaldeps)
        ]
        + [
            "$(JAR) --create --file={outs[0]} --manifest={dir}/manifest.mf -C {dir}/objs ."
        ],
        label="JAVAPROGRAM",
    )


@Rule
def javaexecutable(
    self,
    name,
    srcitems: TargetsMap = {},
    deps: Targets = [],
    mainclass=None,
    manifest={},
    vmflags=[],
):
    jar = javaprogram(
        name=f"{self.localname}.jar",
        srcitems=srcitems,
        deps=deps,
        mainclass=mainclass,
        manifest=manifest,
    )

    flags = " ".join(vmflags)
    simplerule(
        replaces=self,
        ins=[jar],
        outs=[f"={self.localname}"],
        commands=[
            f"echo '#!/usr/bin/env -S java {flags} -jar' > {{outs[0]}}",
            "cat {ins[0]} >> {outs[0]}",
            "chmod a+rx {outs[0]}",
        ],
        label="JAVAEXE",
    )
