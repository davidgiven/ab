from build.ab import export, filenamesof, targetnamesof
from build.protobuf import proto, protocc
from hamcrest import assert_that, empty, equal_to, contains_inanyorder

re1 = proto(name="protolib", srcs=["./test.proto"])
re2 = proto(name="protolib2", srcs=["./test2.proto"], deps=[".+protolib"])

rec = protocc(name="protolib_c", srcs=[".+protolib", ".+protolib2"])

re = export(name="all", items={}, deps=[".+protolib2", ".+protolib_c"])
re.materialise()

assert_that(re1.name, equal_to("tests/protobuf/+protolib"))
assert_that(targetnamesof(re1.deps), empty())
assert_that(
    targetnamesof(re1.ins), contains_inanyorder("tests/protobuf/test.proto")
)
assert_that(
    filenamesof(re1.outs),
    contains_inanyorder(
        "$(OBJ)/tests/protobuf/+protolib/tests/protobuf/+protolib.descriptor"
    ),
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
        "$(OBJ)/tests/protobuf/+protolib2/tests/protobuf/+protolib2.descriptor"
    ),
)

assert_that(rec.name, equal_to("tests/protobuf/+protolib_c"))
assert_that(
    targetnamesof(rec.ins),
    contains_inanyorder(
        "tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc",
        "tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc",
    ),
)

assert_that(
    filenamesof(rec.outs),
    contains_inanyorder(
        "$(OBJ)/tests/protobuf/+protolib_c/protolib_c.a",
    ),
)
