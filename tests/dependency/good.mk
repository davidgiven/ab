
clean::
	$(hide) rm -f out1
.PHONY: tests/dependency/+r1
tests/dependency/+r1 : out1
out1 :
	$(hide) $(ECHO) RULE tests/dependency/+r1


clean::
	$(hide) rm -f out2
.PHONY: tests/dependency/+r2
tests/dependency/+r2 : out2
out2 :
	$(hide) $(ECHO) RULE tests/dependency/+r2


clean::
	$(hide) rm -f outa
.PHONY: tests/dependency/+all
tests/dependency/+all : outa
outa : tests/dependency/+r1 tests/dependency/+r2
	$(hide) $(ECHO) RULE tests/dependency/+all

AB_LOADED = 1

