#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-2].pem $CLR_CLEAR_TRUST_SRC/trusted
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "distrust Clear-provided CAs" {
    run $CLRTRUST generate
    [ $status -eq 0 ]
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 9 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    # removing a Clear-provided CA should "distrust" it, not remove
    [ -f $CLR_TRUST_STORE/anchors/c1.pem ]
    $CLRTRUST remove $CERTS/c1.pem
    [ -f $CLR_LOCAL_TRUST_SRC/distrusted/c1.pem ]
    [ ! -f $CLR_TRUST_STORE/anchors/c1.pem ]
    # removing a locally provided CA should wipe it out from the trust store
    [ -f $CLR_TRUST_STORE/anchors/c3.pem ]
    $CLRTRUST remove $CERTS/c3.pem
    [ ! -f $CLR_LOCAL_TRUST_SRC/trusted/c3.pem ]
    [ ! -f $CLR_TRUST_STORE/anchors/c3.pem ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
