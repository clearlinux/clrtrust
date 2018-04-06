/*
 * Copyright © 2018 Intel Corporation.
 *
 * See COPYING for terms.
 */

/* This is a helper application which is meant to be used with clrtrust, the
 * Clear Linux Trust Store management tool. It is created for performance
 * reasons, to process certificates in bulk as opposed to running openssl for
 * each certificate file.
 *
 * It reads the list of files, one filename per line, from the standard input
 * and produces output in form of: <filename>\t<fingerprint or hash>.
 *
 * Two modes are supported. If '-f' switch is specified on the command line, for
 * each file a SHA-1 fingerprint is calculated. If '-s' is specified, then
 * subject hash is produced.
 */

#include <openssl/bio.h>
#include <openssl/pem.h>
#include <openssl/x509.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

/* process return codes */
#define CTH_EOK     0 /* success. */
#define CTH_EERR    1 /* incorrect invocation, cannot start. */
#define CTH_EINV    2 /* invalid input, cannot produce result. */

typedef enum {
    MODE_FINGER = 1,    /* output fingerprint */
    MODE_HASH,          /* output subject hash */
    MODE_INVALID = 100
} runmode_t;

void print_help() {
    char *help = "clrtrust-helper [-f|-s]\n"
                 "Helper utility for clrtrust. Reads the list of files from"
                 " stdin, one per line, and produces either fingerprint or"
                 " subject hash for each file on stdout in form:\n"
                 "    <filename><TAB><fingerprint or subject hash>\n";
    puts(help);
}

int main(int argc, char **argv) {

    runmode_t runmode = MODE_INVALID; /* global switch: whether to produce fingerprint
                                       or subject hash. */

    BIO *inbio = NULL;

    /* fingerprint-related variables */
    const EVP_MD *finger_type = NULL;
    unsigned int finger_sz;
    unsigned char finger[EVP_MAX_MD_SIZE];

    /* subjecthash-related variables */
    unsigned long subject_hash;

    unsigned int i;
    char c;

    char *fname = NULL;
    size_t sz = 0;

    /* return code */
    int ret = CTH_EOK;

    while ((c = getopt(argc, argv, "fs")) != -1) {
        switch (c) {
            case 'f':
                if (runmode == MODE_INVALID) {
                    runmode = MODE_FINGER;
                } else {
                    print_help();
                    return CTH_EERR;
                }
                break;
            case 's':
                if (runmode == MODE_INVALID) {
                    runmode = MODE_HASH;
                } else {
                    print_help();
                    return CTH_EERR;
                }
                break;
            default:
                printf("Unrecognized option -%c.\n", c);
                print_help();
                return CTH_EERR;
        }
    }

    if (runmode == MODE_INVALID) {
        print_help();
        return CTH_EERR;
    }

    OpenSSL_add_all_algorithms();

    finger_type = EVP_sha1();

    inbio = BIO_new(BIO_s_file());

    while (getline(&fname, &sz, stdin) != -1) {
        int fname_len = strlen(fname);
        int err = 1;
        FILE *fp = NULL;
        X509 *cert = NULL;

        if (fname_len < 1) continue;
        if (fname[fname_len-1] == '\n') {
            fname[fname_len-1] = '\0';
        }

        if (!(fp = fopen(fname, "r"))) {
            goto wrap_up;
        }

        if (!BIO_set_fp(inbio, fp, BIO_NOCLOSE)) {
            goto wrap_up;
        }

        if (!(cert = PEM_read_bio_X509(inbio, NULL, 0, NULL))) {
            goto wrap_up;
        }

        switch (runmode) {
            case MODE_FINGER:
                if (!X509_digest(cert, finger_type, finger, &finger_sz)) {
                    goto wrap_up;
                }
                printf("%s\t", fname);
                for (i=0; i < finger_sz; i++) {
                    printf("%02X", finger[i]);
                    if (i < finger_sz-1) printf(":");
                }
                putc('\n', stdout);
                err = 0;
                break;
            case MODE_HASH:
                subject_hash = X509_subject_name_hash(cert);
                printf("%s\t%08lx\n", fname, subject_hash);
                err = 0;
                break;
            default:
                return CTH_EERR;
        }

wrap_up:
        if (fp) fclose(fp);
        if (cert) X509_free(cert);
        if (err) {
            printf("%s\tERROR\n", fname);
            ret = CTH_EINV;
        }
    }

    if (fname) free(fname);

    return ret;
}
