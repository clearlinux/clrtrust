#!/usr/bin/env bats

load test_lib

setup() {
    find_clrtrust
    setup_fs
    cp $CERTS/c[1-4].pem $CLR_LOCAL_TRUST_SRC/trusted
}

@test "generate store, all local" {
    $CLRTRUST generate
    cnt=`ls $STORE/anchors | wc -l`
    [ $cnt -eq 8 ]
}

teardown() {
    remove_fs
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:si:noai:nocin
