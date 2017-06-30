function find_clrtrust {
    if [ -x $BATS_TEST_DIRNAME/../clrtrust ]; then
        CLRTRUST=`realpath $BATS_TEST_DIRNAME/../clrtrust`
    else
        return 1
    fi
}

function setup_fs {
    SOURCES=`mktemp -d`
    STORE=`mktemp -d`
    CERTS=$BATS_TEST_DIRNAME/certs
    mkdir -p $SOURCES/etc/ca-certs/trusted
    mkdir -p $SOURCES/etc/ca-certs/distrusted
    mkdir -p $SOURCES/usr/share/ca-certs/trusted
    mkdir -p $SOURCES/usr/share/ca-certs/distrusted
    CLR_TRUST_STORE=$STORE
    CLR_LOCAL_TRUST_SRC=$SOURCES/etc/ca-certs
    CLR_CLEAR_TRUST_SRC=$SOURCES/usr/share/ca-certs
    export CLR_TRUST_STORE CLR_LOCAL_TRUST_SRC CLR_CLEAR_TRUST_SRC
}

function remove_fs {
    unset CLR_TRUST_STORE_DFLT
    unset CLR_LOCAL_TRUST_SRC
    unset CLR_CLEAR_TRUST_SRC
    rm -rf $SOURCES
    # rm -rf $STORE
}

# vim: ft=sh:sw=4:ts=4:et:tw=80:ai
