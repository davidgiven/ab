from build.ab2 import export
from build.pkg import package

package(name="pkg", package="missing")

export(name="all", items={}, deps=["+pkg"])
