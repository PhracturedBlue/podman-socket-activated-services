# inetd_sock

A simple wrapper to convert a systemd-style socket-activation to an inetd style one.

This is needed because podman does not seem to be able to pass a socket via stdin

## Usage

gcc -o inetd_sock inetd_sock.c

Then run the application via:
inetd_sock application args ...

for example, add to Containerfile:
```
COPY inetd_sock /usr/local/bin/inetd_sock
CMD ["/usr/local/bin/inetd_sock", "application", "app-arg1", app-arg2", ...]
```
