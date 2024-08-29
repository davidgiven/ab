from build.ab import simplerule, Rule, Target, export
from build.c import cprogram, cxxprogram
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
            "./" + self.localname + "/good.mk",
        ],
        outs=["=build.mk"],
        deps=["build/ab.py", "build/c.py", "build/pkg.py"],
        commands=[
            "PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py "
            + " -o {outs[0]}.bad {ins[0]}"
            + " || (rm -f {outs} && false)",
            "diff -uN {ins[1]} {outs[0]}.bad || (echo 'Use this command to update the good file:' && echo cp {outs[0]}.bad {ins[1]} && false)",
            "mv {outs[0]}.bad {outs[0]}",
        ],
        label="TEST",
    )


cprogram(name="cprogram_compile_test", srcs=["./cprogram_compile_test.c"])
cxxprogram(
    name="cxxprogram_compile_test", srcs=["./cxxprogram_compile_test.cc"]
)
proto(name="proto_compile_test_proto", srcs=["./proto_compile_test.proto"])
protocc(name="proto_compile_test", srcs=[".+proto_compile_test_proto"])
zip(name="zip_test", flags="-0", items={"this/is/a/file.txt": "./README.md"})
objectify(name="objectify_test", src="./README.md", symbol="readme")

tests = [test(name=t, test=t) for t in TESTS] + [
    ".+cprogram_compile_test",
    ".+cxxprogram_compile_test",
    ".+proto_compile_test",
    ".+zip_test",
    ".+objectify_test",
]

export(name="tests", deps=tests)
