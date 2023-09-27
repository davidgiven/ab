export OBJ = .obj
export LUA = lua
export CC = gcc
export CXX = g++
export AR = ar
export CFLAGS = -g -Og
export LDFLAGS = -g
export NINJAFLAGS =

export PYTHONHASHSEED = 1

all: $(OBJ)/build.ninja
	@ninja -f $< +all
	
clean:
	@echo CLEAN
	@rm -rf $(OBJ) bin

build-files = $(shell find . -name 'build.py') build/*.py config.py
$(OBJ)/build.ninja: Makefile $(build-files)
	@echo AB
	@mkdir -p $(OBJ)
	@python3 -X pycache_prefix=$(OBJ) build/ab.py -m ninja -t +all -o $@ \
		-v OBJ,CC,CXX,AR,CFLAGS,LDFLAGS,CXXFLAGS \
		build.py
