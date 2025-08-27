from build.ab import export, simplerule

simplerule(
    name="fortesting",
    outs=["=out"],
    commands=["touch $[outs[0]]"],
    label="TOUCH",
)

simplerule(
    name="distribution",
    ins=[
        "./build/_manifest.py",
        "./build/_objectify.py",
        "./build/_sandbox.py",
        "./build/ab.mk",
        "./build/ab.py",
        "./build/ab.ninja",
        "./build/c.py",
        "./build/java.py",
        "./build/pkg.py",
        "./build/protobuf.py",
        "./build/toolchain.py",
        "./build/utils.py",
        "./build/yacc.py",
        "./build/zip.py",
    ],
    outs=["=distribution.tar.xz"],
    commands=["tar chJf $[outs[0]] $[ins]"],
    label="ZIP",
)

export(
    name="all", items={"distribution.tar.xz": "+distribution"}, deps=["tests"]
)
