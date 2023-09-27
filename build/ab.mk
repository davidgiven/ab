OBJ ?= .obj
LUA ?= lua
CC ?= gcc
CXX ?= g++
AR ?= ar
CFLAGS ?= -g -Og
LDFLAGS ?= -g

export PYTHONHASHSEED = 1

all: +all
	
clean:
	@echo CLEAN
	@rm -rf $(OBJ) bin

build-files = $(shell find . -name 'build.py') build/*.py config.py
$(OBJ)/build.mk: Makefile $(build-files)
	@echo AB
	@mkdir -p $(OBJ)
	@python3 -X pycache_prefix=$(OBJ) build/ab.py -m make -t +all -o $@ \
		build.py

-include $(OBJ)/build.mk
