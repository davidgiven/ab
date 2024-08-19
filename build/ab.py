from os.path import *
import importlib
import argparse
import importlib.abc
import importlib.util
import sys
import builtins
import inspect
import functools
import copy
import string
from pathlib import Path
from typing import Iterable

cwdStack = [""]
targets = {}
unmaterialisedTargets = set()
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

            spec = importlib.util.spec_from_loader(
                name, loader, origin="built-in"
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
    if isinstance(value, list):
        return copy.deepcopy(value)
    return value


def Rule(func):
    sig = inspect.signature(func)

    @functools.wraps(func)
    def wrapper(*, name=None, replaces=None, **kwargs):
        cwd = None
        if name:
            # If this is an automatically generated rule from another rule,
            # override the CWD so filenames resolve to the parent rule.
            if ("+" in name) and not name.startswith("+"):
                (cwd, _) = name.split("+", 1)
        if not cwd:
            # If no CWD is supplied, use the current one.
            cwd = cwdStack[-1]

        if name:
            t = Target(cwd, name)

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

        unmaterialisedTargets.add(t)
        if replaces:
            t.materialise(replacing=True)
        return t

    defaultGlobals[func.__name__] = wrapper
    return wrapper


class Target:
    def __init__(self, cwd, name):
        if name.startswith("./"):
            self.name = join(cwd, name)
        elif "+" not in name:
            self.name = join(cwd, "+" + name)
        else:
            self.name = name

        self.localname = self.name.split("+")[-1]
        self.traits = set()
        self.dir = join("$(OBJDIR)",name)

    def __eq__(self, other):
        return self.name is other.name

    def __hash__(self):
        return id(self.name)

    def materialise(self):
        if self not in unmaterialisedTargets:
            return

        if self in materialisingStack:
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

        unmaterialisedTargets.discard(self)
        materialisingStack.pop()

    def convert(value, target):
        return target.targetof(value)

    def targetof(self, value):
        if isinstance(value, Path):
            value = value.as_posix()
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

        if value in targets:
            return targets[value]

        # Load the new build file.

        (path, target) = value.split("+", 2)
        assert join(path, "+" + target) == value
        loadbuildfile(join(path, "build.py"))
        if not value in targets:
            raise ABException(
                f"build file at {path} doesn't contain +{target} when trying to resolve {value}"
            )
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
        return [target.targetof(x) for x in flatten(value)]


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

    return tuple(generate(items))


def filenamesof(items):
    if not isinstance(items, (list, tuple)):
        error("argument of filenamesof is not a list")

    def generate(xs):
        for x in xs:
            if isinstance(x, Target):
                yield from generate(x.outs)
            else:
                yield x

    return tuple(generate(items))


def templateexpand(s, invocation):
    class Formatter(string.Formatter):
        def get_field(self, name, a1, a2):
            return (
                eval(name, invocation.callback.__globals__, invocation.args),
                False,
            )

        def format_field(self, value, format_spec):
            if type(value) == str:
                return value
            if type(value) != list:
                value = [value]
            return " ".join(
                [templateexpand(f, invocation) for f in filenamesof(value)]
            )

    return Formatter().format(s)


def emit(*args):
    outputFp.write(" ".join(args))
    outputFp.write("\n")


def emitter_startrule(name, ins, outs, deps=[]):
    fins = filenamesof(ins)
    fouts = filenamesof(outs)

    emit("")
    emit(".PHONY:", name)
    emit(name, ":", *fouts)
    emit(*fouts, "&:", *fins)


def emitter_endrule():
    pass


def emitter_label(s):
    emit("\t$(hide)", "$(ECHO)", s)


def emitter_exec(cs):
    for c in cs:
        emit("\t$(hide)", c)


@Rule
def simplerule(
    self,
    name,
    ins: Targets = [],
    outs: Targets = [],
    deps: Targets = [],
    commands=[],
    label="RULE",
):
    self.ins = ins
    self.outs = outs
    self.deps = deps
    emitter_startrule(self.name, ins + deps, outs)
    emitter_label(templateexpand("{label} {name}", self))

    dirs = []
    cs = []
    for out in filenamesof(outs):
        dir = dirname(out)
        if dir and dir not in dirs:
            dirs += [dir]

        cs = [("mkdir -p %s" % dir) for dir in dirs]

    for c in commands:
        cs += [templateexpand(c, self)]

    emitter_exec(cs)
    emitter_endrule()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output")
    parser.add_argument("files", nargs="+")
    args = parser.parse_args()

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
