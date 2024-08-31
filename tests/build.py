from build.ab import simplerule, Rule, Target, export
from build.c import cprogram, cxxprogram, cheaders, clibrary, cxxlibrary
from build.protobuf import proto, protocc
from build.zip import zip
from build.utils import objectify

TESTS = [
    "clibrary",
    "cprogram",
    "dependency",
    "export",
    "invocation",
    "pkg",
    "protobuf",
    "simple",
]


@Rule
def test(self, name, test: Target):
    simplerule(
        replaces=self,
        ins=[
            "./" + self.localname + "/build.py",
        ],
        outs=["=build.mk"],
        deps=["build/ab.py", "build/c.py", "build/pkg.py"],
        commands=[
            "PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py "
            + " -q"
            + " -o {outs[0]}.bad {ins[0]}"
        ],
        label="TEST",
    )


cheaders(
    name="cheaders_compile_test",
    hdrs={"headers/test.h": "./cheaders_compile_test.h"},
    caller_cflags=["-DCHEADER"],
)
clibrary(
    name="clibrary_compile_test",
    srcs=["./cprogram_compile_test.c"],
    deps=[".+cheaders_compile_test"],
)
cprogram(
    name="cprogram_compile_test",
    srcs=["./cprogram_compile_test.c"],
    deps=[".+cheaders_compile_test"],
)
cxxlibrary(
    name="cxxlibrary_compile_test",
    srcs=["./cxxprogram_compile_test.cc"],
    deps=[".+cheaders_compile_test"],
)
cxxprogram(
    name="cxxprogram_compile_test",
    srcs=["./cxxprogram_compile_test.cc"],
    deps=[".+cheaders_compile_test"],
)
proto(name="proto_compile_test_proto", srcs=["./proto_compile_test.proto"])
protocc(name="proto_compile_test", srcs=[".+proto_compile_test_proto"])
zip(name="zip_test", flags="-0", items={"this/is/a/file.txt": "./README.md"})
objectify(name="objectify_test", src="./README.md", symbol="readme")

tests = [test(name=t, test=t) for t in TESTS] + [
    ".+clibrary_compile_test",
    ".+cprogram_compile_test",
    ".+cxxlibrary_compile_test",
    ".+cxxprogram_compile_test",
    ".+proto_compile_test",
    ".+zip_test",
    ".+objectify_test",
]

export(name="tests", deps=tests)
