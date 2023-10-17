from build.ab import export, targetnamesof, filenamesof
from build.c import clibrary, cprogram, cfile
from hamcrest import assert_that, equal_to, empty, contains_inanyorder

rl = clibrary(
    name="clibrary",
    srcs=["./lib1.c", "./lib2.cc"],
    hdrs={"library.h": "./library.h"},
)

rf = cfile(name="cfile", srcs=["./prog.c"], deps=["+clibrary"])

rp = cprogram(name="cprogram", srcs=["+cfile"], deps=["+clibrary"])

re = export(
    name="all",
    items={},
    deps=["+cprogram"],
)

re.materialise()
assert_that(re.name, equal_to("tests/clibrary+all"))

assert_that(rl.name, equal_to("tests/clibrary+clibrary"))
assert_that(
    targetnamesof(rl.ins),
    contains_inanyorder(
        "tests/clibrary+clibrary/tests/clibrary/lib1.c",
        "tests/clibrary+clibrary/tests/clibrary/lib2.cc",
    ),
)
assert_that(
    filenamesof(rl.outs),
    contains_inanyorder(
        "$(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a",
        "$(OBJ)/tests/clibrary+clibrary/$(OBJ)/tests/clibrary+clibrary/library.h",
    ),
)

assert_that(rf.name, equal_to("tests/clibrary+cfile"))
assert_that(targetnamesof(rf.ins), contains_inanyorder("tests/clibrary/prog.c"))
assert_that(
    targetnamesof(rf.deps), contains_inanyorder("tests/clibrary+clibrary")
)

assert_that(rp.name, equal_to("tests/clibrary+cprogram"))
assert_that(
    targetnamesof(rp.ins),
    contains_inanyorder(
        "tests/clibrary+cfile",
        "$(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a",
    ),
)
