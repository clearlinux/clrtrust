#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    rm -rf $CLR_LOCAL_TRUST_SRC/trusted $CLR_LOCAL_TRUST_SRC/distrusted 
}

@test "add cert when the local trust src is not there" {
    # add acceptable CA
    run $CLRTRUST add $CERTS/c1.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    [ $status -eq 0 ]
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 1 ]
    [ -d $CLR_LOCAL_TRUST_SRC/trusted ]
    [ -d $CLR_LOCAL_TRUST_SRC/distrusted ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
