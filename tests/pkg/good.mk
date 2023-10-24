
PKG_CONFIG ?= pkg-config
PACKAGES := $(shell $(PKG_CONFIG) --list-all | cut -d' ' -f1)


.PHONY: tests/pkg+fallbacklib
tests/pkg+fallbacklib : $(OBJ)/tests/pkg+fallbacklib/fallback.h ;
$(OBJ)/tests/pkg+fallbacklib/fallback.h &: tests/pkg/fallback.h
	$(hide) $(ECHO) HEADERS tests/pkg+fallbacklib
	$(hide) mkdir -p $(OBJ)/tests/pkg+fallbacklib
	$(hide) cp tests/pkg/fallback.h $(OBJ)/tests/pkg+fallbacklib/fallback.h
ifeq ($(filter missing, $(PACKAGES)),)
PACKAGE_CFLAGS_missing := -I$(OBJ)/tests/pkg+fallbacklib
PACKAGE_LDFLAGS_missing := 
PACKAGE_DEP_missing :=  tests/pkg+fallbacklib
else
PACKAGE_CFLAGS_missing := $(shell $(PKG_CONFIG) --cflags missing)
PACKAGE_LDFLAGS_missing := $(shell $(PKG_CONFIG) --libs missing)
PACKAGE_DEP_missing := 
endif
ifeq ($(filter ab-sample-pkg, $(PACKAGES)),)
$(error Required package 'ab-sample-pkg' not installed.)
else
PACKAGE_CFLAGS_ab-sample-pkg := $(shell $(PKG_CONFIG) --cflags ab-sample-pkg)
PACKAGE_LDFLAGS_ab-sample-pkg := $(shell $(PKG_CONFIG) --libs ab-sample-pkg)
PACKAGE_DEP_ab-sample-pkg := 
endif

.PHONY: tests/pkg+cprogram/tests/pkg/cfile.c
tests/pkg+cprogram/tests/pkg/cfile.c : $(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c/cfile.o ;
$(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c/cfile.o &: tests/pkg/cfile.c $(PACKAGE_DEP_missing) $(PACKAGE_DEP_ab-sample-pkg)
	$(hide) $(ECHO) CC tests/pkg+cprogram/tests/pkg/cfile.c
	$(hide) mkdir -p $(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c/cfile.o tests/pkg/cfile.c $(CFLAGS) $(PACKAGE_CFLAGS_missing) $(PACKAGE_CFLAGS_ab-sample-pkg)

.PHONY: tests/pkg+cprogram
tests/pkg+cprogram : $(OBJ)/tests/pkg+cprogram/pkg+cprogram ;
$(OBJ)/tests/pkg+cprogram/pkg+cprogram &: $(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c/cfile.o $(PACKAGE_DEP_missing) $(PACKAGE_DEP_ab-sample-pkg)
	$(hide) $(ECHO) CLINK tests/pkg+cprogram
	$(hide) mkdir -p $(OBJ)/tests/pkg+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/pkg+cprogram/pkg+cprogram $(OBJ)/tests/pkg+cprogram/tests/pkg/cfile.c/cfile.o $(PACKAGE_LDFLAGS_missing) $(PACKAGE_LDFLAGS_ab-sample-pkg) $(LDFLAGS)

.PHONY: tests/pkg+all
tests/pkg+all &: $(OBJ)/tests/pkg+cprogram/pkg+cprogram
	$(hide) $(ECHO) EXPORT tests/pkg+all
AB_LOADED = 1

