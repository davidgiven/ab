from build.ab import export, targetnamesof, filenamesof, targets
from build.c import clibrary, cprogram, cfile
from hamcrest import assert_that, equal_to, contains_inanyorder, has_item, empty

hl = clibrary(
    name="cheaders",
    hdrs={"library.h": "./library.h"},
    caller_cflags=["--cheaders-cflags"],
)

rl = clibrary(
    name="clibrary", srcs=["./lib1.c", "./lib2.cc"], deps=[".+cheaders"]
)

rl2 = clibrary(
    name="clibrary2",
    srcs=["./lib1.c", "./lib2.cc"],
    hdrs={"library2.h": "./library2.h"},
    deps=[".+cheaders", ".+clibrary"],
    caller_cflags=["--clibrary2-cflags"],
    caller_ldflags=["--clibrary2-ldflags"],
)

hl2 = clibrary(name="cheaders2", deps=[".+clibrary2"])

rf = cfile(name="cfile", srcs=["./prog.c"], deps=[".+cheaders"])

rp = cprogram(name="cprogram", srcs=[".+cfile"], deps=[".+clibrary2"])

re = export(
    name="all",
    items={},
    deps=[".+cprogram", ".+cheaders", ".+clibrary", ".+cheaders2"],
)

re.materialise()
assert_that(re.name, equal_to("tests/clibrary/+all"))

assert_that(hl.name, equal_to("tests/clibrary/+cheaders"))
assert_that(hl.args, has_item("caller_cflags"))
assert_that(
    hl.args["caller_cflags"],
    equal_to(["--cheaders-cflags", "-I$(OBJ)/tests/clibrary/+cheaders_hdr"]),
)

assert_that(rl.name, equal_to("tests/clibrary/+clibrary"))
assert_that(
    targetnamesof(rl.outs), contains_inanyorder("tests/clibrary/+clibrary_lib")
)
assert_that(
    filenamesof(rl.outs),
    contains_inanyorder("$(OBJ)/tests/clibrary/+clibrary_lib/clibrary.a"),
)

assert_that(rf.name, equal_to("tests/clibrary/+cfile"))
assert_that(targetnamesof(rf.ins), contains_inanyorder("tests/clibrary/prog.c"))
assert_that(
    targetnamesof(rf.deps), contains_inanyorder("tests/clibrary/+cheaders")
)

assert_that(rl2.name, equal_to("tests/clibrary/+clibrary2"))
assert_that(targetnamesof(rl2.ins), empty())
assert_that(
    filenamesof(rl2.outs),
    contains_inanyorder(
        "$(OBJ)/tests/clibrary/+clibrary2_lib/clibrary2.a",
        "$(OBJ)/tests/clibrary/+clibrary2_hdr/library2.h",
    ),
)
assert_that(rl2.args, has_item("caller_cflags"))
assert_that(
    # This is the caller_cflags passed in by the user, not the one computed from
    # the header rule.
    rl2.args["caller_cflags"],
    contains_inanyorder(
        "--clibrary2-cflags", "-I$(OBJ)/tests/clibrary/+clibrary2_hdr"
    ),
)
assert_that(rl2.args, has_item("caller_ldflags"))
assert_that(
    # This is the caller_ldflags passed in by the user.
    rl2.args["caller_ldflags"],
    contains_inanyorder(
        "--clibrary2-ldflags",
    ),
)
assert_that(rl2.args, has_item("cheader_deps"))
assert_that(
    targetnamesof(rl2.args["cheader_deps"]),
    contains_inanyorder(
        "tests/clibrary/+clibrary2",
        "tests/clibrary/+clibrary",
        "tests/clibrary/+cheaders",
    ),
)
t = targets["tests/clibrary/+clibrary2_hdr"]
t.materialise()
assert_that(t.name, equal_to("tests/clibrary/+clibrary2_hdr"))
assert_that(
    targetnamesof(t.ins),
    contains_inanyorder("tests/clibrary/library2.h"),
)
assert_that(
    filenamesof(t.outs),
    contains_inanyorder("$(OBJ)/tests/clibrary/+clibrary2_hdr/library2.h"),
)

assert_that(rp.name, equal_to("tests/clibrary/+cprogram"))
assert_that(
    targetnamesof(rp.ins),
    contains_inanyorder(
        "tests/clibrary/+cfile",
        "$(OBJ)/tests/clibrary/+clibrary_lib/clibrary.a",
        "$(OBJ)/tests/clibrary/+clibrary2_lib/clibrary2.a",
    ),
)

assert_that(hl2.name, equal_to("tests/clibrary/+cheaders2"))
assert_that(filenamesof(hl2.ins), empty())
assert_that(filenamesof(hl2.outs), empty())
assert_that(filenamesof(hl2.deps), empty())
