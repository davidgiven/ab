from build.ab import export, targetnamesof, filenamesof
from build.c import clibrary, cprogram, cfile
from hamcrest import assert_that, equal_to, contains_inanyorder, has_item

hl = clibrary(
    name="cheaders",
    hdrs={"library.h": "./library.h"},
    caller_cflags=["--cheader-cflags"],
)

rl = clibrary(
    name="clibrary", srcs=["./lib1.c", "./lib2.cc"], deps=[".+cheaders"]
)

rl2 = clibrary(
    name="clibrary2",
    srcs=["./lib1.c", "./lib2.cc"],
    hdrs={"library2.h": "./library2.h"},
    deps=[".+cheaders"],
    caller_cflags=["--cheader-cflags2"],
)

rf = cfile(name="cfile", srcs=["./prog.c"], deps=[".+cheaders"])

rp = cprogram(name="cprogram", srcs=[".+cfile"], deps=[".+clibrary"])

re = export(
    name="all",
    items={},
    deps=[".+cprogram", ".+cheaders", ".+clibrary2"],
)

re.materialise()
assert_that(re.name, equal_to("tests/clibrary/+all"))

assert_that(hl.name, equal_to("tests/clibrary/+cheaders"))
assert_that(hl.args, has_item("caller_cflags"))
assert_that(
    hl.args["caller_cflags"],
    equal_to(["--cheader-cflags", "-I$(OBJ)/tests/clibrary/+cheaders"]),
)

assert_that(rl.name, equal_to("tests/clibrary/+clibrary"))
assert_that(
    targetnamesof(rl.ins),
    contains_inanyorder(
        "tests/clibrary/+clibrary/tests/clibrary/lib1.c",
        "tests/clibrary/+clibrary/tests/clibrary/lib2.cc",
    ),
)
assert_that(
    filenamesof(rl.outs),
    contains_inanyorder("$(OBJ)/tests/clibrary/+clibrary/clibrary.a"),
)

assert_that(rf.name, equal_to("tests/clibrary/+cfile"))
assert_that(targetnamesof(rf.ins), contains_inanyorder("tests/clibrary/prog.c"))
assert_that(
    targetnamesof(rf.deps), contains_inanyorder("tests/clibrary/+cheaders")
)

assert_that(rp.name, equal_to("tests/clibrary/+cprogram"))
assert_that(
    targetnamesof(rp.ins),
    contains_inanyorder(
        "tests/clibrary/+cfile",
        "$(OBJ)/tests/clibrary/+clibrary/clibrary.a",
        "$(OBJ)/tests/clibrary/+clibrary/clibrary.a",
    ),
)

assert_that(rl2.name, equal_to("tests/clibrary/+clibrary2"))
assert_that(
    targetnamesof(rl2.ins),
    contains_inanyorder(
        "tests/clibrary/+clibrary2/tests/clibrary/lib1.c",
        "tests/clibrary/+clibrary2/tests/clibrary/lib2.cc",
    ),
)
assert_that(
    filenamesof(rl2.outs),
    contains_inanyorder(
        "$(OBJ)/tests/clibrary/+clibrary2/clibrary2.a",
        "$(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h",
    ),
)
assert_that(rl2.args, has_item("caller_cflags"))
assert_that(
    rl2.args["caller_cflags"],
    contains_inanyorder(
        "--cheader-cflags",
        "--cheader-cflags2",
        "-I$(OBJ)/tests/clibrary/+cheaders",
        "-I$(OBJ)/tests/clibrary/+clibrary2_hdrs",
    ),
)
