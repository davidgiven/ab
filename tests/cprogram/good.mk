
.PHONY: tests/cprogram+cfile
tests/cprogram+cfile : $(OBJ)/tests/cprogram+cfile/cfile.o
$(OBJ)/tests/cprogram+cfile/cfile.o &: tests/cprogram/cfile.c
	$(hide) $(ECHO) CC tests/cprogram+cfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram+cfile/cfile.o tests/cprogram/cfile.c $(CFLAGS) -cflag

.PHONY: tests/cprogram+cxxfile
tests/cprogram+cxxfile : $(OBJ)/tests/cprogram+cxxfile/cxxfile.o
$(OBJ)/tests/cprogram+cxxfile/cxxfile.o &: tests/cprogram/cxxfile.c
	$(hide) $(ECHO) CXX tests/cprogram+cxxfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cxxfile
	$(hide) $(CXX) -c -o $(OBJ)/tests/cprogram+cxxfile/cxxfile.o tests/cprogram/cxxfile.c $(CFLAGS) -cxxflag

.PHONY: tests/cprogram+cprogram/tests/cprogram/implicitcfile.c
tests/cprogram+cprogram/tests/cprogram/implicitcfile.c : $(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o
$(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o &: tests/cprogram/implicitcfile.c
	$(hide) $(ECHO) CC tests/cprogram+cprogram/tests/cprogram/implicitcfile.c
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o tests/cprogram/implicitcfile.c $(CFLAGS) -cprogram-cflag

.PHONY: tests/cprogram+cprogram
tests/cprogram+cprogram : $(OBJ)/tests/cprogram+cprogram/cprogram+cprogram
$(OBJ)/tests/cprogram+cprogram/cprogram+cprogram &: tests/cprogram+cprogram/tests/cprogram/implicitcfile.c tests/cprogram+cfile
	$(hide) $(ECHO) CLINK tests/cprogram+cprogram
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/cprogram+cprogram/cprogram+cprogram $(OBJ)/tests/cprogram+cprogram/tests/cprogram/implicitcfile.c/implicitcfile.o $(OBJ)/tests/cprogram+cfile/cfile.o -ldflag

.PHONY: tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc
tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc : $(OBJ)/tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o
$(OBJ)/tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o &: tests/cprogram/implicitcxxfile.cc
	$(hide) $(ECHO) CXX tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc
	$(hide) $(CXX) -c -o $(OBJ)/tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o tests/cprogram/implicitcxxfile.cc $(CFLAGS) -cxxprogram-cflag

.PHONY: tests/cprogram+cxxprogram
tests/cprogram+cxxprogram : $(OBJ)/tests/cprogram+cxxprogram/cprogram+cxxprogram
$(OBJ)/tests/cprogram+cxxprogram/cprogram+cxxprogram &: tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc tests/cprogram+cxxfile
	$(hide) $(ECHO) CXXLINK tests/cprogram+cxxprogram
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cxxprogram
	$(hide) $(CXX) -o $(OBJ)/tests/cprogram+cxxprogram/cprogram+cxxprogram $(OBJ)/tests/cprogram+cxxprogram/tests/cprogram/implicitcxxfile.cc/implicitcxxfile.o $(OBJ)/tests/cprogram+cxxfile/cxxfile.o -ldflag

.PHONY: tests/cprogram+all
tests/cprogram+all &: tests/cprogram+cfile tests/cprogram+cxxfile tests/cprogram+cprogram tests/cprogram+cxxprogram
	$(hide) $(ECHO) EXPORT tests/cprogram+all
AB_LOADED = 1

