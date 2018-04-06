#!/usr/bin/env bats
# Copyright 2017 Intel Corporation

load test_lib

setup() {
    find_clrtrust
    setup_fs
    # copy bad certificate
    cp $CERTS/bad/non-cert.txt $CLR_LOCAL_TRUST_SRC/trusted
    # copy good certificate
    cp $CERTS/c1.pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "helper returns error code 2 if bad certificate found" {
    find $CLR_LOCAL_TRUST_SRC/trusted -type f | {
        run $CLRTRUST_HELPER -f 
        echo $output
        # should return 2
        [ $status -eq 2 ]
    }
}

@test "generate returns error code 127 if bad certificate found" {
    run $CLRTRUST generate
    # should return 127
    echo "$output" | grep "is not a PEM-encoded X.509"
    [ $status -eq 127 ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
