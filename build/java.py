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
from build.utils import targetswithtraitsof, collectattrs
from build.zip import zip
from os.path import *

emit(
    """
JAR ?= jar
JAVAC ?= javac
JFLAGS ?= -g
"""
)


def batched(items, n):
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
                args={"jar": f},
            )
            return
    error(f"None of {paths} exist")


@Rule
def javalibrary(
    self,
    name,
    srcitems: TargetsMap = {},
    deps: Targets = [],
):
    jardeps = collectattrs(
        targets=deps,
        name="caller_deps",
        initial=filenamesof(targetswithtraitsof(deps, "javalibrary")),
    ) + [t.args["jar"] for t in targetswithtraitsof(deps, "externaljar")]

    srcfiles = [f"{filenameof(v)}" for v in srcitems.values()]

    cs = (
        # Setup.
        [
            "rm -rf {dir}/src {dir}/objs {dir}/files.txt {outs[0]}",
            "mkdir -p {dir}/src",
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
            for i, f in enumerate(
                filenamesof(targetswithtraitsof(deps, "srcjar"))
            )
        ]
        # Construct the list of filenames (which can be too long to go on
        # the command line).
        + [
            "echo " + (" ".join(batch)) + " >> {dir}/files.txt"
            for batch in batched(srcfiles, 100)
        ]
        + ["find {dir}/src -name '*.java' >> {dir}/files.txt"]
        # Actually do the compilation.
        + [
            " ".join(
                [
                    "$(JAVAC)",
                    "$(JFLAGS)",
                    "-d {dir}/objs",
                    " -cp " + (":".join(jardeps)) if jardeps else "",
                    "@{dir}/files.txt",
                ]
            )
        ]
        # jar up the result.
        + [
            "$(JAR) --create --no-compress --file {outs[0]} -C {self.dir}/objs ."
        ]
    )

    simplerule(
        replaces=self,
        ins=list(srcitems.values()) + deps,
        outs=[f"={self.localname}.jar"],
        commands=cs,
        label="JAVALIBRARY",
        args={"caller_deps": jardeps},
    )


@Rule
def javaprogram(
    self,
    name,
    srcitems: TargetsMap = {},
    deps: Targets = [],
    mainclass=None,
):
    jars = filenamesof(targetswithtraitsof(deps, "javalibrary"))
    externaljars = [
        t.args["jar"] for t in targetswithtraitsof(deps, "externaljar")
    ]

    assert mainclass, "a main class must be specified for javaprogram"
    if srcitems:
        j = javalibrary(
            name=name + "_mainlib",
            srcitems=srcitems,
            deps=deps,
            cwd=self.cwd,
        )
        j.materialise()
        jars += [filenameof(j)]

    simplerule(
        replaces=self,
        ins=jars,
        outs=[f"={self.localname}.jar"],
        commands=[
            "rm -rf {dir}/objs",
            "mkdir -p {dir}/objs",
            "echo 'Manifest-Version: 1.0' > {dir}/manifest.mf",
            "echo 'Created-By: ab' >> {dir}/manifest.mf",
            "echo 'Main-Class: " + mainclass + "' >> {dir}/manifest.mf",
            "echo 'Class-Path: "
            + (" ".join(externaljars))
            + "' >> {dir}/manifest.mf",
        ]
        + ["(cd {dir}/objs && $(JAR) xf $(abspath " + j + "))" for j in jars]
        + [
            "$(JAR) --create --file={outs[0]} --manifest={dir}/manifest.mf -C {dir}/objs ."
        ],
        label="JAVAPROGRAM",
    )
