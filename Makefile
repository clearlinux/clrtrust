# Copyright 2020 Intel Corporation.

LDLIBS := -lcrypto
CFLAGS := -W -Wall -Werror -std=gnu9x

BINDIR := /usr/bin
LIBEXECDIR := /usr/libexec
MANDIR := /usr/share/man

.PHONY: build install check clean

build: clrtrust-helper clrtrust man/clrtrust.1

clrtrust-helper: clrtrust-helper.o

clrtrust: clrtrust.in
	cat clrtrust.in | sed -e 's:LIBEXEC_CONFIG_VALUE:$(LIBEXECDIR):' > $@
	chmod +x clrtrust

man/%: man/%.md
	pandoc -s -f markdown -t man $< --output $@

install:
	install -D --mode=0755 clrtrust ${INSTALL_ROOT}${BINDIR}/clrtrust
	install -D --mode=0755 clrtrust-helper ${INSTALL_ROOT}${LIBEXECDIR}/clrtrust-helper
	install -D --mode=0644 man/clrtrust.1 ${INSTALL_ROOT}${MANDIR}/man1/clrtrust.1

check: build
	bats -t test

clean:
	rm -rf clrtrust-helper clrtrust-helper.o clrtrust man/clrtrust.1
