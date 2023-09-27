from build.ab2 import export
from build.c import cfile, cxxfile, cprogram

cfile(name="cfile", srcs=["./cfile.c"], cflags=["-cflag"])
cxxfile(name="cxxfile", srcs=["./cxxfile.c"], cflags=["-cxxflag"])

cprogram(
    name="cprogram",
    srcs=["./implicitcfile.c", "+cfile"],
    cflags=["-cprogram-cflag"],
)

export(name="all", items={}, deps=["+cfile", "+cxxfile", "+cprogram"])
