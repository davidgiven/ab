from build.ab import normalrule, Rule, Target, export

TESTS = ["simple", "dependency", "cprogram", "pkg", "clibrary"]


@Rule
def test(self, name, test: Target):
    normalrule(
        replaces=self,
        ins=[
            "./" + self.localname + "/build.py",
            "./" + self.localname + "/good.mk",
        ],
        outs=["log"],
        deps=["build/ab.py", "build/c.py"],
        commands=[
            "PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py -t tests/"
            + self.localname
            + "+all -o {outs[0]} {ins[0]}",
            "diff -uN {ins[1]} {outs[0]} || (echo 'Use this command to update the good file:' && echo cp {outs[0]} {ins[1]} && false)",
        ],
        label="TEST",
    )


tests = [test(name=t, test=t) for t in TESTS]

export(name="tests", deps=tests)
