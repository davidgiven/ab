from build.ab import export
from build.pkg import package
from build.c import cprogram, clibrary

clibrary(name="fallbacklib", hdrs={"fallback.h": "./fallback.h"})

package(name="missingpkg", package="missing", fallback="+fallbacklib")
package(name="foundpkg", package="ab-sample-pkg")

cprogram(name="cprogram", srcs=["./cfile.c"], deps=["+missingpkg", "+foundpkg"])

export(name="all", items={}, deps=["+cprogram"])
