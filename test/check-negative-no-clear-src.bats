#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    rm -r $CLR_CLEAR_TRUST_SRC
    cp $CERTS/c[3-4].pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "check fails when there's no Clear source" {
    run $CLRTRUST check
    [ $status -ne 0 ]
    [ ! -z "$output" ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
