#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
}

@test "generate empty store, add certificate" {
    run $CLRTRUST generate
    cnt=`ls $STORE/anchors | wc -l`
    [ $cnt -eq 0 ]
    run $CLRTRUST list
    [ $status -eq 0 ]
    cnt=`$CLRTRUST list | grep ^id | wc -l`
    [ $cnt -eq 0 ]
    # try adding intermediate CA
    run $CLRTRUST add $CERTS/bad/intermediate.pem
    [ $status -eq 128 ]
    run $CLRTRUST list
    cnt=`echo "$output"| grep ^id | wc -l`
    [ $cnt -eq 0 ]
    # try adding leaf certificate
    run $CLRTRUST add $CERTS/bad/leaf.pem
    [ $status -eq 128 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 0 ]
    # add acceptable CA
    run $CLRTRUST add $CERTS/c1.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 1 ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
