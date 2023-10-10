.PHONY: tests/cprogram+cfile
tests/cprogram+cfile : $(OBJ)/tests/cprogram+cfile/cprogram+cfile.o ;
$(OBJ)/tests/cprogram+cfile/cprogram+cfile.o &: tests/cprogram/cfile.c
	$(hide) $(ECHO) CC tests/cprogram+cfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram+cfile/cprogram+cfile.o tests/cprogram/cfile.c $(CFLAGS) -cflag
.PHONY: tests/cprogram+cxxfile
tests/cprogram+cxxfile : $(OBJ)/tests/cprogram+cxxfile/cprogram+cxxfile.o ;
$(OBJ)/tests/cprogram+cxxfile/cprogram+cxxfile.o &: tests/cprogram/cxxfile.c
	$(hide) $(ECHO) CXX tests/cprogram+cxxfile
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cxxfile
	$(hide) $(CXX) -c -o $(OBJ)/tests/cprogram+cxxfile/cprogram+cxxfile.o tests/cprogram/cxxfile.c $(CFLAGS) -cxxflag
.PHONY: tests/cprogram+cprogram/implicitcfile.c
tests/cprogram+cprogram/implicitcfile.c : $(OBJ)/tests/cprogram+cprogram/implicitcfile.c/implicitcfile.o ;
$(OBJ)/tests/cprogram+cprogram/implicitcfile.c/implicitcfile.o &: tests/cprogram/implicitcfile.c
	$(hide) $(ECHO) CC tests/cprogram+cprogram/implicitcfile.c
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cprogram/implicitcfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/cprogram+cprogram/implicitcfile.c/implicitcfile.o tests/cprogram/implicitcfile.c $(CFLAGS) -cprogram-cflag
.PHONY: tests/cprogram+cprogram
tests/cprogram+cprogram : $(OBJ)/tests/cprogram+cprogram/cprogram+cprogram ;
$(OBJ)/tests/cprogram+cprogram/cprogram+cprogram &: $(OBJ)/tests/cprogram+cprogram/implicitcfile.c/implicitcfile.o $(OBJ)/tests/cprogram+cfile/cprogram+cfile.o
	$(hide) $(ECHO) CLINK tests/cprogram+cprogram
	$(hide) mkdir -p $(OBJ)/tests/cprogram+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/cprogram+cprogram/cprogram+cprogram $(OBJ)/tests/cprogram+cprogram/implicitcfile.c/implicitcfile.o $(OBJ)/tests/cprogram+cfile/cprogram+cfile.o 
tests/cprogram+all : $(OBJ)/tests/cprogram+cfile/cprogram+cfile.o $(OBJ)/tests/cprogram+cxxfile/cprogram+cxxfile.o $(OBJ)/tests/cprogram+cprogram/cprogram+cprogram
	$(hide) $(ECHO) EXPORT tests/cprogram+all
AB_LOADED = 1

