
.PHONY: tests/invocation/+r1
tests/invocation/+r1 : $(OBJ)/tests/invocation/+r1/r1.txt ;
$(OBJ)/tests/invocation/+r1/r1.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r1
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r1
	$(hide) echo tests/invocation/+r1 > $(OBJ)/tests/invocation/+r1/r1.txt

.PHONY: tests/invocation/+r2
tests/invocation/+r2 : $(OBJ)/tests/invocation/+r2/r2.txt ;
$(OBJ)/tests/invocation/+r2/r2.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r2
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r2
	$(hide) echo tests/invocation/+r2 > $(OBJ)/tests/invocation/+r2/r2.txt

.PHONY: tests/invocation/+all
tests/invocation/+all &: $(OBJ)/tests/invocation/+r1/r1.txt $(OBJ)/tests/invocation/+r2/r2.txt
	@

.PHONY: tests/invocation/+r3
tests/invocation/+r3 : $(OBJ)/tests/invocation/+r3/r3.txt ;
$(OBJ)/tests/invocation/+r3/r3.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r3
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r3
	$(hide) echo tests/invocation/+r3 > $(OBJ)/tests/invocation/+r3/r3.txt

.PHONY: tests/invocation/+r4
tests/invocation/+r4 : $(OBJ)/tests/invocation/+r4/r4.txt ;
$(OBJ)/tests/invocation/+r4/r4.txt &:
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r4
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r4
	$(hide) echo tests/invocation/+r4 > $(OBJ)/tests/invocation/+r4/r4.txt
AB_LOADED = 1

