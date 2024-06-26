from build.ab import (
    export,
    normalrule,
    filenamesof,
    targetnamesof,
    Rule,
    Target,
    bubbledattrsof,
)
from hamcrest import assert_that, empty, equal_to, contains_inanyorder


@Rule
def writetext(self, name):
    normalrule(
        replaces=self,
        ins=[],
        outs=[self.localname + ".txt"],
        commands=["echo %s > {outs[0]}" % name],
        label="WRITETEXT",
    )


r1 = writetext(name="r1")
r2 = writetext(name="r2")
re = export(name="all", deps=[".+r1", ".+r2", "+fortesting"])

re.materialise()
assert_that(r1.name, equal_to("tests/invocation/+r1"))
assert_that(filenamesof(r1.ins), empty())
assert_that(
    filenamesof(r1.outs),
    contains_inanyorder("$(OBJ)/tests/invocation/+r1/r1.txt"),
)

# Set functionality: Invocations are comparable by long name.

assert_that({r1}, contains_inanyorder(r1))
assert_that({r1, r2}, contains_inanyorder(r1, r2))
assert_that({r1, r1, r2}, contains_inanyorder(r1, r2))

# attrdeps

r3 = writetext(name="r3")
r3.attr.thing = ["thingvalue1"]

r4 = writetext(name="r4")
r4.attr.thing = ["thingvalue2"]
r4.bubbleattr("thing", r3)

r3.materialise()
r4.materialise()
assert_that(
    bubbledattrsof([r3, r4], "thing"),
    contains_inanyorder("thingvalue1", "thingvalue2"),
)
