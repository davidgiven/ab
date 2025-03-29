from build.ab import export, filenamesof, targetof
from hamcrest import (
    assert_that,
    empty,
    equal_to,
    has_property,
    contains_inanyorder,
)

re = export(name="all", items={}, deps=["tests/dot/module.with.dot+target"])
re.materialise()
