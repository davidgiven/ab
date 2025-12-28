from build.ab import simplerule, Rule, Target, export, Targets
from build.c import (
    cprogram,
    cxxprogram,
    clibrary,
    cxxlibrary,
    cfile,
    hostcxxprogram,
    cppfile,
)
from build.d import dprogram, dlibrary
from build.protobuf import proto, protocc, protojava, protolib
from build.zip import zip
from build.utils import objectify, itemsof
from build.java import javalibrary, javaprogram, externaljar, srcjar, mavenjar
from build.yacc import bison, flex

mavenjar(
    name="libprotobuf-java", artifact="com.google.protobuf:protobuf-java:3.19.6"
)


@Rule
def test(self, name, deps: Targets = []):
    simplerule(
        replaces=self,
        ins=[
            "./" + self.localname + "/build.py",
        ],
        outs=["=build.ninja", "=build.targets"],
        deps=[
            "build/ab.py",
            "build/c.py",
            "build/pkg.py",
            "build/protobuf.py",
            "build/toolchain.py",
            "build/utils.py",
        ]
        + deps,
        commands=[
            "PKG_CONFIG_PATH=tests/pkg/pkg-repo "
            + "$(PYTHON) -X pycache_prefix=$(OBJ) build/ab.py "
            + "-DPKG_CONFIG=pkg-config "
            + "-DHOST_PKG_CONFIG=pkg-config "
            + "-DPYTHON=python "
            + "-DOSX=no "
            + "-DCXX=cxx "
            + "-DHOSTCXX=hostcxx "
            + "-DCC=cc "
            + "-DCFLAGS=cflags "
            + "-DHOSTCFLAGS=hostcflags "
            + "-DCXXFLAGS=cxxflags "
            + "-DLDFLAGS=ldflags "
            + "-DHOSTLDFLAGS=hostldflags "
            + "-DCP=cp "
            + "-DAR=ar "
            + "-DEXT=.exe "
            + "-DCWD=cwd "
            + "-DOBJ=OBJ "
            + " -q"
            + " -o $[dir]"
            + " $[ins[0]]"
        ],
        label="TEST",
    )


clibrary(
    name="cheaders_compile_test",
    hdrs={"headers/test.h": "./cheaders_compile_test.h"},
    caller_cflags=["-DCHEADER"],
)
cppfile(
    name="cppfile_compile_test",
    srcs=["./cprogram_compile_test.c"],
    deps=[".+cheaders_compile_test"],
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
    deps=[".+cheaders_compile_test"],
)
cxxprogram(
    name="cxxprogram_compile_test",
    srcs=["./cxxprogram_compile_test.cc"],
    deps=[".+cheaders_compile_test"],
)
hostcxxprogram(
    name="hostcxxprogram_compile_test",
    srcs=["./cxxprogram_compile_test.cc"],
    deps=[".+cheaders_compile_test"],
)
proto(name="proto_compile_test_proto", srcs=["./proto_compile_test.proto"])
protolib(
    name="proto_compile_test_protolib", srcs=[".+proto_compile_test_proto"]
)
protocc(name="cc_proto_compile_test", srcs=[".+proto_compile_test_protolib"])
proto(
    name="proto_compile_test2_proto",
    srcs=["./proto_compile_test2.proto"],
    deps=[".+proto_compile_test_proto"],
)
protocc(
    name="cc_proto_compile_test2",
    srcs=[".+proto_compile_test2_proto"],
    deps=[".+cc_proto_compile_test"],
)
protojava(
    name="java_proto_compile_test",
    srcs=[".+proto_compile_test_proto"],
    deps=[".+libprotobuf-java"],
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
    deps=[".+cc_proto_compile_test2"],
    ldflags=["-lfl"],
)

dlibrary(
    name="dlibrary_compile_test_foo",
    srcs=[
        "./dlibrary_compile_test_foo.d",
    ],
)

dlibrary(
    name="dlibrary_compile_test_bar",
    srcs=[
        "./dlibrary_compile_test.d",
        "./dlibrary_compile_test_bar.d",
    ],
    deps=[".+dlibrary_compile_test_foo"],
)

dprogram(
    name="dprogram_compile_test",
    srcs=["./dprogram_compile_test.d"],
    deps=[".+dlibrary_compile_test_bar"],
)

tests = [
    test(name="args"),
    test(name="clibrary"),
    test(name="cprogram"),
    test(name="dependency"),
    test(name="dot", deps=["./dot/module.with.dot/build.py"]),
    test(name="export"),
    test(
        name="glob",
        deps=[
            "./glob/testfile.exclude.py",
            "./glob/testfile.include",
            "./glob/subdir/testfile.q",
        ],
    ),
    test(name="formatter"),
    test(name="invocation"),
    test(name="pkg", deps=["tests/pkg/pkg-repo/ab-sample-pkg.pc"]),
    test(name="protobuf"),
    test(name="simple"),
    test(name="toolchain"),
    ".+cfile_compile_test",
    ".+cppfile_compile_test",
    ".+clibrary_compile_test",
    ".+cprogram_compile_test",
    ".+cxxlibrary_compile_test",
    ".+cxxprogram_compile_test",
    ".+hostcxxprogram_compile_test",
    ".+javaprogram_compile_test",
    ".+javalibrary_compile_test",
    ".+objectify_test",
    ".+cc_proto_compile_test",
    ".+java_proto_compile_test",
    ".+bison_compile_test",
    ".+zip_test",
    ".+dprogram_compile_test",
    ".+dlibrary_compile_test_foo",
]


export(name="tests", deps=tests)
