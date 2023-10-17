
.PHONY: tests/clibrary+clibrary/tests/clibrary/lib1.c
tests/clibrary+clibrary/tests/clibrary/lib1.c $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o &: tests/clibrary/lib1.c tests/clibrary/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/tests/clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) -Itests/clibrary

.PHONY: tests/clibrary+clibrary/tests/clibrary/lib2.cc
tests/clibrary+clibrary/tests/clibrary/lib2.cc $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o &: tests/clibrary/lib2.cc tests/clibrary/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/tests/clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) -Itests/clibrary

.PHONY: tests/clibrary+clibrary
tests/clibrary+clibrary $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/$(OBJ)/tests/clibrary+clibrary/library.h &: tests/clibrary+clibrary/tests/clibrary/lib1.c tests/clibrary+clibrary/tests/clibrary/lib2.cc
	$(hide) $(ECHO) LIB tests/clibrary+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/$(OBJ)/tests/clibrary+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary
	$(hide) cp tests/clibrary/library.h $(OBJ)/tests/clibrary+clibrary/library.h
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o

.PHONY: tests/clibrary+cfile
tests/clibrary+cfile $(OBJ)/tests/clibrary+cfile/prog.o &: tests/clibrary/prog.c tests/clibrary+clibrary
	$(hide) $(ECHO) CC tests/clibrary+cfile
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+cfile/prog.o tests/clibrary/prog.c $(CFLAGS) -I$(OBJ)/tests/clibrary+clibrary/$(OBJ)/tests/clibrary+clibrary

.PHONY: tests/clibrary+cprogram
tests/clibrary+cprogram $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram &: tests/clibrary+cfile $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a tests/clibrary+clibrary
	$(hide) $(ECHO) CLINK tests/clibrary+cprogram
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram $(OBJ)/tests/clibrary+cfile/prog.o $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a 

.PHONY: tests/clibrary+all
tests/clibrary+all &: $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram
	$(hide) $(ECHO) EXPORT tests/clibrary+all
AB_LOADED = 1

