
.PHONY: tests/clibrary+clibrary_hdrs
tests/clibrary+clibrary_hdrs : $(OBJ)/tests/clibrary+clibrary_hdrs/library.h ;
$(OBJ)/tests/clibrary+clibrary_hdrs/library.h &: tests/clibrary/library.h
	$(hide) $(ECHO) HEADERS tests/clibrary+clibrary_hdrs
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary_hdrs
	$(hide) cp tests/clibrary/library.h $(OBJ)/tests/clibrary+clibrary_hdrs/library.h

.PHONY: tests/clibrary+clibrary/tests/clibrary/lib1.c
tests/clibrary+clibrary/tests/clibrary/lib1.c : $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o ;
$(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o &: tests/clibrary/lib1.c $(OBJ)/tests/clibrary+clibrary_hdrs/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/tests/clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) -I$(OBJ)/tests/clibrary+clibrary_hdrs

.PHONY: tests/clibrary+clibrary/tests/clibrary/lib2.cc
tests/clibrary+clibrary/tests/clibrary/lib2.cc : $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o ;
$(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o &: tests/clibrary/lib2.cc $(OBJ)/tests/clibrary+clibrary_hdrs/library.h
	$(hide) $(ECHO) CC tests/clibrary+clibrary/tests/clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) -I$(OBJ)/tests/clibrary+clibrary_hdrs

.PHONY: tests/clibrary+clibrary
tests/clibrary+clibrary : $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a ;
$(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a &: $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o
	$(hide) $(ECHO) LIB tests/clibrary+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary+clibrary
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary+clibrary/tests/clibrary/lib2.cc/lib2.o

.PHONY: tests/clibrary+cfile
tests/clibrary+cfile : $(OBJ)/tests/clibrary+cfile/prog.o ;
$(OBJ)/tests/clibrary+cfile/prog.o &: tests/clibrary/prog.c $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a
	$(hide) $(ECHO) CC tests/clibrary+cfile
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary+cfile/prog.o tests/clibrary/prog.c $(CFLAGS) 

.PHONY: tests/clibrary+cprogram
tests/clibrary+cprogram : $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram$(EXT) ;
$(OBJ)/tests/clibrary+cprogram/clibrary+cprogram$(EXT) &: $(OBJ)/tests/clibrary+cfile/prog.o $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a
	$(hide) $(ECHO) CLINK tests/clibrary+cprogram
	$(hide) mkdir -p $(OBJ)/tests/clibrary+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram$(EXT) $(OBJ)/tests/clibrary+cfile/prog.o $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a $(OBJ)/tests/clibrary+clibrary/clibrary+clibrary.a  $(LDFLAGS)

.PHONY: tests/clibrary+all
tests/clibrary+all &: $(OBJ)/tests/clibrary+cprogram/clibrary+cprogram$(EXT)
	$(hide) $(ECHO) EXPORT tests/clibrary+all
AB_LOADED = 1

