# Copyright 2017 Intel Corporation.
all:
	@true

install:
	install -D --mode=0755 clrtrust ${INSTALL_ROOT}/usr/bin/clrtrust

check:
	bats -t test

