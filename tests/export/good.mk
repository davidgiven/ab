
.PHONY: tests/export/+r1
tests/export/+r1 : $(OBJ)/.sentinels/tests/export/+r1.mark
$(OBJ)/.sentinels/tests/export/+r1.mark :
	$(hide) $(ECHO) RULE tests/export/+r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $(OBJ)/.sentinels/tests/export/+r1.mark
out1 : $(OBJ)/.sentinels/tests/export/+r1.mark ;

.PHONY: tests/export/+r2
tests/export/+r2 : $(OBJ)/.sentinels/tests/export/+r2.mark
$(OBJ)/.sentinels/tests/export/+r2.mark :
	$(hide) $(ECHO) RULE tests/export/+r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $(OBJ)/.sentinels/tests/export/+r2.mark
out2 : $(OBJ)/.sentinels/tests/export/+r2.mark ;

.PHONY: tests/export/+all/+r1
tests/export/+all/+r1 : $(OBJ)/.sentinels/tests/export/+all/+r1.mark
$(OBJ)/.sentinels/tests/export/+all/+r1.mark : out1
	$(hide) $(ECHO) CP tests/export/+all/+r1
	$(hide) cp out1 r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export/+all
	$(hide) touch $(OBJ)/.sentinels/tests/export/+all/+r1.mark
r1 : $(OBJ)/.sentinels/tests/export/+all/+r1.mark ;
clean::
	$(hide) rm -f r1

.PHONY: tests/export/+all/+r2
tests/export/+all/+r2 : $(OBJ)/.sentinels/tests/export/+all/+r2.mark
$(OBJ)/.sentinels/tests/export/+all/+r2.mark : out2
	$(hide) $(ECHO) CP tests/export/+all/+r2
	$(hide) cp out2 r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export/+all
	$(hide) touch $(OBJ)/.sentinels/tests/export/+all/+r2.mark
r2 : $(OBJ)/.sentinels/tests/export/+all/+r2.mark ;
clean::
	$(hide) rm -f r2

.PHONY: tests/export/+all
tests/export/+all : $(OBJ)/.sentinels/tests/export/+all.mark
$(OBJ)/.sentinels/tests/export/+all.mark : r1 r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $(OBJ)/.sentinels/tests/export/+all.mark
AB_LOADED = 1

