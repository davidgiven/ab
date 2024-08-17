from os.path import *
import importlib
import argparse
import importlib.abc
import importlib.util
import sys
import builtins
import inspect
import functools

cwdStack = [""]
targets = {}
unmaterialisedTargets = set()
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

    def __eq__(self, other):
        return self.name is other.name

    def __hash__(self):
        return id(self.name)


def loadbuildfile(filename):
    filename = filename.replace("/", ".").removesuffix(".py")
    builtins.__import__(filename)


def emit(*args):
    outputFp.write(" ".join(args))
    outputFp.write("\n")


@Rule
def simplerule(self, name, ins, outs, commands, label):
    error("simplerule")


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
    sys.modules["build.ab2"] = sys.modules[__name__]
    __name__ = "build.ab2"

    for f in args.files:
        loadbuildfile(f)

    while unmaterialisedTargets:
        unmaterialisedTargets.pop().materialise()
    emit("AB_LOADED = 1\n")


main()
