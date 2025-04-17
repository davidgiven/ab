from build.ab import export, targetnamesof, targets, filenamesof
from build.pkg import package
from build.c import cprogram, clibrary
from hamcrest import assert_that, equal_to, contains_inanyorder, has_item, empty

clibrary(
    name="fallbacklib",
    hdrs={"fallback.h": "./fallback.h"},
    caller_cflags=["--cflags-flag-fallback"],
    caller_ldflags=["--libs-flag-fallback"],
)

mp = package(name="missingpkg", package="missing", fallback=".+fallbacklib")
package(name="foundpkg", package="ab-sample-pkg")

cp = cprogram(
    name="cprogram", srcs=["./cfile.c"], deps=[".+missingpkg", ".+foundpkg"]
)

export(name="all", items={}, deps=[".+cprogram"]).materialise()

assert_that(mp.name, equal_to("tests/pkg/+missingpkg"))
assert_that(
    targetnamesof(mp.outs),
    contains_inanyorder("tests/pkg/+fallbacklib_hdr"),
)

assert_that(cp.name, equal_to("tests/pkg/+cprogram"))
assert_that(
    targetnamesof(cp.ins),
    contains_inanyorder(
        "tests/pkg/+cprogram/tests/pkg/cfile.c",
    ),
)
assert_that(
    targetnamesof(cp.deps),
    contains_inanyorder("tests/pkg/+foundpkg", "tests/pkg/+missingpkg"),
)
assert_that(
    filenamesof(cp.deps),
    contains_inanyorder("$(OBJ)/tests/pkg/+fallbacklib_hdr/fallback.h"),
)
assert_that(
    targetnamesof(cp.ins),
    contains_inanyorder("tests/pkg/+cprogram/tests/pkg/cfile.c"),
)
assert_that(
    cp.args["ldflags"],
    contains_inanyorder("--libs-flag", "--libs-flag-fallback"),
)
t = targets["tests/pkg/+cprogram/tests/pkg/cfile.c"]
assert_that(
    targetnamesof(t.deps),
    contains_inanyorder("tests/pkg/+fallbacklib_hdr"),
)
assert_that(
    t.args["cflags"],
    contains_inanyorder(
        "--c-flag",
        "--cflags-flag-fallback",
        "-I$(OBJ)/tests/pkg/+fallbacklib_hdr",
    ),
)
