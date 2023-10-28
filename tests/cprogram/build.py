from build.ab import export, flatten, filenamesof, targetnamesof
from build.c import cfile, cxxfile, cprogram, cxxprogram
from hamcrest import assert_that, equal_to, contains_inanyorder

rcf = cfile(name="cfile", srcs=["./cfile.c"], cflags=["-cflag"])

rcf.materialise()
assert_that(rcf.name, equal_to("tests/cprogram+cfile"))
assert_that(filenamesof(rcf.ins), contains_inanyorder("tests/cprogram/cfile.c"))
assert_that(
    targetnamesof(rcf.ins), contains_inanyorder("tests/cprogram/cfile.c")
)
assert_that(
    filenamesof(rcf.outs),
    contains_inanyorder("$(OBJ)/tests/cprogram+cfile/cfile.o"),
)

rccf = cxxfile(name="cxxfile", srcs=["./cxxfile.c"], cflags=["-cxxflag"])

rccf.materialise()
assert_that(rccf.name, equal_to("tests/cprogram+cxxfile"))
assert_that(
    filenamesof(rccf.ins), contains_inanyorder("tests/cprogram/cxxfile.c")
)
assert_that(
    targetnamesof(rccf.ins), contains_inanyorder("tests/cprogram/cxxfile.c")
)
assert_that(
    filenamesof(rccf.outs),
    contains_inanyorder("$(OBJ)/tests/cprogram+cxxfile/cxxfile.o"),
)

rp = cprogram(
    name="cprogram",
    srcs=["./implicitcfile.c", ".+cfile"],
    cflags=["-cprogram-cflag"],
    ldflags=["-ldflag"],
)

rp.materialise()
assert_that(rp.name, equal_to("tests/cprogram+cprogram"))
assert_that(
    filenamesof(rp.ins),
    contains_inanyorder(
        "$(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o",
        "$(OBJ)/tests/cprogram+cfile/cfile.o",
    ),
)
assert_that(
    targetnamesof(rp.ins),
    contains_inanyorder(
        "tests/cprogram+cprogram/tests/cprogram/implicitcfile.c",
        "tests/cprogram+cfile",
    ),
)
assert_that(
    filenamesof(rp.outs),
    contains_inanyorder(
        "$(OBJ)/tests/cprogram+cprogram/cprogram+cprogram$(EXT)"
    ),
)

cxxprogram(
    name="cxxprogram",
    srcs=["./implicitcxxfile.cc", ".+cxxfile"],
    cflags=["-cxxprogram-cflag"],
    ldflags=["-ldflag"],
)

export(
    name="all",
    items={},
    deps=[".+cfile", ".+cxxfile", ".+cprogram", ".+cxxprogram"],
)
