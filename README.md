# clrtrust: management tool for certificate trust store


The `clrtrust` tool provides a frontend for centralized trust store management.
It allows for adding (trusting) and removing (distrusting) certificate
authorities (CAs). It also provides maintenance commands for viewing and
re-generating the trust store.

See [`man clrtrust`](man/clrtrust.1.md) for usage information and examples.

## `clrtrust` in Clear Linux OS

Clear Linux\* OS uses `clrtrust` to implement a centralized TLS Trust Store for
all its software packages which use Transport Layer Security. The trust store
contains a set of trusted Root Certificate Authorities (CAs) which the
operating system should trust. 

Clear Linux\* provides a complete and comprehensible list of well-known CAs out
of the box. It is not necessary to take an action to be able to, for example,
connect to https://clearlinux.org or https://google.com using TLS-enabled
software, such as `curl` or `firefox`.

## License

clrtrust is provided under terms of the GPL, version 2.0. See
[`COPYING`](COPYING) for details.

Copyright &copy; 2020 Intel Corporation


## Reporting issues

Help us improve the quality! Report issues at:
https://github.com/clearlinux/clrtrust/issues

