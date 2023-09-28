OBJ ?= .obj
PYTHON ?= python3
CC ?= gcc
CXX ?= g++
AR ?= ar
CFLAGS ?= -g -Og
LDFLAGS ?= -g
hide = @

ifndef ECHO
T := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
      -nrRf $(firstword $(MAKEFILE_LIST)) \
      ECHO="COUNTTHIS" | grep -c "COUNTTHIS")
N := x
C = $(words $N)$(eval N := x $N)
ECHO = echo [$C/$T]
endif

export PYTHONHASHSEED = 1

all: +all
	
clean:
	@echo [-/-] CLEAN
	$(hide) rm -rf $(OBJ) bin

build-files = $(shell find . -name 'build.py') build/*.py config.py
$(OBJ)/build.mk: Makefile $(build-files)
	@echo [-/-] AB
	@mkdir -p $(OBJ)
	$(hide) $(PYTHON) -X pycache_prefix=$(OBJ) build/ab.py -t +all -o $@ \
		build.py

-include $(OBJ)/build.mk
