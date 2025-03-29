from build.ab import export, filenamesof, targetof
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
assert_that(filenamesof(re.outs), empty())
assert_that(re, has_property("args"))

rf = re.targetof("file.txt")
rf.materialise()
assert_that(rf.name, equal_to("file.txt"))
assert_that(filenamesof(rf.ins), empty())
assert_that(filenamesof(rf.outs), contains_inanyorder("file.txt"))
assert_that(rf, has_property("args"))

rg = targetof("file.txt")
rg.materialise()
assert_that(rg.name, equal_to("file.txt"))
assert_that(filenamesof(rg.ins), empty())
assert_that(filenamesof(rg.outs), contains_inanyorder("file.txt"))
assert_that(rg, has_property("args"))
