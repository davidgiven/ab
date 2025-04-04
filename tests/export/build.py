from build.ab import simplerule, export, filenamesof, targetof
from hamcrest import assert_that, equal_to, contains_inanyorder, has_item, empty

ra = simplerule(name="r1", ins=[], outs=["=out1"])
rb = simplerule(name="r2", ins=[], outs=["=out2"])
re = simplerule(name="re", ins=[".+r1", ".+r2"], outs=["=outa"])

x1 = export(name="x1", items={"out1":"./out1"})
x2 = export(name="x2", items={"out2":"./out2"}, deps=[".+x1"])
x3 = export(name="x3", items={"out3":"./out3"}, deps=[".+x2"])

export(name="all", items={"r1": ".+r1", "r2": ".+r2"}, deps=[".+x2"])
targetof(".+all").materialise()

assert_that(filenamesof([x1]), contains_inanyorder("out1"))
assert_that(filenamesof([x2]), contains_inanyorder("out1", "out2"))
assert_that(filenamesof([x3]), contains_inanyorder("out1", "out2", "out3"))