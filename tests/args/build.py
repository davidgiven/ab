from build.ab import export, flatten, filenamesof, targetnamesof
from build.c import cfile, cxxfile, cprogram, cxxprogram
from hamcrest import assert_that, equal_to, contains_inanyorder

rp = cprogram(name="program", srcs=["srcfile.c"], args={"explicit": True})
rp.materialise()

rf = rp.ins[0]
assert_that(rp.args["explicit"], equal_to(True))
assert_that(rf.args["explicit"], equal_to(True))
