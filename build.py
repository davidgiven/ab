from build.ab import export, normalrule

normalrule(
    name="distribution",
    ins=[
        "./build/ab.py",
        "./build/c.py",
        "./build/pkg.py",
        "./build/ab.mk",
        "./build/protobuf.py",
        "./build/utils.py",
        "./build/_objectify.py",
    ],
    outs=["distribution.tar.xz"],
    commands=["tar cJf {outs[0]} {ins}"],
    label="ZIP",
)

export(
    name="all", items={"distribution.tar.xz": "+distribution"}, deps=["tests"]
)
