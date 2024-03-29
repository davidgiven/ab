
.PHONY: tests/simple/+all
tests/simple/+all : $(OBJ)/.sentinels/tests/simple/+all.mark
$(OBJ)/.sentinels/tests/simple/+all.mark :
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/simple
	$(hide) touch $(OBJ)/.sentinels/tests/simple/+all.mark
AB_LOADED = 1

