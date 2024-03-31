
PKG_CONFIG ?= pkg-config
PACKAGES := $(shell $(PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)

HOST_PKG_CONFIG ?= pkg-config
HOST_PACKAGES := $(shell $(HOST_PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)


.PHONY: tests/pkg/+fallbacklib
tests/pkg/+fallbacklib : $(OBJ)/.sentinels/tests/pkg/+fallbacklib.mark
$(OBJ)/.sentinels/tests/pkg/+fallbacklib.mark : tests/pkg/fallback.h
	$(hide) $(ECHO) CHEADERS tests/pkg/+fallbacklib
	$(hide) mkdir -p $(OBJ)/tests/pkg/+fallbacklib
	$(hide) cp tests/pkg/fallback.h $(OBJ)/tests/pkg/+fallbacklib/fallback.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/pkg
	$(hide) touch $(OBJ)/.sentinels/tests/pkg/+fallbacklib.mark
.SECONDARY: $(OBJ)/tests/pkg/+fallbacklib/fallback.h
$(OBJ)/tests/pkg/+fallbacklib/fallback.h : $(OBJ)/.sentinels/tests/pkg/+fallbacklib.mark ;
ifeq ($(filter missing, $(PACKAGES)),)
PACKAGE_DEPS_missing :=  $(OBJ)/tests/pkg/+fallbacklib/fallback.h
PACKAGE_CFLAGS_missing := -I$(OBJ)/tests/pkg/+fallbacklib
PACKAGE_LDFLAGS_missing :=  $(filter %.a, $(PACKAGE_DEPS_missing))
else
PACKAGE_CFLAGS_missing := $(shell $(PKG_CONFIG) --cflags missing)
PACKAGE_LDFLAGS_missing := $(shell $(PKG_CONFIG) --libs missing)
PACKAGE_DEPS_missing :=
endif
ifeq ($(filter ab-sample-pkg, $(PACKAGES)),)
$(error Required package 'ab-sample-pkg' not installed.)
else
PACKAGE_CFLAGS_ab-sample-pkg := $(shell $(PKG_CONFIG) --cflags ab-sample-pkg)
PACKAGE_LDFLAGS_ab-sample-pkg := $(shell $(PKG_CONFIG) --libs ab-sample-pkg)
PACKAGE_DEPS_ab-sample-pkg :=
endif

.PHONY: tests/pkg/+cprogram/tests/pkg/cfile.c
tests/pkg/+cprogram/tests/pkg/cfile.c : $(OBJ)/.sentinels/tests/pkg/+cprogram/tests/pkg/cfile.c.mark
$(OBJ)/.sentinels/tests/pkg/+cprogram/tests/pkg/cfile.c.mark : tests/pkg/cfile.c $(PACKAGE_DEPS_missing) $(PACKAGE_DEPS_ab-sample-pkg)
	$(hide) $(ECHO) CC tests/pkg/+cprogram/tests/pkg/cfile.c
	$(hide) mkdir -p $(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c/cfile.o tests/pkg/cfile.c $(CFLAGS) $(PACKAGE_CFLAGS_missing) $(PACKAGE_CFLAGS_ab-sample-pkg)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/pkg/+cprogram/tests/pkg
	$(hide) touch $(OBJ)/.sentinels/tests/pkg/+cprogram/tests/pkg/cfile.c.mark
.SECONDARY: $(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c/cfile.o
$(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c/cfile.o : $(OBJ)/.sentinels/tests/pkg/+cprogram/tests/pkg/cfile.c.mark ;

.PHONY: tests/pkg/+cprogram
tests/pkg/+cprogram : $(OBJ)/.sentinels/tests/pkg/+cprogram.mark
$(OBJ)/.sentinels/tests/pkg/+cprogram.mark : $(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c/cfile.o $(PACKAGE_DEPS_missing) $(PACKAGE_DEPS_ab-sample-pkg)
	$(hide) $(ECHO) CLINK tests/pkg/+cprogram
	$(hide) mkdir -p $(OBJ)/tests/pkg/+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/pkg/+cprogram/+cprogram$(EXT) $(OBJ)/tests/pkg/+cprogram/tests/pkg/cfile.c/cfile.o $(PACKAGE_LDFLAGS_missing) $(PACKAGE_LDFLAGS_ab-sample-pkg) $(LDFLAGS)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/pkg
	$(hide) touch $(OBJ)/.sentinels/tests/pkg/+cprogram.mark
.SECONDARY: $(OBJ)/tests/pkg/+cprogram/+cprogram$(EXT)
$(OBJ)/tests/pkg/+cprogram/+cprogram$(EXT) : $(OBJ)/.sentinels/tests/pkg/+cprogram.mark ;

.PHONY: tests/pkg/+all
tests/pkg/+all : $(OBJ)/.sentinels/tests/pkg/+all.mark
$(OBJ)/.sentinels/tests/pkg/+all.mark : $(OBJ)/tests/pkg/+cprogram/+cprogram$(EXT)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/pkg
	$(hide) touch $(OBJ)/.sentinels/tests/pkg/+all.mark
AB_LOADED = 1

