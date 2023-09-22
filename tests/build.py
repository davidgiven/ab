from build.ab2 import normalrule, Rule, Target, export

TESTS = [
    "simple"
]

@Rule
def test(self, name, test: Target):
    normalrule(
        replaces=self,
        ins=["./"+self.localname+".py"],
        outs=["log"],
        commands=[
            "python3 -X pycache_prefix=$(OBJ) build/ab.py -m ninja -t tests+all -o {outs[0]} {ins[0]}"
        ],
        label="TEST"
    )

tests = [test(name=t, test=t) for t in TESTS]

export(name="tests", deps=tests)
