export OBJ = .obj

.PHONY: all
all: +all
	
include build/ab.mk

DOCKERFILES = \
	debian11 \
    debian12

define run-docker
    docker build -t $1 -f tests/docker/Dockerfile.$(strip $1) .
    docker run \
        --device=/dev/kvm \
        --rm \
        --attach STDOUT \
		--attach STDERR \
        $1 \
        make

endef

.PHONY: docker
docker: distribution.tar.xz
	$(hide) echo DOCKERTESTS
	$(foreach f,$(DOCKERFILES), $(call run-docker, $f))
