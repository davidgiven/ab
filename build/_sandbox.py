#!/usr/bin/python3

from os.path import *
import argparse
import os

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--sandbox")
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("files", nargs="*")
    args = parser.parse_args()

    assert args.sandbox, "You must specify a sandbox directory"
    assert not exists(args.sandbox), "The sandbox already exists"

    for f in args.files:
        sf = join(args.sandbox, f)
        if args.verbose:
            print(sf)
        os.makedirs(dirname(sf), exist_ok=True)
        os.symlink(abspath(f), sf)

main()

