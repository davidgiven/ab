from build.ab import export
from build.c import clibrary, cprogram

clibrary(name="clibrary", srcs=["./lib1.c", "./lib2.cc"], hdrs=["./library.h"])

cprogram(name="cprogram", srcs=["./prog.c"], deps=["+clibrary"])

export(
    name="all",
    items={},
    deps=["+cprogram"],
)
