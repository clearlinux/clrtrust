#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-2].pem $CLR_CLEAR_TRUST_SRC/trusted
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "generate store, using internal rehash" {
    $CLRTRUST -c generate
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 9 ]
    cnt=$(find $STORE/anchors -type l | wc -l)
    [ $cnt -eq 5 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    [ -f $STORE/compat/ca-roots.keystore ]
    [ -f $STORE/compat/ca-roots.pem ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
