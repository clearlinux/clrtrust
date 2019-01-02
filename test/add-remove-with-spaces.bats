#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c1.pem "$CLR_CLEAR_TRUST_SRC/trusted/COMODO RSA Certification Authority.pem"
}

@test "add, remove files with spaces in names" {
    $CLRTRUST generate
    cnt=$(ls $STORE/anchors | wc -l)
    [ $cnt -eq 3 ] # file and symlink
    run $CLRTRUST list
    [ $status -eq 0 ]
    cnt=$(echo "$output"| grep ^id | wc -l)
    [ $cnt -eq 1 ]
    # add file with spaces
    $CLRTRUST add $CERTS/'Baltimore CyberTrust Root.crt'
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 2 ]
    $CLRTRUST add $CERTS/c2.pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 3 ]
    $CLRTRUST remove $CERTS/'Baltimore CyberTrust Root.crt' $CERTS/c2.pem
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 1 ]
    $CLRTRUST remove "$CLR_CLEAR_TRUST_SRC/trusted/COMODO RSA Certification Authority.pem"
    run $CLRTRUST list
    cnt=$(echo "$output" | grep ^id | wc -l)
    [ $cnt -eq 0 ]
}

teardown() {
    true
    #remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
