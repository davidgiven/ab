
.PHONY: tests/cprogram/+cfile
tests/cprogram/+cfile : $(OBJ)/.sentinels/tests/cprogram/+cfile.mark
$(OBJ)/.sentinels/tests/cprogram/+cfile.mark $(OBJ)/tests/cprogram/+cfile/cfile.o : tests/cprogram/cfile.c
$(OBJ)/tests/cprogram/+cfile/cfile.o : $(OBJ)/.sentinels/tests/cprogram/+cfile.mark
	$(hide) $(ECHO) CC tests/cprogram/+cfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram/+cfile/cfile.o tests/cprogram/cfile.c $(CFLAGS) -cflag
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+cxxfile
tests/cprogram/+cxxfile : $(OBJ)/.sentinels/tests/cprogram/+cxxfile.mark
$(OBJ)/.sentinels/tests/cprogram/+cxxfile.mark $(OBJ)/tests/cprogram/+cxxfile/cxxfile.o : tests/cprogram/cxxfile.c
$(OBJ)/tests/cprogram/+cxxfile/cxxfile.o : $(OBJ)/.sentinels/tests/cprogram/+cxxfile.mark
	$(hide) $(ECHO) CXX tests/cprogram/+cxxfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cxxfile
	$(hide) $(CXX) -c -o $(OBJ)/tests/cprogram/+cxxfile/cxxfile.o tests/cprogram/cxxfile.c $(CFLAGS) -cxxflag
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c
tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c : $(OBJ)/.sentinels/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c.mark
$(OBJ)/.sentinels/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c.mark $(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o : tests/cprogram/implicitcfile.c
$(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o : $(OBJ)/.sentinels/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c.mark
	$(hide) $(ECHO) CC tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o tests/cprogram/implicitcfile.c $(CFLAGS) -cprogram-cflag
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram/+cprogram/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+cprogram
tests/cprogram/+cprogram : $(OBJ)/.sentinels/tests/cprogram/+cprogram.mark
$(OBJ)/.sentinels/tests/cprogram/+cprogram.mark $(OBJ)/tests/cprogram/+cprogram/+cprogram$(EXT) : $(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o $(OBJ)/tests/cprogram/+cfile/cfile.o
$(OBJ)/tests/cprogram/+cprogram/+cprogram$(EXT) : $(OBJ)/.sentinels/tests/cprogram/+cprogram.mark
	$(hide) $(ECHO) CLINK tests/cprogram/+cprogram
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/cprogram/+cprogram/+cprogram$(EXT) $(OBJ)/tests/cprogram/+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o $(OBJ)/tests/cprogram/+cfile/cfile.o -ldflag $(LDFLAGS)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc
tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc : $(OBJ)/.sentinels/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc.mark
$(OBJ)/.sentinels/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc.mark $(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o : tests/cprogram/implicitcxxfile.cc
$(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o : $(OBJ)/.sentinels/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc.mark
	$(hide) $(ECHO) CXX tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o tests/cprogram/implicitcxxfile.cc $(CFLAGS) -cxxprogram-cflag
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram/+cxxprogram/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+cxxprogram
tests/cprogram/+cxxprogram : $(OBJ)/.sentinels/tests/cprogram/+cxxprogram.mark
$(OBJ)/.sentinels/tests/cprogram/+cxxprogram.mark $(OBJ)/tests/cprogram/+cxxprogram/+cxxprogram$(EXT) : $(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o $(OBJ)/tests/cprogram/+cxxfile/cxxfile.o
$(OBJ)/tests/cprogram/+cxxprogram/+cxxprogram$(EXT) : $(OBJ)/.sentinels/tests/cprogram/+cxxprogram.mark
	$(hide) $(ECHO) CXXLINK tests/cprogram/+cxxprogram
	$(hide) mkdir -p $(OBJ)/tests/cprogram/+cxxprogram
	$(hide) $(CXX) -o $(OBJ)/tests/cprogram/+cxxprogram/+cxxprogram$(EXT) $(OBJ)/tests/cprogram/+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o $(OBJ)/tests/cprogram/+cxxfile/cxxfile.o -ldflag $(LDFLAGS)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram
	$(hide) touch $@

.PHONY: tests/cprogram/+all
tests/cprogram/+all : $(OBJ)/.sentinels/tests/cprogram/+all.mark
$(OBJ)/.sentinels/tests/cprogram/+all.mark : $(OBJ)/tests/cprogram/+cfile/cfile.o $(OBJ)/tests/cprogram/+cxxfile/cxxfile.o $(OBJ)/tests/cprogram/+cprogram/+cprogram$(EXT) $(OBJ)/tests/cprogram/+cxxprogram/+cxxprogram$(EXT)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/cprogram
	$(hide) touch $@
AB_LOADED = 1

