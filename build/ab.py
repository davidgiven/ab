from os.path import *
from pathlib import Path
from types import SimpleNamespace
from typing import Iterable
import argparse
import builtins
import copy
import functools
import importlib
import importlib.abc
import importlib.util
import inspect
import string
import sys

verbose = False
cwdStack = [""]
targets = {}
unmaterialisedTargets = {}  # dict, not set, to get consistent ordering
materialisingStack = []
defaultGlobals = {}

sys.path += ["."]
old_import = builtins.__import__


def new_import(name, *args, **kwargs):
    if name not in sys.modules:
        path = name.replace(".", "/") + ".py"
        if isfile(path):
            sys.stderr.write(f"loading {path}\n")
            loader = importlib.machinery.SourceFileLoader(name, path)

            spec = importlib.util.spec_from_file_location(
                name=name, location=path, loader=loader
            )
            module = importlib.util.module_from_spec(spec)
            sys.modules[name] = module
            cwdStack.append(dirname(path))
            spec.loader.exec_module(module)
            cwdStack.pop()

    return old_import(name, *args, **kwargs)


builtins.__import__ = new_import


class ABException(BaseException):
    pass


def error(message):
    raise ABException(message)


def _deepcopy(value):
    if isinstance(value, (list, dict)):
        return copy.deepcopy(value)
    return value


def Rule(func):
    sig = inspect.signature(func)

    @functools.wraps(func)
    def wrapper(*, name=None, replaces=None, **kwargs):
        cwd = None
        if "cwd" in kwargs:
            cwd = kwargs["cwd"]
            del kwargs["cwd"]

        if not cwd:
            if replaces:
                cwd = replaces.cwd
            else:
                cwd = cwdStack[-1]

        if name:
            if name[0] != "+":
                name = "+" + name
            t = Target(cwd, join(cwd, name))

            if t.name in targets:
                raise ABException(f"target {t.name} has already been defined")
            targets[t.name] = t
        elif replaces:
            t = replaces
        else:
            raise ABException("you must supply either 'name' or 'replaces'")

        t.cwd = cwd
        t.types = func.__annotations__
        t.callback = func
        t.traits.add(func.__name__)

        t.binding = sig.bind(name=name, self=t, **kwargs)
        t.binding.apply_defaults()

        unmaterialisedTargets[t] = None
        if replaces:
            t.materialise(replacing=True)
        return t

    defaultGlobals[func.__name__] = wrapper
    return wrapper


class Target:
    def __init__(self, cwd, name):
        if verbose:
            print("rule('%s', cwd='%s'" % (name, cwd))
        self.name = name
        self.localname = self.name.rsplit("+")[-1]
        self.traits = set()
        self.dir = join("$(OBJ)", name)
        self.ins = []
        self.outs = []
        self.materialised = False

    def __eq__(self, other):
        return self.name is other.name

    def __hash__(self):
        return id(self)

    def __repr__(self):
        return f"Target('{self.name}', {id(self)})"

    def templateexpand(selfi, s):
        class Formatter(string.Formatter):
            def get_field(self, name, a1, a2):
                return (
                    eval(name, selfi.callback.__globals__, selfi.args),
                    False,
                )

            def format_field(self, value, format_spec):
                if not value:
                    return ""
                if type(value) == str:
                    return value
                if type(value) != list:
                    value = [value]
                return " ".join(
                    [selfi.templateexpand(f) for f in filenamesof(value)]
                )

        return Formatter().format(s)

    def materialise(self, replacing=False):
        if self not in unmaterialisedTargets:
            return

        if not replacing and self in materialisingStack:
            print("Found dependency cycle:")
            for i in materialisingStack:
                print(f"  {i.name}")
            print(f"  {self.name}")
            sys.exit(1)
        materialisingStack.append(self)

        # Perform type conversion to the declared rule parameter types.

        try:
            self.args = {}
            for k, v in self.binding.arguments.items():
                if k != "kwargs":
                    t = self.types.get(k, None)
                    if t:
                        v = t.convert(v, self)
                    self.args[k] = _deepcopy(v)
                else:
                    for kk, vv in v.items():
                        t = self.types.get(kk, None)
                        if t:
                            vv = t.convert(v, self)
                        self.args[kk] = _deepcopy(vv)
            self.args["name"] = self.name

            # Actually call the callback.

            cwdStack.append(self.cwd)
            self.callback(**self.args)
            cwdStack.pop()
        except BaseException as e:
            print(f"Error materialising {self}: {self.callback}")
            print(f"Arguments: {self.args}")
            raise e

        if self.outs is None:
            raise ABException(f"{self.name} didn't set self.outs")

        if self in unmaterialisedTargets:
            del unmaterialisedTargets[self]
        materialisingStack.pop()
        self.materialised = True

    def convert(value, target):
        if not value:
            return None
        return target.targetof(value)

    def targetof(self, value):
        if isinstance(value, Path):
            value = value.as_posix()
        if isinstance(value, Target):
            t = value
        else:
            if value[0] == "=":
                value = join(self.dir, value[1:])

            if value.startswith("."):
                # Check for local rule.
                if value.startswith(".+"):
                    value = normpath(join(self.cwd, value[1:]))
                # Check for local path.
                elif value.startswith("./"):
                    value = normpath(join(self.cwd, value))
            # Explicit directories are always raw files.
            elif value.endswith("/"):
                return self._filetarget(value)
            # Anything starting with a variable expansion is always a raw file.
            elif value.startswith("$"):
                return self._filetarget(value)

            # If this is not a rule lookup...
            if "+" not in value:
                # ...and if the value is pointing at a directory without a trailing /,
                # it's a shorthand rule lookup.
                if isdir(value):
                    value = value + "+" + basename(value)
                # Otherwise it's an absolute file.
                else:
                    return self._filetarget(value)

            # At this point we have the fully qualified name of a rule.

            (path, target) = value.rsplit("+", 1)
            value = join(path, "+" + target)
            if value not in targets:
                # Load the new build file.

                path = join(path, "build.py")
                loadbuildfile(path)
                assert (
                    value in targets
                ), f"build file at '{path}' doesn't contain '+{target}' when trying to resolve '{value}'"

            t = targets[value]

        t.materialise()
        return t

    def _filetarget(self, value):
        if value in targets:
            return targets[value]

        t = Target(self.cwd, value)
        t.outs = [value]
        targets[value] = t
        return t


