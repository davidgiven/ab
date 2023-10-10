.PHONY: tests/pkg+cprogram/cfile.c
tests/pkg+cprogram/cfile.c : $(OBJ)/tests/pkg+cprogram/cfile.c/cfile.o ;
$(OBJ)/tests/pkg+cprogram/cfile.c/cfile.o &: tests/pkg/cfile.c
	$(hide) $(ECHO) CC tests/pkg+cprogram/cfile.c
	$(hide) mkdir -p $(OBJ)/tests/pkg+cprogram/cfile.c
	$(hide) $(CC) -c -o $(OBJ)/tests/pkg+cprogram/cfile.c/cfile.o tests/pkg/cfile.c $(CFLAGS) --c-flag
.PHONY: tests/pkg+cprogram
tests/pkg+cprogram : $(OBJ)/tests/pkg+cprogram/pkg+cprogram ;
$(OBJ)/tests/pkg+cprogram/pkg+cprogram &: $(OBJ)/tests/pkg+cprogram/cfile.c/cfile.o
	$(hide) $(ECHO) CLINK tests/pkg+cprogram
	$(hide) mkdir -p $(OBJ)/tests/pkg+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/pkg+cprogram/pkg+cprogram $(OBJ)/tests/pkg+cprogram/cfile.c/cfile.o --libs-flag
tests/pkg+all : $(OBJ)/tests/pkg+cprogram/pkg+cprogram
	$(hide) $(ECHO) EXPORT tests/pkg+all
AB_LOADED = 1

