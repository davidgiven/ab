export OBJ = .obj

.PHONY: all
all: +all
	
clean::
	rm distribution.tar.xz

include build/ab.mk