class Targets:
    def convert(value, target):
        if not value:
            return []
        assert isinstance(
            value, (list, tuple)
        ), "cannot convert non-list to Targets"
        return [target.targetof(x) for x in flatten(value)]


class TargetsMap:
    def convert(value, target):
        if not value:
            return {}
        return {k: target.targetof(v) for k, v in value.items()}


def loadbuildfile(filename):
    filename = filename.replace("/", ".").removesuffix(".py")
    builtins.__import__(filename)


def flatten(items):
    def generate(xs):
        for x in xs:
            if isinstance(x, Iterable) and not isinstance(x, (str, bytes)):
                yield from generate(x)
            else:
                yield x

    return list(generate(items))


def targetnamesof(items):
    if not isinstance(items, (list, tuple)):
        error("argument of filenamesof is not a list")

    return [t.name for t in items]


def filenamesof(items):
    if not isinstance(items, (list, tuple)):
        error("argument of filenamesof is not a list")

    def generate(xs):
        for x in xs:
            if isinstance(x, Target):
                yield from generate(x.outs)
            else:
                yield x

    return list(generate(items))


def filenameof(x):
    xs = filenamesof(x.outs)
    assert (
        len(xs) == 1
    ), "tried to use filenameof() on a target with more than one output"
    return xs[0]


def emit(*args):
    outputFp.write(" ".join(args))
    outputFp.write("\n")


def emit_rule(name, ins, outs, cmds=[], label=None):
    fins = [t.name for t in ins]
    fouts = [t.name for t in outs]
    nonobjs = [f for f in filenamesof(outs) if not f.startswith("$(OBJ)")]

    emit("")
    if nonobjs:
        emit("clean::")
        emit("\t$(hide) rm -f", *nonobjs)

    emit(".PHONY:", name)
    if outs:
        emit(name, ":", *fouts)
        if cmds:
            emit(*fouts, "&:", *fins)
        else:
            emit(*fouts, ":", *fins)

        if label:
            emit("\t$(hide)", "$(ECHO)", label)
        for c in cmds:
            emit("\t$(hide)", c)
    else:
        assert len(cmds) == 0, "rules with no outputs cannot have commands"
        emit(name, ":", *fins)

    emit("")


@Rule
def simplerule(
    self,
    name,
    ins: Targets = [],
    outs: Targets = [],
    deps: Targets = [],
    commands=[],
    label="RULE",
    **kwargs,
):
    self.ins = ins
    self.outs = outs
    self.deps = deps

    dirs = []
    cs = []
    for out in filenamesof(outs):
        dir = dirname(out)
        if dir and dir not in dirs:
            dirs += [dir]

        cs = [("mkdir -p %s" % dir) for dir in dirs]

    for c in commands:
        cs += [self.templateexpand(c)]

    emit_rule(
        name=self.name,
        ins=ins + deps,
        outs=outs,
        label=self.templateexpand("{label} {name}"),
        cmds=cs,
    )


@Rule
def export(self, name=None, items: TargetsMap = {}, deps: Targets = []):
    self.ins = deps
    self.outs = []
    for dest, src in items.items():
        dest = self.targetof(dest)
        self.outs += [dest]

        destf = filenameof(dest)

        srcs = filenamesof([src])
        assert (
            len(srcs) == 1
        ), "a dependency of an exported file must have exactly one output file"

        subrule = simplerule(
            name=f"{self.localname}/{destf}",
            cwd=self.cwd,
            ins=[srcs[0]],
            outs=[destf],
            commands=["cp %s %s" % (srcs[0], destf)],
            label="CP",
        )
        subrule.materialise()

        self.ins += [subrule]

    emit_rule(name=self.name, ins=self.ins, outs=[])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("-o", "--output")
    parser.add_argument("files", nargs="+")
    args = parser.parse_args()

    global verbose
    verbose = args.verbose

    global outputFp
    outputFp = open(args.output, "wt")

    for k in ["Rule"]:
        defaultGlobals[k] = globals()[k]

    global __name__
    sys.modules["build.ab"] = sys.modules[__name__]
    __name__ = "build.ab"

    for f in args.files:
        loadbuildfile(f)

    while unmaterialisedTargets:
        t = next(iter(unmaterialisedTargets))
        t.materialise()
    emit("AB_LOADED = 1\n")


main()
