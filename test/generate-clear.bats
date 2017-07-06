#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-4].pem $CLR_CLEAR_TRUST_SRC/trusted
}

@test "generate store, all provided by Clear Linux" {
    $CLRTRUST generate
    cnt=`ls $STORE/anchors | wc -l`
    [ $cnt -eq 8 ]
    out=`$CLRTRUST list | grep ^id`
    expected="id: 1
id: 2
id: 3
id: 4"
    [ "x$out" = "x$expected" ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
