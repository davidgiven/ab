
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


.PHONY: tests/+tests
tests/+tests : tests/+clibrary tests/+cprogram tests/+dependency tests/+export tests/+invocation tests/+pkg tests/+protobuf tests/+simple


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

