
.PHONY: tests/simple/+all
tests/simple/+all : $(OBJ)/.sentinels/tests/simple/+all
$(OBJ)/.sentinels/tests/simple/+all :
	$(hide) mkdir -p $(OBJ)/.sentinels/tests/simple
	$(hide) touch $@
AB_LOADED = 1

