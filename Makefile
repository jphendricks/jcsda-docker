# DOCKER_BUILD_FLAGS ?=
# VERSION ?= latest
# BUILD_JOBS ?= 10
# COEF_TAR ?= fix_REL-2.4.0.tgz
# PIP_CONF ?= $${HOME}/.config/pip/pip.conf
#
# BASE_DOCKER_BUILD_FLAGS += --build-arg JOBS=${BUILD_JOBS}
# BASE_DOCKER_BUILD_FLAGS += --build-arg COEF_TAR=${COEF_TAR}
# BASE_DOCKER_BUILD_FLAGS += --ssh default
#
# RUN_DOCKER_BUILD_FLAGS += --secret id=pipconf,src=${PIP_CONF}
#
# DEV_DOCKER_BUILD_FLAGS += --secret id=pipconf,src=${PIP_CONF}

# all: base run dev
all: build

# fix_REL-2.4.0.tgz:
# 	./Get_CRTM_Binary_Files.sh

build:
	docker build -t netcdf-image .

run:
	docker run -it --entrypoint "/bin/bash" netcdf-image

dev:
	cp ../setup.cfg $@
	cd $@ && DOCKER_BUILDKIT=1 docker build -t iceddevops/$@:${VERSION} ${DEV_DOCKER_BUILD_FLAGS} .


.PHONY: build run dev all
