export OBJ = .obj

.PHONY: all
all: +all
	
include build/ab.mk

DOCKERFILES = \
    Dockerfile.debian12

define run-docker
    docker run \
        --device=/dev/kvm \
        --rm \
        -it \
        $$(docker build -q -f tests/docker/$(strip $1) .) \
        make
endef

.PHONY: docker
docker: distribution.tar.xz
	$(hide) echo DOCKERTESTS
	$(foreach f,$(DOCKERFILES), $(call run-docker, $f) &&) true
