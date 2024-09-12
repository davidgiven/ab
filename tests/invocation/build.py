from build.ab import (
    export,
    simplerule,
    filenamesof,
    Rule,
)
from hamcrest import (
    assert_that,
    empty,
    equal_to,
    contains_inanyorder,
    has_entries,
)


@Rule
def writetext(self, name):
    simplerule(
        replaces=self,
        ins=[],
        outs=[f"={self.localname}.txt"],
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

# Check that kwargs in rules works to get all arguments.


@Rule
def kwargs_test_rule(self, name, **kwargs):
    self.kwargs = kwargs


kr = kwargs_test_rule(name="kr", a=1, b=2, c=3)
kr.materialise()
assert_that(kr.kwargs, has_entries({"a": 1, "b": 2, "c": 3}))
