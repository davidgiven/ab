from build.ab import export, filenamesof
from hamcrest import assert_that, empty, equal_to

re = export(name="all", items={}, deps=[])

re.materialise()
assert_that(re.name, equal_to("tests/simple+all"))
assert_that(filenamesof(re.ins), empty())
assert_that(filenamesof(re.outs), empty())
