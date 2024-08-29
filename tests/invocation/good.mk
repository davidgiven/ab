
.PHONY: tests/invocation/+r1
tests/invocation/+r1 : $(OBJ)/tests/invocation/+r1/r1.txt
$(OBJ)/tests/invocation/+r1/r1.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r1
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r1
	$(hide) echo tests/invocation/+r1 > $(OBJ)/tests/invocation/+r1/r1.txt


.PHONY: tests/invocation/+r2
tests/invocation/+r2 : $(OBJ)/tests/invocation/+r2/r2.txt
$(OBJ)/tests/invocation/+r2/r2.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r2
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r2
	$(hide) echo tests/invocation/+r2 > $(OBJ)/tests/invocation/+r2/r2.txt


.PHONY: +fortesting
+fortesting : $(OBJ)/+fortesting/out
$(OBJ)/+fortesting/out &:
	$(hide) $(ECHO) TOUCH +fortesting
	$(hide) mkdir -p $(OBJ)/+fortesting
	$(hide) touch $(OBJ)/+fortesting/out


.PHONY: tests/invocation/+all
tests/invocation/+all : tests/invocation/+r1 tests/invocation/+r2 +fortesting


.PHONY: +distribution
+distribution : $(OBJ)/+distribution/distribution.tar.xz
$(OBJ)/+distribution/distribution.tar.xz &: build/ab.py build/c.py build/pkg.py build/ab.mk build/protobuf.py build/utils.py build/_objectify.py
	$(hide) $(ECHO) ZIP +distribution
	$(hide) mkdir -p $(OBJ)/+distribution
	$(hide) tar cJf $(OBJ)/+distribution/distribution.tar.xz build/ab.py build/c.py build/pkg.py build/ab.mk build/protobuf.py build/utils.py build/_objectify.py


PKG_CONFIG ?= pkg-config
PACKAGES := $(shell $(PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)

HOST_PKG_CONFIG ?= pkg-config
HOST_PACKAGES := $(shell $(HOST_PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)


PROTOC ?= protoc
ifeq ($(filter protobuf, $(PACKAGES)),)
$(error Required package 'protobuf' not installed.)"
endif


ZIP ?= zip
ZIPNOTE ?= zipnote


.PHONY: tests/+clibrary
tests/+clibrary : $(OBJ)/tests/+clibrary/build.mk
$(OBJ)/tests/+clibrary/build.mk &: tests/clibrary/build.py tests/clibrary/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+clibrary
	$(hide) mkdir -p $(OBJ)/tests/+clibrary
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+clibrary/build.mk.bad tests/clibrary/build.py || (rm -f $(OBJ)/tests/+clibrary/build.mk && false)
	$(hide) diff -uN tests/clibrary/good.mk $(OBJ)/tests/+clibrary/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+clibrary/build.mk.bad tests/clibrary/good.mk && false)
	$(hide) mv $(OBJ)/tests/+clibrary/build.mk.bad $(OBJ)/tests/+clibrary/build.mk


.PHONY: tests/+cprogram
tests/+cprogram : $(OBJ)/tests/+cprogram/build.mk
$(OBJ)/tests/+cprogram/build.mk &: tests/cprogram/build.py tests/cprogram/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+cprogram
	$(hide) mkdir -p $(OBJ)/tests/+cprogram
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+cprogram/build.mk.bad tests/cprogram/build.py || (rm -f $(OBJ)/tests/+cprogram/build.mk && false)
	$(hide) diff -uN tests/cprogram/good.mk $(OBJ)/tests/+cprogram/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+cprogram/build.mk.bad tests/cprogram/good.mk && false)
	$(hide) mv $(OBJ)/tests/+cprogram/build.mk.bad $(OBJ)/tests/+cprogram/build.mk


.PHONY: tests/+dependency
tests/+dependency : $(OBJ)/tests/+dependency/build.mk
$(OBJ)/tests/+dependency/build.mk &: tests/dependency/build.py tests/dependency/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+dependency
	$(hide) mkdir -p $(OBJ)/tests/+dependency
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+dependency/build.mk.bad tests/dependency/build.py || (rm -f $(OBJ)/tests/+dependency/build.mk && false)
	$(hide) diff -uN tests/dependency/good.mk $(OBJ)/tests/+dependency/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+dependency/build.mk.bad tests/dependency/good.mk && false)
	$(hide) mv $(OBJ)/tests/+dependency/build.mk.bad $(OBJ)/tests/+dependency/build.mk


