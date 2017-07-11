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
    # add one CA
    run $CLRTRUST add $CERTS/c1.pem
    [ $? -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output"| grep ^id | wc -l`
    [ $cnt -eq 1 ]
    # add another one
    run $CLRTRUST add $CERTS/c2.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 2 ]
    # add duplicate
    run $CLRTRUST add $CERTS/c1.pem
    [ $status -eq 128 ]
    # add two
    run $CLRTRUST add $CERTS/c[3=4].pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 4 ]
    # remove one
    run $CLRTRUST remove $CERTS/c3.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 3 ]
    # remove two
    run $CLRTRUST remove $CERTS/c1.pem $CERTS/c4.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 1 ]
    # remove last
    run $CLRTRUST remove $CERTS/c2.pem
    [ $status -eq 0 ]
    run $CLRTRUST list
    cnt=`echo "$output" | grep ^id | wc -l`
    [ $cnt -eq 0 ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
