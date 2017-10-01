#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-2].pem $CLR_CLEAR_TRUST_SRC/trusted
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
    # add duplicate
    cp $CERTS/c1.pem $CLR_LOCAL_TRUST_SRC/trusted/c1-local.pem
    cp $CERTS/c1.pem $CLR_LOCAL_TRUST_SRC/trusted/c100-new.pem
    cp $CERTS/c2.pem $CLR_LOCAL_TRUST_SRC/trusted/c2-local.pem
}

@test "generate store containing duplicates, multiple" {
    run $CLRTRUST generate
    [ $status -eq 0 ]
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 8 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
}

@test "generate store containing duplicates, single, many instances" {
    rm $CLR_LOCAL_TRUST_SRC/trusted/c2-local.pem
    run $CLRTRUST generate
    [ $status -eq 0 ]
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 8 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    $CLRTRUST list
}

@test "generate store containing duplicates, single, one instance" {
    rm $CLR_LOCAL_TRUST_SRC/trusted/c100-new.pem
    run $CLRTRUST generate
    [ $status -eq 0 ]
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 8 ]
    cnt=$($CLRTRUST list | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    $CLRTRUST list
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