.PHONY: tests/+export
tests/+export : $(OBJ)/tests/+export/build.mk
$(OBJ)/tests/+export/build.mk &: tests/export/build.py tests/export/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+export
	$(hide) mkdir -p $(OBJ)/tests/+export
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+export/build.mk.bad tests/export/build.py || (rm -f $(OBJ)/tests/+export/build.mk && false)
	$(hide) diff -uN tests/export/good.mk $(OBJ)/tests/+export/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+export/build.mk.bad tests/export/good.mk && false)
	$(hide) mv $(OBJ)/tests/+export/build.mk.bad $(OBJ)/tests/+export/build.mk


.PHONY: tests/+invocation
tests/+invocation : $(OBJ)/tests/+invocation/build.mk
$(OBJ)/tests/+invocation/build.mk &: tests/invocation/build.py tests/invocation/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+invocation
	$(hide) mkdir -p $(OBJ)/tests/+invocation
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+invocation/build.mk.bad tests/invocation/build.py || (rm -f $(OBJ)/tests/+invocation/build.mk && false)
	$(hide) diff -uN tests/invocation/good.mk $(OBJ)/tests/+invocation/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+invocation/build.mk.bad tests/invocation/good.mk && false)
	$(hide) mv $(OBJ)/tests/+invocation/build.mk.bad $(OBJ)/tests/+invocation/build.mk


.PHONY: tests/+pkg
tests/+pkg : $(OBJ)/tests/+pkg/build.mk
$(OBJ)/tests/+pkg/build.mk &: tests/pkg/build.py tests/pkg/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+pkg
	$(hide) mkdir -p $(OBJ)/tests/+pkg
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+pkg/build.mk.bad tests/pkg/build.py || (rm -f $(OBJ)/tests/+pkg/build.mk && false)
	$(hide) diff -uN tests/pkg/good.mk $(OBJ)/tests/+pkg/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+pkg/build.mk.bad tests/pkg/good.mk && false)
	$(hide) mv $(OBJ)/tests/+pkg/build.mk.bad $(OBJ)/tests/+pkg/build.mk


.PHONY: tests/+protobuf
tests/+protobuf : $(OBJ)/tests/+protobuf/build.mk
$(OBJ)/tests/+protobuf/build.mk &: tests/protobuf/build.py tests/protobuf/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+protobuf
	$(hide) mkdir -p $(OBJ)/tests/+protobuf
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+protobuf/build.mk.bad tests/protobuf/build.py || (rm -f $(OBJ)/tests/+protobuf/build.mk && false)
	$(hide) diff -uN tests/protobuf/good.mk $(OBJ)/tests/+protobuf/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+protobuf/build.mk.bad tests/protobuf/good.mk && false)
	$(hide) mv $(OBJ)/tests/+protobuf/build.mk.bad $(OBJ)/tests/+protobuf/build.mk


.PHONY: tests/+simple
tests/+simple : $(OBJ)/tests/+simple/build.mk
$(OBJ)/tests/+simple/build.mk &: tests/simple/build.py tests/simple/good.mk build/ab.py build/c.py build/pkg.py
	$(hide) $(ECHO) TEST tests/+simple
	$(hide) mkdir -p $(OBJ)/tests/+simple
	$(hide) PKG_CONFIG_PATH=tests/pkg/pkg-repo python3 -X pycache_prefix=$(OBJ) build/ab.py  -o $(OBJ)/tests/+simple/build.mk.bad tests/simple/build.py || (rm -f $(OBJ)/tests/+simple/build.mk && false)
	$(hide) diff -uN tests/simple/good.mk $(OBJ)/tests/+simple/build.mk.bad || (echo 'Use this command to update the good file:' && echo cp $(OBJ)/tests/+simple/build.mk.bad tests/simple/good.mk && false)
	$(hide) mv $(OBJ)/tests/+simple/build.mk.bad $(OBJ)/tests/+simple/build.mk


