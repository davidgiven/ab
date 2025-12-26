from build.ab import Rule, Targets, simplerule
from build.toolchain import Toolchain, HostToolchain


Toolchain.DMD = ["$(DMD) -c -of $[outs[0]] $[ins[0]] $(DFLAGS) $[dflags]"]
Toolchain.HOSTDMD = ["$(HOSTDMD) -c -of $[outs[0]] $[ins[0]] $(HOSTDFLAGS) $[dflags]"]

def _combine(list1, list2):
    r = list(list1)
    for i in list2:
        if i not in r:
            r.append(i)
    return r


def _indirect(deps, name):
    r = []
    for d in deps:
        r = _combine(r, d.args.get(name, [d]))
    return r


@Rule
def dprogram(self, name, srcs: Targets=[], dflags=[], toolchain=Toolchain):
    simplerule(
        replaces=self,
        ins=srcs,
        outs=[f"={self.localname}"],
        label="DPROGRAM",
        commands=toolchain.DMD,
        add_to_commanddb=True,
        args={"dflags": dflags},
    )
