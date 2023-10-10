OBJ ?= .obj
PYTHON ?= python3
CC ?= gcc
CXX ?= g++
AR ?= ar
CFLAGS ?= -g -Og
LDFLAGS ?= -g
hide = @
PKG_CONFIG ?= pkg-config
export PKG_CONFIG

.SECONDARY:

include $(OBJ)/build.mk

ifndef AB_LOADED
# For the first run, when the generated build.mk does not yet exist.
ECHO = echo
else
# For the second run. This ensures that the submake does not run rules
# to try and create the build.mk file.
ifndef ECHO
T := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
      -nrRf $(firstword $(MAKEFILE_LIST)) \
      ECHO="COUNTTHIS" | grep -c "COUNTTHIS")
N := x
C = $(words $N)$(eval N := x $N)
ECHO = echo [$C/$T]
endif
endif


export PYTHONHASHSEED = 1

clean::
	@echo [-/-] CLEAN
	$(hide) rm -rf $(OBJ) bin

build-files = $(shell find . -name 'build.py') build/*.py config.py
$(OBJ)/build.mk: Makefile $(build-files)
	@echo "[-/-] AB"
	@mkdir -p $(OBJ)
	$(hide) $(PYTHON) -X pycache_prefix=$(OBJ) build/ab.py -t +all -o $@ \
		build.py

