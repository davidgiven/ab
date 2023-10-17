from build.ab import simplerule, filenamesof, flatten, targetnamesof
from hamcrest import assert_that, equal_to, contains_inanyorder, empty

ra = simplerule(name="r1", ins=[], outs=["out1"])
rb = simplerule(name="r2", ins=[], outs=["out2"])
re = simplerule(name="all", ins=["+r1", "+r2"], outs=["outa"])

re.materialise()

assert_that(ra.name, equal_to("tests/dependency+r1"))
assert_that(filenamesof(flatten(ra.ins)), empty())
assert_that(filenamesof(flatten(ra.outs)), contains_inanyorder("out1"))

assert_that(rb.name, equal_to("tests/dependency+r2"))
assert_that(filenamesof(flatten(rb.ins)), empty())
assert_that(filenamesof(flatten(rb.outs)), contains_inanyorder("out2"))

assert_that(re.name, equal_to("tests/dependency+all"))
assert_that(targetnamesof(re.ins), contains_inanyorder(ra.name, rb.name))
assert_that(filenamesof(re.ins), contains_inanyorder("out1", "out2"))
assert_that(filenamesof(re.outs), contains_inanyorder("outa"))
