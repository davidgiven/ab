from build.ab import (
    simplerule,
    Rule,
    Targets,
    TargetsMap,
    filenamesof,
    filenameof,
    emit,
)
from build.utils import targetswithtraitsof
from build.zip import zip
from os.path import *

emit(
    """
JAR ?= jar
JAVAC ?= javac
JFLAGS ?= -g
"""
)


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
def externaljar(self, name, path):
    simplerule(
        replaces=self,
        ins=[],
        outs=[],
        commands=[],
        label="EXTERNALJAR",
        jar=path,
    )


@Rule
def javalibrary(
    self,
    name,
    srcitems: TargetsMap = {},
    deps: Targets = [],
):
    jardeps = filenamesof(targetswithtraitsof(deps, "javalibrary")) + [
        t.args["jar"] for t in targetswithtraitsof(deps, "externaljar")
    ]

    dirs = {dirname(s) for s in srcitems.keys()}
    cs = (
        ["rm -rf {dir}/src {dir}/objs {outs[0]}", "mkdir -p {dir}/src"]
        + [
            "(cd {dir}/src && $(JAR) xf $(abspath " + f + "))"
            for f in filenamesof(targetswithtraitsof(deps, "srcjar"))
        ]
        + [
            " ".join(
                [
                    "$(JAVAC)",
                    "$(JFLAGS)",
                    "-d {dir}/objs",
                    " -cp " + (":".join(jardeps)) if jardeps else "",
                    "$$(find {dir}/src -name '*.java')",
                ]
                + [f"{filenameof(v)}" for v in srcitems.values()]
            ),
            "$(JAR) --create --no-compress --file {outs[0]} -C {self.dir}/objs .",
        ]
    )

    simplerule(
        replaces=self,
        ins=list(srcitems.values()) + deps,
        outs=[f"={name}.jar"],
        commands=cs,
        label="JAVALIBRARY",
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
        commands=["rm -rf {dir}/objs", "mkdir -p {dir}/objs"]
        + ["(cd {dir}/objs && $(JAR) xf $(abspath " + j + "))" for j in jars]
        + [
            "$(JAR) --create --file={outs[0]} --main-class="
            + mainclass
            + " -C {dir}/objs ."
        ],
        label="JAVAPROGRAM",
    )
