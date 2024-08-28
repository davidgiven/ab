
.PHONY: tests/export/+r1
tests/export/+r1 : $(OBJ)/tests/export/+r1/out1
$(OBJ)/tests/export/+r1/out1 &:
	$(hide) $(ECHO) RULE tests/export/+r1
	$(hide) mkdir -p $(OBJ)/tests/export/+r1


.PHONY: tests/export/+r2
tests/export/+r2 : $(OBJ)/tests/export/+r2/out2
$(OBJ)/tests/export/+r2/out2 &:
	$(hide) $(ECHO) RULE tests/export/+r2
	$(hide) mkdir -p $(OBJ)/tests/export/+r2


.PHONY: tests/export/+re
tests/export/+re : $(OBJ)/tests/export/+re/outa
$(OBJ)/tests/export/+re/outa &: tests/export/+r1 tests/export/+r2
	$(hide) $(ECHO) RULE tests/export/+re
	$(hide) mkdir -p $(OBJ)/tests/export/+re


clean::
	$(hide) rm -f r1
.PHONY: tests/export/+all/r1
tests/export/+all/r1 : r1
r1 &: $(OBJ)/tests/export/+r1/out1
	$(hide) $(ECHO) CP tests/export/+all/r1
	$(hide) cp $(OBJ)/tests/export/+r1/out1 r1


clean::
	$(hide) rm -f r2
.PHONY: tests/export/+all/r2
tests/export/+all/r2 : r2
r2 &: $(OBJ)/tests/export/+r2/out2
	$(hide) $(ECHO) CP tests/export/+all/r2
	$(hide) cp $(OBJ)/tests/export/+r2/out2 r2


.PHONY: tests/export/+all
tests/export/+all : tests/export/+all/r1 tests/export/+all/r2

AB_LOADED = 1

