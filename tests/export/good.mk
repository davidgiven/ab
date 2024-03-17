
.PHONY: tests/export/+r1
tests/export/+r1 : out1 ;
out1 &:
	$(hide) $(ECHO) RULE tests/export/+r1

.PHONY: tests/export/+r2
tests/export/+r2 : out2 ;
out2 &:
	$(hide) $(ECHO) RULE tests/export/+r2

.PHONY: tests/export/+all+r1
tests/export/+all+r1 : r1 ;
r1 &: out1
	$(hide) $(ECHO) CP r1
	$(hide) cp out1 r1

.PHONY: tests/export/+all+r2
tests/export/+all+r2 : r2 ;
r2 &: out2
	$(hide) $(ECHO) CP r2
	$(hide) cp out2 r2

.PHONY: tests/export/+all
tests/export/+all &: r1 r2
	@
clean::
	$(hide) rm -f r1 r2
AB_LOADED = 1

