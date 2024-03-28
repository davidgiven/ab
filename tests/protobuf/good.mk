
PKG_CONFIG ?= pkg-config
PACKAGES := $(shell $(PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)


PROTOC ?= protoc
ifeq ($(filter protobuf, $(PACKAGES)),)
$(error Required package 'protobuf' not installed.)"
endif


.PHONY: tests/protobuf/+protolib
tests/protobuf/+protolib : $(OBJ)/.sentinels/tests/protobuf/+protolib.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib.mark $(OBJ)/tests/protobuf/+protolib/tests/protobuf/+protolib.descriptor : tests/protobuf/test.proto
$(OBJ)/tests/protobuf/+protolib/tests/protobuf/+protolib.descriptor : $(OBJ)/.sentinels/tests/protobuf/+protolib.mark
	$(hide) $(ECHO) PROTO tests/protobuf/+protolib
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib/tests/protobuf
	$(hide) $(PROTOC) --include_source_info --descriptor_set_out=$(OBJ)/tests/protobuf/+protolib/tests/protobuf/+protolib.descriptor tests/protobuf/test.proto
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib2
tests/protobuf/+protolib2 : $(OBJ)/.sentinels/tests/protobuf/+protolib2.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib2.mark $(OBJ)/tests/protobuf/+protolib2/tests/protobuf/+protolib2.descriptor : tests/protobuf/test2.proto $(OBJ)/tests/protobuf/+protolib/tests/protobuf/+protolib.descriptor
$(OBJ)/tests/protobuf/+protolib2/tests/protobuf/+protolib2.descriptor : $(OBJ)/.sentinels/tests/protobuf/+protolib2.mark
	$(hide) $(ECHO) PROTO tests/protobuf/+protolib2
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib2/tests/protobuf
	$(hide) $(PROTOC) --include_source_info --descriptor_set_out=$(OBJ)/tests/protobuf/+protolib2/tests/protobuf/+protolib2.descriptor tests/protobuf/test2.proto
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib_c_srcs
tests/protobuf/+protolib_c_srcs : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.h : tests/protobuf/test2.proto tests/protobuf/test.proto
$(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark
$(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.h : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark
$(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark
$(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.h : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_srcs.mark
	$(hide) $(ECHO) PROTOCC tests/protobuf/+protolib_c_srcs
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf
	$(hide) $(PROTOC) --cpp_out=$(OBJ)/tests/protobuf/+protolib_c_srcs tests/protobuf/test2.proto tests/protobuf/test.proto
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib_c_hdrs
tests/protobuf/+protolib_c_hdrs : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_hdrs.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib_c_hdrs.mark $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h : $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.h
$(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_hdrs.mark
$(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h : $(OBJ)/.sentinels/tests/protobuf/+protolib_c_hdrs.mark
	$(hide) $(ECHO) CHEADERS tests/protobuf/+protolib_c_hdrs
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf
	$(hide) cp $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h
	$(hide) cp $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc
tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc : $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc.mark $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o : $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h
$(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o : $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc.mark
	$(hide) $(ECHO) CXX tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc $(CFLAGS) -I$(OBJ)/tests/protobuf/+protolib_c_srcs -I$(OBJ)/tests/protobuf/+protolib_c_hdrs -I$(OBJ)/tests/protobuf/+protolib_c_hdrs
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc
tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc : $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc.mark $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o : $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h
$(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o : $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc.mark
	$(hide) $(ECHO) CXX tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o $(OBJ)/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc $(CFLAGS) -I$(OBJ)/tests/protobuf/+protolib_c_srcs -I$(OBJ)/tests/protobuf/+protolib_c_hdrs -I$(OBJ)/tests/protobuf/+protolib_c_hdrs
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+protolib_c
tests/protobuf/+protolib_c : $(OBJ)/.sentinels/tests/protobuf/+protolib_c.mark
$(OBJ)/.sentinels/tests/protobuf/+protolib_c.mark $(OBJ)/tests/protobuf/+protolib_c/+protolib_c.a : $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o
$(OBJ)/tests/protobuf/+protolib_c/+protolib_c.a : $(OBJ)/.sentinels/tests/protobuf/+protolib_c.mark
	$(hide) $(ECHO) LIB tests/protobuf/+protolib_c
	$(hide) mkdir -p $(OBJ)/tests/protobuf/+protolib_c
	$(hide) $(AR) cqs $(OBJ)/tests/protobuf/+protolib_c/+protolib_c.a $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf/+protolib_c/tests/protobuf/+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@

.PHONY: tests/protobuf/+all
tests/protobuf/+all : $(OBJ)/.sentinels/tests/protobuf/+all.mark
$(OBJ)/.sentinels/tests/protobuf/+all.mark : $(OBJ)/tests/protobuf/+protolib2/tests/protobuf/+protolib2.descriptor $(OBJ)/tests/protobuf/+protolib_c/+protolib_c.a $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf/+protolib_c_hdrs/tests/protobuf/test.pb.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/protobuf
	$(hide) touch $@
AB_LOADED = 1

