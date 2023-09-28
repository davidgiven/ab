from build.ab2 import export, normalrule

normalrule(
        name="distribution",
        ins=[
            "./build/ab.py",
            "./build/c.py",
            "./build/pkg.py",
            "./build/ab.mk"
        ],
        outs=[
            "distribution.tar.xz"
        ],
        commands=[
            "tar cJf {outs[0]} {ins}"
        ],
        label="ZIP"
)

export(name="all", items={"distribution.tar.xz": "+distribution"}, deps=["tests"])
