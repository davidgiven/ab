
.PHONY: tests/dependency/+r1
tests/dependency/+r1 : $(OBJ)/.sentinels/tests/dependency/+r1
out1 : $(OBJ)/.sentinels/tests/dependency/+r1
$(OBJ)/.sentinels/tests/dependency/+r1 :
	$(hide) $(ECHO) RULE tests/dependency/+r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $@

.PHONY: tests/dependency/+r2
tests/dependency/+r2 : $(OBJ)/.sentinels/tests/dependency/+r2
out2 : $(OBJ)/.sentinels/tests/dependency/+r2
$(OBJ)/.sentinels/tests/dependency/+r2 :
	$(hide) $(ECHO) RULE tests/dependency/+r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $@

.PHONY: tests/dependency/+all
tests/dependency/+all : $(OBJ)/.sentinels/tests/dependency/+all
outa : $(OBJ)/.sentinels/tests/dependency/+all
$(OBJ)/.sentinels/tests/dependency/+all : out1 out2
	$(hide) $(ECHO) RULE tests/dependency/+all
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $@
AB_LOADED = 1