.PHONY: tests/+cprogram_compile_test/tests/cprogram_compile_test.c
tests/+cprogram_compile_test/tests/cprogram_compile_test.c : $(OBJ)/tests/+cprogram_compile_test/tests/cprogram_compile_test.c/cprogram_compile_test.o
$(OBJ)/tests/+cprogram_compile_test/tests/cprogram_compile_test.c/cprogram_compile_test.o &: tests/cprogram_compile_test.c
	$(hide) $(ECHO) CC tests/+cprogram_compile_test/tests/cprogram_compile_test.c
	$(hide) mkdir -p $(OBJ)/tests/+cprogram_compile_test/tests/cprogram_compile_test.c
	$(hide) $(CC) -c -o $(OBJ)/tests/+cprogram_compile_test/tests/cprogram_compile_test.c/cprogram_compile_test.o tests/cprogram_compile_test.c $(CFLAGS) 


.PHONY: tests/+cprogram_compile_test
tests/+cprogram_compile_test : $(OBJ)/tests/+cprogram_compile_test/cprogram_compile_test$(EXT)
$(OBJ)/tests/+cprogram_compile_test/cprogram_compile_test$(EXT) &: tests/+cprogram_compile_test/tests/cprogram_compile_test.c
	$(hide) $(ECHO) CLINK tests/+cprogram_compile_test
	$(hide) mkdir -p $(OBJ)/tests/+cprogram_compile_test
	$(hide) $(CC) -o $(OBJ)/tests/+cprogram_compile_test/cprogram_compile_test$(EXT) $(OBJ)/tests/+cprogram_compile_test/tests/cprogram_compile_test.c/cprogram_compile_test.o  $(LDFLAGS)


.PHONY: tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc
tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc : $(OBJ)/tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc/cxxprogram_compile_test.o
$(OBJ)/tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc/cxxprogram_compile_test.o &: tests/cxxprogram_compile_test.cc
	$(hide) $(ECHO) CXX tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc
	$(hide) mkdir -p $(OBJ)/tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc/cxxprogram_compile_test.o tests/cxxprogram_compile_test.cc $(CFLAGS) 


.PHONY: tests/+cxxprogram_compile_test
tests/+cxxprogram_compile_test : $(OBJ)/tests/+cxxprogram_compile_test/cxxprogram_compile_test$(EXT)
$(OBJ)/tests/+cxxprogram_compile_test/cxxprogram_compile_test$(EXT) &: tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc
	$(hide) $(ECHO) CXXLINK tests/+cxxprogram_compile_test
	$(hide) mkdir -p $(OBJ)/tests/+cxxprogram_compile_test
	$(hide) $(CXX) -o $(OBJ)/tests/+cxxprogram_compile_test/cxxprogram_compile_test$(EXT) $(OBJ)/tests/+cxxprogram_compile_test/tests/cxxprogram_compile_test.cc/cxxprogram_compile_test.o  $(LDFLAGS)


.PHONY: tests/+proto_compile_test_proto
tests/+proto_compile_test_proto : $(OBJ)/tests/+proto_compile_test_proto/tests/+proto_compile_test_proto.descriptor
$(OBJ)/tests/+proto_compile_test_proto/tests/+proto_compile_test_proto.descriptor &: tests/proto_compile_test.proto
	$(hide) $(ECHO) PROTO tests/+proto_compile_test_proto
	$(hide) mkdir -p $(OBJ)/tests/+proto_compile_test_proto/tests
	$(hide) $(PROTOC) --include_source_info --descriptor_set_out=$(OBJ)/tests/+proto_compile_test_proto/tests/+proto_compile_test_proto.descriptor tests/proto_compile_test.proto


