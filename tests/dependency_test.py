from hamcrest import assert_that, equal_to
from build.ab2 import simplerule, filenamesof

r1 = simplerule(name="r1", ins=[], outs=["out1"])
r2 = simplerule(name="r2", ins=[], outs=["out2"])
ra = simplerule(name="all", ins=["+r1", "+r2"], outs=["outa"])
ra.materialise()
assert_that(filenamesof(ra.ins), equal_to(["out1", "out2"]))
assert_that(filenamesof(ra.outs), equal_to(["outa"]))
