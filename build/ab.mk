ifeq ($(findstring 4.,$(MAKE_VERSION)),)
$(error You need GNU Make 4.x for this (if you're on OSX, use gmake).)
endif

OBJ ?= .obj
PYTHON ?= python3
CC ?= gcc
CXX ?= g++
AR ?= ar
CFLAGS ?= -g -Og
LDFLAGS ?= -g
PKG_CONFIG ?= pkg-config
ECHO ?= echo
CP ?= cp
TARGETS ?= +all

ifdef VERBOSE
	hide =
else
	ifdef V
		hide =
	else
		hide = @
	endif
endif

WINDOWS := no
OSX := no
LINUX := no
ifeq ($(OS),Windows_NT)
    WINDOWS := yes
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
		LINUX := yes
    endif
    ifeq ($(UNAME_S),Darwin)
		OSX := yes
    endif
endif

ifeq ($(OS), Windows_NT)
	EXT ?= .exe
endif
EXT ?=

ifeq ($(PROGRESSINFO),)
rulecount := $(shell $(MAKE) --no-print-directory -q $(OBJ)/build.mk PROGRESSINFO=1 && $(MAKE) -n $(MAKECMDGOALS) PROGRESSINFO=XXXPROGRESSINFOXXX | grep XXXPROGRESSINFOXXX | wc -l)
ruleindex := 1
PROGRESSINFO = "$(shell $(PYTHON) build/_progress.py $(ruleindex) $(rulecount))$(eval ruleindex := $(shell expr $(ruleindex) + 1))"
endif

include $(OBJ)/build.mk

MAKEFLAGS += -r -j$(shell nproc)
.DELETE_ON_ERROR:

.PHONY: update-ab
update-ab:
	@echo "Press RETURN to update ab from the repository, or CTRL+C to cancel." \
		&& read a \
		&& (curl -L https://github.com/davidgiven/ab/releases/download/dev/distribution.tar.xz | tar xvJf -) \
		&& echo "Done."

.PHONY: clean
clean::
	@echo CLEAN
	$(hide) rm -rf $(OBJ)

export PYTHONHASHSEED = 1
build-files = $(shell find . -name 'build.py') $(wildcard build/*.py) $(wildcard config.py)
$(OBJ)/build.mk: Makefile $(build-files) build/ab.mk
	@echo "AB"
	@mkdir -p $(OBJ)
	$(hide) $(PYTHON) -X pycache_prefix=$(OBJ)/__pycache__ build/ab.py -o $@ build.py \
		|| rm -f $@
