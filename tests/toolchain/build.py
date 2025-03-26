from build.ab import export
from build.c import clibrary
from build.toolchain import Toolchain
from hamcrest import assert_that, equal_to, contains_string

class CustomToolchain(Toolchain):
    PREFIX="CUSTOM"
    CC = ["customcc"]

lib1 = clibrary(name="lib1", srcs=["./lib1.c"], toolchain=Toolchain)
lib2 = clibrary(name="lib2", srcs=["./lib2.c"], toolchain=CustomToolchain)

re = export(name="all", items={}, deps=[".+lib1", ".+lib2"])
re.materialise()

lib1src = lib1.deps[0].ins[0]
lib2src = lib2.deps[0].ins[0]
assert_that(lib1src.args["commands"][0], contains_string("$(CC)"))
assert_that(lib2src.args["commands"][0], equal_to("customcc"))
