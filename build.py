from build.ab import export, simplerule

simplerule(
    name="fortesting",
    outs=["=out"],
    commands=["touch {outs[0]}"],
    label="TOUCH",
)

simplerule(
    name="distribution",
    ins=[
        "./build/_objectify.py",
        "./build/ab.mk",
        "./build/ab.py",
        "./build/c.py",
        "./build/pkg.py",
        "./build/protobuf.py",
        "./build/utils.py",
        "./build/zip.py",
    ],
    outs=["=distribution.tar.xz"],
    commands=["tar cJf {outs[0]} {ins}"],
    label="ZIP",
)

export(
    name="all", items={"distribution.tar.xz": "+distribution"}, deps=["tests"]
)
