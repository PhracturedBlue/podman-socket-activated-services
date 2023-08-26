# Docker Registry User Interface

The docker-register-ui container (https://github.com/Joxit/docker-registry-ui) supports
socket activation (via the nginx hack) out of the box, as well as working well with
registries exposed on unix-domain-sockets.

Because doker-registry-ui needs to be able to talk to the docker registry service,
it is necessary to expose the docker-registry via a unix-domain-socket instead of via
a TCP port if `--network=none` is used.

This example is configured in such a way.

## Note about specifying ports
The port specified in the docker-registry-ui.socket file should be specified as
`0.0.0.0:<port#>`.  If the `0.0.0.0` is not used, nginx will not listen on the port properly.
This also goes for using `systemd-socket-activate` for testing.  Use
`systemd-socket-activate -l 0.0.0.0:<port#> ...`.

This could probably be fixed by specifying the `NGINX_LISTEN_PORT` as `127.0.0.1:<port#>`, but
ths is untested.

## Using a unix-domain-socket for socket activation
If a unix-domain-socket is used for docker-registry-ui activation, the `NGINX_LISTEN_PORT`
value must be `unix:<host path to socket>` even if this path is not exposed in the container.

For example:
if this is in docker-registry-ui.socket
```
[Socket]
ListenStream=%t/nginx_sockets/registry.lan/registry.sock
SocketMode=0666
```
then use this in docker-registry-ui.service:
```
--env NGINX_LISTEN_PORT=unix:%t/nginx_sockets/registry.lan/registry.sock \
```

## Usage
* modify docker-registry-ui.service as needed
  * The example assumes the registry is running TLS and is exposed on a unix-domain-socket at
    $XDG_RUNTIME_DIR/sockets/registry.sock
* cp docker-registry-ui.service docker-registry-ui.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable docker-registry-ui.socket
* systemctl --user start docker-registry-ui.socket
