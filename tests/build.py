from build.ab import simplerule, Rule, Target, export
from build.c import (
    cprogram,
    cxxprogram,
    cheaders,
    clibrary,
    cxxlibrary,
    cfile,
    cxxmodule,
)
from build.protobuf import proto, protocc, protojava
from build.zip import zip
from build.utils import objectify, itemsof
from build.java import javalibrary, javaprogram, externaljar, srcjar
from build.yacc import bison, flex

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
            + " -o {outs[0]} {ins[0]}"
        ],
        label="TEST",
    )


cheaders(
    name="cheaders_compile_test",
    hdrs={"headers/test.h": "./cheaders_compile_test.h"},
    caller_cflags=["-DCHEADER"],
)
cfile(
    name="cfile_compile_test",
    srcs=["./cprogram_compile_test.c"],
    deps=[".+cheaders_compile_test"],
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
    cflags=["-DNO_MODULE"],
    deps=[".+cheaders_compile_test"],
)
cxxmodule(
    name="cxxmodule_compile_test",
    srcs=["./cxxmodule_compile_test.cc", "./cxxmodule_extra_compile_test.cc"],
)
cxxprogram(
    name="cxxprogram_compile_test",
    srcs=["./cxxprogram_compile_test.cc"],
    deps=[".+cheaders_compile_test", ".+cxxmodule_compile_test"],
)
externaljar(name="protobuf_lib", paths=["/usr/share/java/protobuf.jar"])
proto(name="proto_compile_test_proto", srcs=["./proto_compile_test.proto"])
protocc(name="cc_proto_compile_test", srcs=[".+proto_compile_test_proto"])
protojava(
    name="java_proto_compile_test",
    srcs=[".+proto_compile_test_proto"],
    deps=[".+protobuf_lib"],
)
zip(name="zip_test", flags="-0", items={"this/is/a/file.txt": "./README.md"})
objectify(name="objectify_test", src="./README.md", symbol="readme")
externaljar(
    name="external_jar",
    paths=["/usr/share/java/guava.jar", "/usr/share/java/guava/guava.jar"],
)
srcjar(
    name="javalibrary_srcjar", items=itemsof("./javalibrary_compile_test.java")
)
javalibrary(
    name="javalibrary_compile_test",
    deps=[".+external_jar", ".+javalibrary_srcjar"],
)
javaprogram(
    name="javaprogram_compile_test",
    srcitems=itemsof("./java_compile_test.java"),
    deps=[".+javalibrary_compile_test", ".+external_jar"],
    mainclass="com.cowlark.ab.java_compile_test",
)

flex(name="flex_compile_test.flex", src="./flex_compile_test.l")
bison(
    name="bison_compile_test.bison", src="./bison_compile_test.y", stem="y.tab"
)
cprogram(
    name="bison_compile_test",
    srcs=[".+bison_compile_test.bison", ".+flex_compile_test.flex"],
    ldflags=["-lfl"],
)

tests = [test(name=t, test=t) for t in TESTS] + [
    ".+cfile_compile_test",
    ".+clibrary_compile_test",
    ".+cprogram_compile_test",
    ".+cxxlibrary_compile_test",
    ".+cxxmodule_compile_test",
    ".+cxxprogram_compile_test",
    ".+javaprogram_compile_test",
    ".+javalibrary_compile_test",
    ".+objectify_test",
    ".+cc_proto_compile_test",
    ".+java_proto_compile_test",
    ".+bison_compile_test",
    ".+zip_test",
]

export(name="tests", deps=tests)
