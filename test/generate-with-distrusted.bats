#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-2].pem $CLR_CLEAR_TRUST_SRC/trusted
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
    cp $CERTS/c2.pem $CLR_LOCAL_TRUST_SRC/distrusted
}

@test "generate store, source both Clear and local, local distrust" {
    $CLRTRUST generate
    cnt=$(ls $STORE/anchors | wc -l)
    [ ! -f $STORE/anchors/c2.pem ]
    [ $cnt -eq 6 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 3 ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
