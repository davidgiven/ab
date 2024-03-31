
.PHONY: tests/clibrary/+cheaders
tests/clibrary/+cheaders : $(OBJ)/.sentinels/tests/clibrary/+cheaders.mark
$(OBJ)/.sentinels/tests/clibrary/+cheaders.mark : tests/clibrary/library.h
	$(hide) $(ECHO) CHEADERS tests/clibrary/+cheaders
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cheaders
	$(hide) cp tests/clibrary/library.h $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+cheaders.mark
.SECONDARY: $(OBJ)/tests/clibrary/+cheaders/library.h
$(OBJ)/tests/clibrary/+cheaders/library.h : $(OBJ)/.sentinels/tests/clibrary/+cheaders.mark ;

.PHONY: tests/clibrary/+cfile
tests/clibrary/+cfile : $(OBJ)/.sentinels/tests/clibrary/+cfile.mark
$(OBJ)/.sentinels/tests/clibrary/+cfile.mark : tests/clibrary/prog.c $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+cfile
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cfile
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+cfile/prog.o tests/clibrary/prog.c $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+cfile.mark
.SECONDARY: $(OBJ)/tests/clibrary/+cfile/prog.o
$(OBJ)/tests/clibrary/+cfile/prog.o : $(OBJ)/.sentinels/tests/clibrary/+cfile.mark ;

.PHONY: tests/clibrary/+clibrary/tests/clibrary/lib1.c
tests/clibrary/+clibrary/tests/clibrary/lib1.c : $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib1.c.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib1.c.mark : tests/clibrary/lib1.c $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary/tests/clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib1.c.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o
$(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o : $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib1.c.mark ;

.PHONY: tests/clibrary/+clibrary/tests/clibrary/lib2.cc
tests/clibrary/+clibrary/tests/clibrary/lib2.cc : $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib2.cc.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib2.cc.mark : tests/clibrary/lib2.cc $(OBJ)/tests/clibrary/+cheaders/library.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary/tests/clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders --cheader-cflags -I$(OBJ)/tests/clibrary/+cheaders
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib2.cc.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o
$(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o : $(OBJ)/.sentinels/tests/clibrary/+clibrary/tests/clibrary/lib2.cc.mark ;

.PHONY: tests/clibrary/+clibrary
tests/clibrary/+clibrary : $(OBJ)/.sentinels/tests/clibrary/+clibrary.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary.mark : $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o
	$(hide) $(ECHO) LIB tests/clibrary/+clibrary
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary/tests/clibrary/lib2.cc/lib2.o
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary/+clibrary.a
$(OBJ)/tests/clibrary/+clibrary/+clibrary.a : $(OBJ)/.sentinels/tests/clibrary/+clibrary.mark ;

.PHONY: tests/clibrary/+cprogram
tests/clibrary/+cprogram : $(OBJ)/.sentinels/tests/clibrary/+cprogram.mark
$(OBJ)/.sentinels/tests/clibrary/+cprogram.mark : $(OBJ)/tests/clibrary/+cfile/prog.o $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a
	$(hide) $(ECHO) CLINK tests/clibrary/+cprogram
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+cprogram
	$(hide) $(CC) -o $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) $(OBJ)/tests/clibrary/+cfile/prog.o $(OBJ)/tests/clibrary/+clibrary/+clibrary.a $(OBJ)/tests/clibrary/+clibrary/+clibrary.a  $(LDFLAGS)
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+cprogram.mark
.SECONDARY: $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT)
$(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) : $(OBJ)/.sentinels/tests/clibrary/+cprogram.mark ;

.PHONY: tests/clibrary/+clibrary2_hdrs
tests/clibrary/+clibrary2_hdrs : $(OBJ)/.sentinels/tests/clibrary/+clibrary2_hdrs.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary2_hdrs.mark : tests/clibrary/library2.h
	$(hide) $(ECHO) CHEADERS tests/clibrary/+clibrary2_hdrs
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary2_hdrs
	$(hide) cp tests/clibrary/library2.h $(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary2_hdrs.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h
$(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h : $(OBJ)/.sentinels/tests/clibrary/+clibrary2_hdrs.mark ;

.PHONY: tests/clibrary/+clibrary2/tests/clibrary/lib1.c
tests/clibrary/+clibrary2/tests/clibrary/lib1.c : $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib1.c.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib1.c.mark : tests/clibrary/lib1.c $(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary2/tests/clibrary/lib1.c
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c/lib1.o tests/clibrary/lib1.c $(CFLAGS) -I$(OBJ)/tests/clibrary/+clibrary2_hdrs -I$(OBJ)/tests/clibrary/+clibrary2_hdrs
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib1.c.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c/lib1.o
$(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c/lib1.o : $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib1.c.mark ;

.PHONY: tests/clibrary/+clibrary2/tests/clibrary/lib2.cc
tests/clibrary/+clibrary2/tests/clibrary/lib2.cc : $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc.mark : tests/clibrary/lib2.cc $(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h
	$(hide) $(ECHO) CC tests/clibrary/+clibrary2/tests/clibrary/lib2.cc
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc
	$(hide) $(CC) -c -o $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc/lib2.o tests/clibrary/lib2.cc $(CFLAGS) -I$(OBJ)/tests/clibrary/+clibrary2_hdrs -I$(OBJ)/tests/clibrary/+clibrary2_hdrs
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc/lib2.o
$(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc/lib2.o : $(OBJ)/.sentinels/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc.mark ;

.PHONY: tests/clibrary/+clibrary2
tests/clibrary/+clibrary2 : $(OBJ)/.sentinels/tests/clibrary/+clibrary2.mark
$(OBJ)/.sentinels/tests/clibrary/+clibrary2.mark : $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc/lib2.o
	$(hide) $(ECHO) LIB tests/clibrary/+clibrary2
	$(hide) mkdir -p $(OBJ)/tests/clibrary/+clibrary2
	$(hide) $(AR) cqs $(OBJ)/tests/clibrary/+clibrary2/+clibrary2.a $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib1.c/lib1.o $(OBJ)/tests/clibrary/+clibrary2/tests/clibrary/lib2.cc/lib2.o
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+clibrary2.mark
.SECONDARY: $(OBJ)/tests/clibrary/+clibrary2/+clibrary2.a
$(OBJ)/tests/clibrary/+clibrary2/+clibrary2.a : $(OBJ)/.sentinels/tests/clibrary/+clibrary2.mark ;

.PHONY: tests/clibrary/+all
tests/clibrary/+all : $(OBJ)/.sentinels/tests/clibrary/+all.mark
$(OBJ)/.sentinels/tests/clibrary/+all.mark : $(OBJ)/tests/clibrary/+cprogram/+cprogram$(EXT) $(OBJ)/tests/clibrary/+cheaders/library.h $(OBJ)/tests/clibrary/+clibrary2/+clibrary2.a $(OBJ)/tests/clibrary/+clibrary2_hdrs/library2.h
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/clibrary
	$(hide) touch $(OBJ)/.sentinels/tests/clibrary/+all.mark
AB_LOADED = 1

