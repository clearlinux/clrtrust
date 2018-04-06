# Copyright 2017 Intel Corporation

find_clrtrust() {
    if [ -x $BATS_TEST_DIRNAME/../clrtrust ]; then
        CLRTRUST=$(realpath $BATS_TEST_DIRNAME/../clrtrust)
    else
        return 1
    fi
    if [ -x $BATS_TEST_DIRNAME/../clrtrust-helper ]; then
        CLRTRUST_HELPER=$(realpath $BATS_TEST_DIRNAME/../clrtrust-helper)
    else
        return 1
    fi
}

setup_fs() {
    ROOT=$(mktemp -d)
    CERTS=$BATS_TEST_DIRNAME/certs
    mkdir -p $ROOT/etc/ca-certs/trusted
    mkdir -p $ROOT/etc/ca-certs/distrusted
    mkdir -p $ROOT/usr/share/ca-certs/trusted
    mkdir -p $ROOT/usr/share/ca-certs/distrusted
    mkdir -p $ROOT/var/cache/ca-certs
    CLR_TRUST_STORE=$ROOT/var/cache/ca-certs
    STORE=$CLR_TRUST_STORE
    CLR_LOCAL_TRUST_SRC=$ROOT/etc/ca-certs
    CLR_CLEAR_TRUST_SRC=$ROOT/usr/share/ca-certs
    export CLR_TRUST_STORE CLR_LOCAL_TRUST_SRC CLR_CLEAR_TRUST_SRC
}

remove_fs() {
    unset CLR_TRUST_STORE CLR_LOCAL_TRUST_SRC CLR_CLEAR_TRUST_SRC
    rm -rf $ROOT
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:ai
