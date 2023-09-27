.PHONY: tests/dependency+r1
out1 : tests/dependency+r1 ;
tests/dependency+r1 :
	$(hide) echo RULE tests/dependency+r1
.PHONY: tests/dependency+r2
out2 : tests/dependency+r2 ;
tests/dependency+r2 :
	$(hide) echo RULE tests/dependency+r2
.PHONY: tests/dependency+all
outa : tests/dependency+all ;
tests/dependency+all : out1 out2
	$(hide) echo RULE tests/dependency+all
