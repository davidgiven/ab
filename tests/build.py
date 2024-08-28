from build.ab import simplerule, Rule, Target, export

TESTS = [
    "clibrary",
    "cprogram",
    "dependency",
    "export",
    "invocation",
    "pkg",
    "protobuf",
    "simple",
]


@Rule
def test(self, name, test: Target):
    simplerule(
        replaces=self,
        ins=[
            "./" + self.localname + "/build.py",
            "./" + self.localname + "/good.mk",
        ],
        outs=["=build.mk"],
        deps=["build/ab.py", "build/c.py", "build/pkg.py"],
        commands=[
            "PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py "
            + " -o {outs[0]}.bad {ins[0]}"
            + " || (rm -f {outs} && false)",
            "diff -uN {ins[1]} {outs[0]}.bad || (echo 'Use this command to update the good file:' && echo cp {outs[0]}.bad {ins[1]} && false)",
            "mv {outs[0]}.bad {outs[0]}",
        ],
        label="TEST",
    )


tests = [test(name=t, test=t) for t in TESTS]

export(name="tests", deps=tests)
