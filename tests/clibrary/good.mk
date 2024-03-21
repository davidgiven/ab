
.PHONY: tests/clibrary/+cheaders
tests/clibrary/+cheaders : $(OBJ)/tests/clibrary/+cheaders/library.h ;
$(OBJ)/tests/clibrary/+cheaders/library.h &: tests/clibrary/library.h
	$(hide) $(ECHO) CHEADERS tests/clibrary/+cheaders
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cheaders
	$(hide) cp tests/clibrary/library.h $(OBJ)/tests/clibrary/+cheaders/library.h

.PHONY: tests/clibrary/+cfile
tests/clibrary/+cfile : $(OBJ)/tests/clibrary/+cfile/prog.o ;
$(OBJ)/tests/clibrary/+cfile/prog.o &: tests/clibrary/prog.c $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+cfile
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+cfile/prog.o tests/clibrary/prog.c $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders

.PHONY: tests/clibrary/+clibrary/tests/clibrary/lib1.c
tests/clibrary/+clibrary/tests/clibrary/lib1.c : $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o ;
$(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o &: tests/clibrary/lib1.c $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary/tests/clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders

.PHONY: tests/clibrary/+clibrary/tests/clibrary/lib2.cc
tests/clibrary/+clibrary/tests/clibrary/lib2.cc : $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o ;
$(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o &: tests/clibrary/lib2.cc $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary/tests/clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders

.PHONY: tests/clibrary/+clibrary
tests/clibrary/+clibrary : $(OBJ)/tests/clibrary/+clibrary/+clibrary.a ;
$(OBJ)/tests/clibrary/+clibrary/+clibrary.a &: $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o
	$(hide) $(ECHO) LIB tests/clibrary/+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o

.PHONY: tests/clibrary/+cprogram
tests/clibrary/+cprogram : $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) ;
$(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) &: $(OBJ)/tests/clibrary/+cfile/prog.o $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a
	$(hide) $(ECHO) CLINK tests/clibrary/+cprogram
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) $(OBJ)/tests/clibrary/+cfile/prog.o $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a  $(LDFLAGS)

.PHONY: tests/clibrary/+all
tests/clibrary/+all &: $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) $(OBJ)/tests/clibrary/+cheaders/library.h
	@
AB_LOADED = 1

