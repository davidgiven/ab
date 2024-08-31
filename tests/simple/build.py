from build.ab import export, filenamesof
from hamcrest import (
    assert_that,
    empty,
    equal_to,
    has_property,
    contains_inanyorder,
)

re = export(name="all", items={}, deps=[])
re.materialise()
assert_that(re.name, equal_to("tests/simple/+all"))
assert_that(filenamesof(re.ins), empty())
assert_that(
    filenamesof(re.outs),
    contains_inanyorder("$(OBJ)/tests/simple/+all/sentinel"),
)
assert_that(re, has_property("args"))

rf = re.targetof("file.txt")
rf.materialise()
assert_that(rf.name, equal_to("file.txt"))
assert_that(filenamesof(rf.ins), empty())
assert_that(filenamesof(rf.outs), contains_inanyorder("file.txt"))
assert_that(rf, has_property("args"))
