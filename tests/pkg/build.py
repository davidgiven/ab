from build.ab import export
from build.pkg import package
from build.c import cprogram

package(name="missingpkg", package="missing")
package(name="foundpkg", package="ab-sample-pkg")

cprogram(name="cprogram", srcs=["./cfile.c"], deps=["+missingpkg", "+foundpkg"])

export(name="all", items={}, deps=["+cprogram"])
