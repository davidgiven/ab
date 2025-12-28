from build.ab import Rule, Targets, simplerule, TargetsMap
from build.utils import filenamesmatchingof, stripext, collectattrs
from build.toolchain import Toolchain
from os.path import *


Toolchain.DMD = ["$(DMD) -of $[outs[0]] $[ins] $(DFLAGS) $[dflags]"]
Toolchain.DMDLIB = [
    "$(DMD) -c -Hd $[dipath] -op -Hd $[dipath] -of $[outs[0]] $[ins] $(DFLAGS) $[dflags]"
]
Toolchain.HOSTDMD = ["$(HOSTDMD) -of $[outs[0]] $[ins] $(HOSTDFLAGS) $[dflags]"]
Toolchain.HOSTDMDLIB = [
    "$(HOSTDMD) -c -of $[outs[0]] $[ins] $(HOSTDFLAGS) $[dflags]"
]


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
def dlibrary(
    self,
    name,
    srcs: Targets = [],
    dflags=[],
    caller_dflags=[],
    deps: Targets = [],
    toolchain=Toolchain,
):
    dideps = _indirect(deps, "di_deps")
    dflags = collectattrs(targets=dideps, name="caller_dflags", initial=dflags)
    caller_dflags = collectattrs(
        targets=dideps, name="caller_dflags", initial=caller_dflags
    )
    difiles = collectattrs(targets=dideps, name="di_files")
    ofiles = collectattrs(targets=dideps, name="di_objs")

    dfiles = filenamesmatchingof(srcs, "*.d")
    mydifiles = [join(self.dir, stripext(f) + ".di") for f in dfiles]
    simplerule(
        replaces=self,
        ins=srcs + difiles,
        outs=[f"={self.localname}.o"] + mydifiles,
        label="DLIBRARY",
        commands=toolchain.DMDLIB,
        add_to_commanddb=True,
        args={
            "dflags": dflags,
            "dipath": self.dir,
            "caller_dflags": caller_dflags,
            "di_files": difiles + mydifiles,
        },
    )
    self.args["di_objs"] = filenamesmatchingof(self.outs, "*.o") + ofiles


@Rule
def dprogram(
    self,
    name,
    srcs: Targets = [],
    dflags=[],
    deps: Targets = [],
    toolchain=Toolchain,
):
    dideps = _indirect(deps, "di_deps")
    dflags = collectattrs(targets=dideps, name="caller_dflags", initial=dflags)
    difiles = collectattrs(targets=dideps, name="di_files")
    ofiles = collectattrs(targets=dideps, name="di_objs")

    simplerule(
        replaces=self,
        ins=srcs + difiles + ofiles,
        outs=[f"={self.localname}"],
        label="DPROGRAM",
        commands=toolchain.DMD,
        add_to_commanddb=True,
        args={"dflags": dflags},
    )
