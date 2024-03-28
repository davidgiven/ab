
.PHONY: tests/export/+r1
tests/export/+r1 : $(OBJ)/.sentinels/tests/export/+r1
out1 : $(OBJ)/.sentinels/tests/export/+r1
$(OBJ)/.sentinels/tests/export/+r1 :
	$(hide) $(ECHO) RULE tests/export/+r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $@

.PHONY: tests/export/+r2
tests/export/+r2 : $(OBJ)/.sentinels/tests/export/+r2
out2 : $(OBJ)/.sentinels/tests/export/+r2
$(OBJ)/.sentinels/tests/export/+r2 :
	$(hide) $(ECHO) RULE tests/export/+r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $@

.PHONY: tests/export/+all/+r1
tests/export/+all/+r1 : $(OBJ)/.sentinels/tests/export/+all/+r1
r1 : $(OBJ)/.sentinels/tests/export/+all/+r1
$(OBJ)/.sentinels/tests/export/+all/+r1 : out1
	$(hide) $(ECHO) CP tests/export/+all/+r1
	$(hide) cp out1 r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export/+all
	$(hide) touch $@
clean::
	$(hide) rm -f r1

.PHONY: tests/export/+all/+r2
tests/export/+all/+r2 : $(OBJ)/.sentinels/tests/export/+all/+r2
r2 : $(OBJ)/.sentinels/tests/export/+all/+r2
$(OBJ)/.sentinels/tests/export/+all/+r2 : out2
	$(hide) $(ECHO) CP tests/export/+all/+r2
	$(hide) cp out2 r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export/+all
	$(hide) touch $@
clean::
	$(hide) rm -f r2

.PHONY: tests/export/+all
tests/export/+all : $(OBJ)/.sentinels/tests/export/+all
r1 r2 : $(OBJ)/.sentinels/tests/export/+all
$(OBJ)/.sentinels/tests/export/+all :
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/export
	$(hide) touch $@
AB_LOADED = 1

