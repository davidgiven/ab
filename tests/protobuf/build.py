from build.ab import export, filenamesof, targetnamesof, targetof, targets
from build.protobuf import proto, protocc, protolib
from hamcrest import (
    assert_that,
    empty,
    equal_to,
    contains_inanyorder,
    has_item,
    has_items,
)

re1 = proto(name="protolib", srcs=["./test.proto"])
re2 = proto(name="protolib2", srcs=["./test2.proto"], deps=[".+protolib"])
rel = protolib(name="combined", srcs=[".+protolib", ".+protolib2"])

rec = protocc(
    name="protolib_c", srcs=[".+protolib", ".+protolib2", ".+combined"]
)

re = export(name="all", items={}, deps=[".+protolib2", ".+protolib_c"])
re.materialise()

assert_that(re1.name, equal_to("tests/protobuf/+protolib"))
assert_that(targetnamesof(re1.deps), empty())
assert_that(
    targetnamesof(re1.ins), contains_inanyorder("tests/protobuf/test.proto")
)
assert_that(
    filenamesof(re1.outs),
    contains_inanyorder("OBJ/tests/protobuf/+protolib/protolib.descriptor"),
)
assert_that(re1.args, has_item("protodeps"))
assert_that(
    targetnamesof(re1.args["protodeps"]),
    contains_inanyorder("tests/protobuf/+protolib"),
)

assert_that(re2.name, equal_to("tests/protobuf/+protolib2"))
assert_that(
    targetnamesof(re2.deps), contains_inanyorder("tests/protobuf/+protolib")
)
assert_that(
    targetnamesof(re2.ins), contains_inanyorder("tests/protobuf/test2.proto")
)
assert_that(
    filenamesof(re2.outs),
    contains_inanyorder(
        "OBJ/tests/protobuf/+protolib2/protolib2.descriptor"
    ),
)
assert_that(re2.args, has_item("protodeps"))
assert_that(
    targetnamesof(re2.args["protodeps"]),
    contains_inanyorder(
        "tests/protobuf/+protolib", "tests/protobuf/+protolib2"
    ),
)

assert_that(rel.name, equal_to("tests/protobuf/+combined"))
assert_that(rel.ins, empty())
assert_that(rel.outs, empty())
assert_that(rel.args, has_items("protodeps", "protosrcs"))
assert_that(
    rel.args["protosrcs"],
    contains_inanyorder(
        "tests/protobuf/test.proto", "tests/protobuf/test2.proto"
    ),
)
assert_that(
    targetnamesof(rel.args["protodeps"]),
    contains_inanyorder(
        "tests/protobuf/+protolib", "tests/protobuf/+protolib2"
    ),
)

assert_that(rec.name, equal_to("tests/protobuf/+protolib_c"))
assert_that(targetnamesof(rec.ins), empty())
assert_that(
    targetnamesof(rec.outs),
    contains_inanyorder(
        "tests/protobuf/+protolib_c_hdr", "tests/protobuf/+protolib_c_lib"
    ),
)
assert_that(rec.traits, contains_inanyorder("cxxlibrary", "protocc"))
assert_that(
    rec.args, has_items("clibrary_deps", "cheader_deps", "caller_cflags")
)
assert_that(
    rec.args["caller_cflags"],
    contains_inanyorder("-IOBJ/tests/protobuf/+protolib_c_hdr"),
)

ret = targetof(
    "tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc"
)
assert_that(
    ret.args["cflags"],
    contains_inanyorder(
        "-IOBJ/tests/protobuf/+protolib_c_hdr",
        "-IOBJ/tests/protobuf/+protolib_c_srcs/tests/protobuf",
    ),
)
