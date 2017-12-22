# clrtrust: the Clear Trust Store Management tool

Clear Linux\* for Intel® Architecture implements a centralized TLS Trust Store
for all its packages which use Transport Layer Security. The trust store
contains a set of trusted Root Certificate Authorities (CAs) which Clear Linux\*
should trust. `clrtrust` tool provides a front-end for the trust store
management: it allows viewing, adding (trusting), removing (distrusting) CAs. It
also provides some maitenance commands such as re-generating the trust store and
checking its consistency.

## License

clrtrust is provided under terms of the GPL, version 2.0. See
[`COPYING`](COPYING) for details.

Copyright &copy; 2017 Intel Corporation

## Using `clrtrust`

The following commands are available (run `clrtrust --help`):

```
Usage: clrtrust [-v|--verbose] [-h|--help] <command> [options]

    Commands
        generate    generates the trust store
        list        list CAs
        add         add trust to a CA
        remove      remove trust to a CA
        restore     restore trust to previously removed CA
        check       sanity/consistency check of the trust store

clrtrust <command> --help to get help on specific command.
```

root priviledges are required to execute commands that modify the store:
`generate`, `add`, `remove`, and `restore`.


### Viewing the list of trusted CAs

Clear Linux\* provides a complete and comprehensible list of well-known CAs out
of the box. It is not necessary to take an action to be able to, for example,
connect to https://clearlinux.org or https://google.com using TLS-enabled
software, such as `curl` or `firefox`.

The list of currently trusted certificates can be viewed using `clrtrust list`
command. The `list` command does not take any arguments and outputs a list of
certificates in a format similar to following:

```
id: FA:B7:EE:36:97:26:62:FB:2D:B0:2A:F6:BF:03:FD:E8:7C:4B:2F:9B
    File: /var/cache/ca-certs/anchors/certSIGN_ROOT_CA.crt
    Authority: /C=RO/O=certSIGN/OU=certSIGN ROOT CA
    Expires: Jul  4 17:20:04 2031 GMT
```

`id` uniquely identifies the certificate. It can be as input to some commands,
notably to `clrtrust remove`.

`File` line contains the filename of the certificate in the store. The
certificate can further be inspected using `openssl x509` command. For example,
the complete certificate details can be viewed using:

```
openssl x509 -in /var/cache/ca-certs/anchors/certSIGN_ROOT_CA.crt -noout -text
```

**NB** While it is not physically prohibited, it's highly discouraged to modify
the contents of the store, i.e. add/remove/modify files located in
`/var/cache/ca-certs`.

`Authority` and `Expires` provide the name of the organization which issued the
certificate and its expirty date. These fields are extracted from the
certificate files and provided in the list for convenience (as of the most
interest).

### Add (trust) a Root CA

Adding a Root CA means that the Root CA will be trusted, certificate chains
issued by the authority will be accepted as valid and if the application
validates the peer, a connection will be established.

`clrtrust add` takes one or more certificate files as the arguments. The
certificate file must be a PEM-encoded, one certificate per file. For example,
assuming the CA certificate is in the file `~/PrivateCA.pem`, the following
command will add it to the store:

```
clrtrust add ~/PrivateCA.pem
```

**NB** If the certificate file is in a different format, use `openssl x509`
command to convert to PEM, for example:

```
openssl x509 -in PrivateCA.cer -inform der -out PrivateCA.pem -outform pem
```

### Remove (distrust) a Root CA

Removing a Root CA means that the software will no longer trust the Certificate
Authority and will not be able to establish a connection to the hosts which use
certificates issued by the removed (distrusted) authority.

`clrtrust remove` takes `id` of the certificate as the argument or the file
containing the certificate.

For example, to distrust the certificate added in the previous example:

```
clrtrust remove ~/PrivateCA.pem
```


## Reporting issues

Help us improve the quality! Report issues at
https://github.com/clearlinux/clrtrust/issues

