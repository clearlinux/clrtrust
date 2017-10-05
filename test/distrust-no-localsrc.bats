#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c1.pem $CLR_CLEAR_TRUST_SRC/trusted
    rm -rf $CLR_LOCAL_TRUST_SRC
}

@test "remove cert when local trust src is not there" {
    # add acceptable CA
    run $CLRTRUST remove $CERTS/c1.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    [ $status -eq 0 ]
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 0 ]
    [ -d $CLR_LOCAL_TRUST_SRC/trusted ]
    [ -d $CLR_LOCAL_TRUST_SRC/distrusted ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
