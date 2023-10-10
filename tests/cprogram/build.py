from build.ab import export
from build.c import cfile, cxxfile, cprogram, cxxprogram

cfile(name="cfile", srcs=["./cfile.c"], cflags=["-cflag"])
cxxfile(name="cxxfile", srcs=["./cxxfile.c"], cflags=["-cxxflag"])

cprogram(
    name="cprogram",
    srcs=["./implicitcfile.c", "+cfile"],
    cflags=["-cprogram-cflag"],
    ldflags=["-ldflag"],
)

cxxprogram(
    name="cxxprogram",
    srcs=["./implicitcxxfile.cc", "+cxxfile"],
    cflags=["-cxxprogram-cflag"],
    ldflags=["-ldflag"],
)

export(
    name="all",
    items={},
    deps=["+cfile", "+cxxfile", "+cprogram", "+cxxprogram"],
)
