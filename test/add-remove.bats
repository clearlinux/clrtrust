#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
}

@test "generate empty store, add certificate" {
    $CLRTRUST generate
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 0 ]
    run $CLRTRUST list
    [ $status -eq 0 ]
    [ -z "$output" ]
    # add one CA
    $CLRTRUST add $CERTS/c1.pem
    [ $? -eq 0 ]
    run $CLRTRUST list
    cnt=$(echo "$output"| grep ^id | wc -l)
    [ $cnt -eq 1 ]
    # add another one
    $CLRTRUST add $CERTS/c2.pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 2 ]
    # add duplicate
    run $CLRTRUST add $CERTS/c1.pem
    [ $status -eq 255 ]
    # add two
    $CLRTRUST add $CERTS/c[3=4].pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 4 ]
    # remove one
    $CLRTRUST remove $CERTS/c3.pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 3 ]
    # remove two
    $CLRTRUST remove $CERTS/c1.pem $CERTS/c4.pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 1 ]
    # remove last
    $CLRTRUST remove $CERTS/c2.pem
    run $CLRTRUST list
    [ -z "$output" ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
