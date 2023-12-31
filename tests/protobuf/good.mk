
PKG_CONFIG ?= pkg-config
PACKAGES := $(shell $(PKG_CONFIG) --list-all | cut -d' ' -f1 | sort)


PROTOC ?= protoc
ifeq ($(filter protobuf, $(PACKAGES)),)
$(error Required package 'protobuf' not installed.)"
endif


.PHONY: tests/protobuf+protolib
tests/protobuf+protolib : $(OBJ)/tests/protobuf+protolib/tests/protobuf+protolib.descriptor ;
$(OBJ)/tests/protobuf+protolib/tests/protobuf+protolib.descriptor &: tests/protobuf/test.proto
	$(hide) $(ECHO) PROTO tests/protobuf+protolib
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib/tests
	$(hide) $(PROTOC) --include_source_info --descriptor_set_out=$(OBJ)/tests/protobuf+protolib/tests/protobuf+protolib.descriptor tests/protobuf/test.proto

.PHONY: tests/protobuf+protolib2
tests/protobuf+protolib2 : $(OBJ)/tests/protobuf+protolib2/tests/protobuf+protolib2.descriptor ;
$(OBJ)/tests/protobuf+protolib2/tests/protobuf+protolib2.descriptor &: tests/protobuf/test2.proto $(OBJ)/tests/protobuf+protolib/tests/protobuf+protolib.descriptor
	$(hide) $(ECHO) PROTO tests/protobuf+protolib2
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib2/tests
	$(hide) $(PROTOC) --include_source_info --descriptor_set_out=$(OBJ)/tests/protobuf+protolib2/tests/protobuf+protolib2.descriptor tests/protobuf/test2.proto

.PHONY: tests/protobuf+protolib_c_srcs
tests/protobuf+protolib_c_srcs : $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h ;
$(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h &: tests/protobuf/test2.proto tests/protobuf/test.proto
	$(hide) $(ECHO) PROTOCC tests/protobuf+protolib_c_srcs
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf
	$(hide) $(PROTOC) --cpp_out=$(OBJ)/tests/protobuf+protolib_c_srcs tests/protobuf/test2.proto tests/protobuf/test.proto

.PHONY: tests/protobuf+protolib_c_hdrs
tests/protobuf+protolib_c_hdrs : $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test.pb.h ;
$(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test.pb.h &: $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h
	$(hide) $(ECHO) HEADERS tests/protobuf+protolib_c_hdrs
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf
	$(hide) cp $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test2.pb.h
	$(hide) cp $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test.pb.h

.PHONY: tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc
tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc : $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o ;
$(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o &: $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test.pb.h
	$(hide) $(ECHO) CXX tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc $(CFLAGS) -I$(OBJ)/tests/protobuf+protolib_c_srcs -I$(OBJ)/tests/protobuf+protolib_c_hdrs

.PHONY: tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc
tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc : $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o ;
$(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o &: $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test2.pb.h $(OBJ)/tests/protobuf+protolib_c_hdrs/tests/protobuf/test.pb.h
	$(hide) $(ECHO) CXX tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o $(OBJ)/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc $(CFLAGS) -I$(OBJ)/tests/protobuf+protolib_c_srcs -I$(OBJ)/tests/protobuf+protolib_c_hdrs

.PHONY: tests/protobuf+protolib_c
tests/protobuf+protolib_c : $(OBJ)/tests/protobuf+protolib_c/protobuf+protolib_c.a ;
$(OBJ)/tests/protobuf+protolib_c/protobuf+protolib_c.a &: $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o
	$(hide) $(ECHO) LIB tests/protobuf+protolib_c
	$(hide) mkdir -p $(OBJ)/tests/protobuf+protolib_c
	$(hide) $(AR) cqs $(OBJ)/tests/protobuf+protolib_c/protobuf+protolib_c.a $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test2.pb.cc/test2.pb.o $(OBJ)/tests/protobuf+protolib_c/tests/protobuf+protolib_c_srcs/tests/protobuf/test.pb.cc/test.pb.o

.PHONY: tests/protobuf+all
tests/protobuf+all &: $(OBJ)/tests/protobuf+protolib2/tests/protobuf+protolib2.descriptor $(OBJ)/tests/protobuf+protolib_c/protobuf+protolib_c.a
	@
AB_LOADED = 1

