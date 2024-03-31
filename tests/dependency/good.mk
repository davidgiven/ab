
.PHONY: tests/dependency/+r1
tests/dependency/+r1 : $(OBJ)/.sentinels/tests/dependency/+r1.mark
$(OBJ)/.sentinels/tests/dependency/+r1.mark :
	$(hide) $(ECHO) RULE tests/dependency/+r1
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $(OBJ)/.sentinels/tests/dependency/+r1.mark
.SECONDARY: out1
out1 : $(OBJ)/.sentinels/tests/dependency/+r1.mark ;

.PHONY: tests/dependency/+r2
tests/dependency/+r2 : $(OBJ)/.sentinels/tests/dependency/+r2.mark
$(OBJ)/.sentinels/tests/dependency/+r2.mark :
	$(hide) $(ECHO) RULE tests/dependency/+r2
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $(OBJ)/.sentinels/tests/dependency/+r2.mark
.SECONDARY: out2
out2 : $(OBJ)/.sentinels/tests/dependency/+r2.mark ;

.PHONY: tests/dependency/+all
tests/dependency/+all : $(OBJ)/.sentinels/tests/dependency/+all.mark
$(OBJ)/.sentinels/tests/dependency/+all.mark : out1 out2
	$(hide) $(ECHO) RULE tests/dependency/+all
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/dependency
	$(hide) touch $(OBJ)/.sentinels/tests/dependency/+all.mark
.SECONDARY: outa
outa : $(OBJ)/.sentinels/tests/dependency/+all.mark ;
AB_LOADED = 1

