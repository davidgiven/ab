
.PHONY: tests/invocation/+r1
tests/invocation/+r1 : $(OBJ)/.sentinels/tests/invocation/+r1.mark
$(OBJ)/tests/invocation/+r1/r1.txt : $(OBJ)/.sentinels/tests/invocation/+r1.mark
$(OBJ)/.sentinels/tests/invocation/+r1.mark :
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r1
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r1
	$(hide) echo tests/invocation/+r1 > $(OBJ)/tests/invocation/+r1/r1.txt
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/invocation
	$(hide) touch $@

.PHONY: tests/invocation/+r2
tests/invocation/+r2 : $(OBJ)/.sentinels/tests/invocation/+r2.mark
$(OBJ)/tests/invocation/+r2/r2.txt : $(OBJ)/.sentinels/tests/invocation/+r2.mark
$(OBJ)/.sentinels/tests/invocation/+r2.mark :
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r2
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r2
	$(hide) echo tests/invocation/+r2 > $(OBJ)/tests/invocation/+r2/r2.txt
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/invocation
	$(hide) touch $@

.PHONY: +fortesting
+fortesting : $(OBJ)/.sentinels/+fortesting.mark
$(OBJ)/+fortesting/out : $(OBJ)/.sentinels/+fortesting.mark
$(OBJ)/.sentinels/+fortesting.mark :
	$(hide) $(ECHO) TOUCH +fortesting
	$(hide) mkdir -p $(OBJ)/+fortesting
	$(hide) touch $(OBJ)/+fortesting/out
	$(hide) mkdir -p $(OBJ)/.sentinels
	$(hide) touch $@

.PHONY: tests/invocation/+all
tests/invocation/+all : $(OBJ)/.sentinels/tests/invocation/+all.mark
$(OBJ)/.sentinels/tests/invocation/+all.mark : $(OBJ)/tests/invocation/+r1/r1.txt $(OBJ)/tests/invocation/+r2/r2.txt $(OBJ)/+fortesting/out
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/invocation
	$(hide) touch $@

.PHONY: tests/invocation/+r3
tests/invocation/+r3 : $(OBJ)/.sentinels/tests/invocation/+r3.mark
$(OBJ)/tests/invocation/+r3/r3.txt : $(OBJ)/.sentinels/tests/invocation/+r3.mark
$(OBJ)/.sentinels/tests/invocation/+r3.mark :
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r3
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r3
	$(hide) echo tests/invocation/+r3 > $(OBJ)/tests/invocation/+r3/r3.txt
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/invocation
	$(hide) touch $@

.PHONY: tests/invocation/+r4
tests/invocation/+r4 : $(OBJ)/.sentinels/tests/invocation/+r4.mark
$(OBJ)/tests/invocation/+r4/r4.txt : $(OBJ)/.sentinels/tests/invocation/+r4.mark
$(OBJ)/.sentinels/tests/invocation/+r4.mark :
	$(hide) $(ECHO) WRITETEXT tests/invocation/+r4
	$(hide) mkdir -p $(OBJ)/tests/invocation/+r4
	$(hide) echo tests/invocation/+r4 > $(OBJ)/tests/invocation/+r4/r4.txt
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/invocation
	$(hide) touch $@
AB_LOADED = 1

