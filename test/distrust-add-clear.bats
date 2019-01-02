#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-2].pem $CLR_CLEAR_TRUST_SRC/trusted
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "distrust Clear-provided cert, add it back" {
    $CLRTRUST generate
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 9 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    $CLRTRUST remove $CERTS/c1.pem
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 3 ]
    [ -f $CLR_LOCAL_TRUST_SRC/distrusted/c1.pem ]
    [ -f $CLR_CLEAR_TRUST_SRC/trusted/c1.pem ]
    [ ! -f $CLR_LOCAL_TRUST_SRC/trusted/c1.pem ]
    $CLRTRUST add $CERTS/c1.pem
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    find $CLR_LOCAL_TRUST_SRC
    [ $cnt -eq 4 ]
    [ ! -f $CLR_LOCAL_TRUST_SRC/distrusted/c1.pem ]
    [ -f $CLR_CLEAR_TRUST_SRC/trusted/c1.pem ]
    [ ! -f $CLR_LOCAL_TRUST_SRC/trusted/c1.pem ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