.PHONY: tests/+proto_compile_test_srcs
tests/+proto_compile_test_srcs : $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.h
$(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.h &: tests/proto_compile_test.proto
	$(hide) $(ECHO) PROTOCC tests/+proto_compile_test_srcs
	$(hide) mkdir -p $(OBJ)/tests/+proto_compile_test_srcs/tests
	$(hide) $(PROTOC) --cpp_out=$(OBJ)/tests/+proto_compile_test_srcs tests/proto_compile_test.proto


.PHONY: tests/+proto_compile_test_hdrs
tests/+proto_compile_test_hdrs : $(OBJ)/tests/+proto_compile_test_hdrs/tests/proto_compile_test.pb.h
$(OBJ)/tests/+proto_compile_test_hdrs/tests/proto_compile_test.pb.h &: $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.h
	$(hide) $(ECHO) CHEADERS tests/+proto_compile_test_hdrs
	$(hide) mkdir -p $(OBJ)/tests/+proto_compile_test_hdrs/tests
	$(hide) cp $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.h $(OBJ)/tests/+proto_compile_test_hdrs/tests/proto_compile_test.pb.h


.PHONY: tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc
tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc : $(OBJ)/tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc/proto_compile_test.pb.o
$(OBJ)/tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc/proto_compile_test.pb.o &: $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc tests/+proto_compile_test_hdrs $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.h
	$(hide) $(ECHO) CXX tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc
	$(hide) mkdir -p $(OBJ)/tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc/proto_compile_test.pb.o $(OBJ)/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc $(CFLAGS) -I$(OBJ)/tests/+proto_compile_test_hdrs -I$(OBJ)/tests/+proto_compile_test_srcs/tests


.PHONY: tests/+proto_compile_test
tests/+proto_compile_test : $(OBJ)/tests/+proto_compile_test/proto_compile_test.a
$(OBJ)/tests/+proto_compile_test/proto_compile_test.a &: tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc
	$(hide) $(ECHO) LIB tests/+proto_compile_test
	$(hide) mkdir -p $(OBJ)/tests/+proto_compile_test
	$(hide) $(AR) cqs $(OBJ)/tests/+proto_compile_test/proto_compile_test.a $(OBJ)/tests/+proto_compile_test/tests/+proto_compile_test_srcs/tests/proto_compile_test.pb.cc/proto_compile_test.pb.o


.PHONY: tests/+zip_test
tests/+zip_test : $(OBJ)/tests/+zip_test/tests/+zip_test.zip
$(OBJ)/tests/+zip_test/tests/+zip_test.zip &: tests/README.md
	$(hide) $(ECHO) ZIP tests/+zip_test
	$(hide) mkdir -p $(OBJ)/tests/+zip_test/tests
	$(hide) rm -f $(OBJ)/tests/+zip_test/tests/+zip_test.zip
	$(hide) cat tests/README.md | $(ZIP) -q -0 $(OBJ)/tests/+zip_test/tests/+zip_test.zip -
	$(hide) echo '@ -\n@=this/is/a/file.txt\n' | $(ZIPNOTE) -w $(OBJ)/tests/+zip_test/tests/+zip_test.zip


.PHONY: tests/+objectify_test
tests/+objectify_test : $(OBJ)/tests/+objectify_test/README.md.h
$(OBJ)/tests/+objectify_test/README.md.h &: build/_objectify.py tests/README.md
	$(hide) $(ECHO) OBJECTIFY tests/+objectify_test
	$(hide) mkdir -p $(OBJ)/tests/+objectify_test
	$(hide) $(PYTHON) build/_objectify.py tests/README.md readme > $(OBJ)/tests/+objectify_test/README.md.h


.PHONY: tests/+tests
tests/+tests : tests/+clibrary tests/+cprogram tests/+dependency tests/+export tests/+invocation tests/+pkg tests/+protobuf tests/+simple tests/+cprogram_compile_test tests/+cxxprogram_compile_test tests/+proto_compile_test tests/+zip_test tests/+objectify_test


clean::
	$(hide) rm -f distribution.tar.xz
.PHONY: +all/distribution.tar.xz
+all/distribution.tar.xz : distribution.tar.xz
distribution.tar.xz &: $(OBJ)/+distribution/distribution.tar.xz
	$(hide) $(ECHO) CP +all/distribution.tar.xz
	$(hide) cp $(OBJ)/+distribution/distribution.tar.xz distribution.tar.xz


.PHONY: +all
+all : tests/+tests +all/distribution.tar.xz

AB_LOADED = 1

