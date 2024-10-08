from build.ab import export, targetnamesof, filenamesof, targets
from build.c import clibrary, cprogram, cfile, cheaders
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

hl2 = cheaders(name="cheaders2", deps=[".+clibrary2"])

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
    equal_to(["--cheaders-cflags", "-I$(OBJ)/tests/clibrary/+cheaders"]),
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
    ),
)
assert_that(rl2.args, has_item("caller_cflags"))
assert_that(
    # This is the caller_cflags passed in by the user, not the one computed from
    # the header rule.
    rl2.args["caller_cflags"],
    contains_inanyorder(
        "--clibrary2-cflags",
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
assert_that(len(rl2.args["cheader_deps"]), equal_to(2))
assert_that(rl2.args["cheader_deps"], has_item(hl))
[rl2h] = rl2.args["cheader_deps"] - {hl}

assert_that(rl2h.name, equal_to("tests/clibrary/+clibrary2_hdrs"))
assert_that(
    targetnamesof(rl2h.ins),
    contains_inanyorder("tests/clibrary/library2.h"),
)
assert_that(
    filenamesof(rl2h.outs),
    contains_inanyorder("$(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h"),
)
assert_that(rl2h.args, has_item("caller_cflags"))
assert_that(
    rl2h.args["caller_cflags"],
    contains_inanyorder(
        "--clibrary2-cflags",
        "-I$(OBJ)/tests/clibrary/+clibrary2_hdrs",
    ),
)

assert_that(rp.name, equal_to("tests/clibrary/+cprogram"))
assert_that(
    targetnamesof(rp.ins),
    contains_inanyorder(
        "tests/clibrary/+cfile",
        "$(OBJ)/tests/clibrary/+clibrary/clibrary.a",
        "$(OBJ)/tests/clibrary/+clibrary2/clibrary2.a",
    ),
)

assert_that(hl2.name, equal_to("tests/clibrary/+cheaders2"))
assert_that(filenamesof(hl2.ins), empty())
assert_that(filenamesof(hl2.outs), empty())
assert_that(
    filenamesof(hl2.deps),
    contains_inanyorder("$(OBJ)/tests/clibrary/+clibrary2/clibrary2.a"),
)
