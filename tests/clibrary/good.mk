.PHONY: tests/clibrary+clibrary/lib1.c
tests/clibrary+clibrary/lib1.c : $(OBJ)/tests/clibrary+clibrary/lib1.c/lib1.o ;
$(OBJ)/tests/clibrary+clibrary/lib1.c/lib1.o &: tests/clibrary/lib1.c tests/clibrary/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) 
.PHONY: tests/clibrary+clibrary/lib2.cc
tests/clibrary+clibrary/lib2.cc : $(OBJ)/tests/clibrary+clibrary/lib2.cc/lib2.o ;
$(OBJ)/tests/clibrary+clibrary/lib2.cc/lib2.o &: tests/clibrary/lib2.cc tests/clibrary/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) 
.PHONY: tests/clibrary+clibrary
tests/clibrary+clibrary : $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/library.h ;
$(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/library.h &: $(OBJ)/tests/clibrary+clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary+clibrary/lib2.cc/lib2.o
	$(hide) $(ECHO) AR tests/clibrary+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary+clibrary/lib2.cc/lib2.o
	$(hide) cp tests/clibrary/library.h $(OBJ)/tests/clibrary+clibrary/tests/clibrary/library.h
.PHONY: tests/clibrary+cprogram/prog.c
tests/clibrary+cprogram/prog.c : $(OBJ)/tests/clibrary+cprogram/prog.c/prog.o ;
$(OBJ)/tests/clibrary+cprogram/prog.c/prog.o &: tests/clibrary/prog.c $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/library.h
	$(hide) $(ECHO) CC tests/clibrary+cprogram/prog.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cprogram/prog.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+cprogram/prog.c/prog.o tests/clibrary/prog.c $(CFLAGS) -I$(OBJ)/tests/clibrary+clibrary
.PHONY: tests/clibrary+cprogram
tests/clibrary+cprogram : $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram ;
$(OBJ)/tests/clibrary+cprogram/clibrary+cprogram &: $(OBJ)/tests/clibrary+cprogram/prog.c/prog.o $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a
	$(hide) $(ECHO) CLINK tests/clibrary+cprogram
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram $(OBJ)/tests/clibrary+cprogram/prog.c/prog.o $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a 
tests/clibrary+all : $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram
	$(hide) $(ECHO) EXPORT tests/clibrary+all
AB_LOADED = 1

