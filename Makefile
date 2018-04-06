# Copyright 2017 Intel Corporation.

LDFLAGS := -lssl -lcrypto
CFLAGS := -W -Wall -Werror -std=gnu9x

BINDIR := /usr/bin
LIBEXECDIR := /usr/libexec

.PHONY: build install check clean

build: clrtrust-helper clrtrust

clrtrust-helper: clrtrust-helper.o

clrtrust: clrtrust.in
	cat clrtrust.in | sed -e 's:LIBEXEC_CONFIG_VALUE:$(LIBEXECDIR):' > $@
	chmod +x clrtrust

install:
	install -D --mode=0755 clrtrust ${INSTALL_ROOT}${BINDIR}/clrtrust
	install -D --mode=0755 clrtrust-helper ${INSTALL_ROOT}${LIBEXECDIR}/clrtrust-helper

check: build
	bats -t test

clean:
	rm -rf clrtrust-helper clrtrust-helper.o clrtrust
