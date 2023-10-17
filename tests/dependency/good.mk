
.PHONY: tests/dependency+r1
tests/dependency+r1 out1 &:
	$(hide) $(ECHO) RULE tests/dependency+r1

.PHONY: tests/dependency+r2
tests/dependency+r2 out2 &:
	$(hide) $(ECHO) RULE tests/dependency+r2

.PHONY: tests/dependency+all
tests/dependency+all outa &: tests/dependency+r1 tests/dependency+r2
	$(hide) $(ECHO) RULE tests/dependency+all
AB_LOADED = 1

