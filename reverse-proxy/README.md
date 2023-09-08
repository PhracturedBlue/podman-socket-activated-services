# Socket activated reverse proxy

Nginx does not directly support socket-activation, but there is a 
[trick](https://freedesktop.org/wiki/Software/systemd/DaemonSocketActivation/)
that allows it to work well.

Erik Sjölund has created an example nginx configuration using socket-activation and podman
[here](https://github.com/eriksjolund/podman-nginx-socket-activation), but his example
does not specifically implement a reverse-proxy.

This example provides a capability similar to the [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)
container, but using socket existance to trigger config gerneration instead of using dockergen to do so.
The `socket-gen` utility is used to monitor for new unix-domain-sockets and to update the configuration
dynamically.

The concept is to have systemd create all socket-activated unix-domain sockets in a specific subdirectory
(manually generated unix-domain sockets can be placed there too).
A utility will then monitor these sockets for change (creation/deletion) and reconfigure nginx accordingly
without any need for querying the docker (podman) control socket.

Since a socket-activated socket will appear as soon as systemd starts the <application>.socket service,
nginx will be reconfigured on systemctl start/stop

When configuring nginx with socket activation, it is important that the systemd socket matches the nginx
configuration file.  That means taht if systemd activates a socket on port 11080, then the default.conf
file should also listen on port 11080.  If a unix-domain-socket is used for socket activation
(ex /foo/bar.sock), then the default.conf should also listen on 'unix:/foo/bar.sock' *even if it is not
imported into the container*.  By default systemd will use an ipv6 address, whereas nginx defaults to
ipv4.  Either the systemd ListenStream should be ipv4 (specify as `0.0.0.0:<port>`), or the nginx listen
address should be specified in ipv6 syntax.  The `socket-gen` utility will auto-detect the listen address
style and properly configure nginx.

This example uses `--network=none` meaning that all service forwarding is done exclusively using
unix-domain-sockets.  All socket-activated containers are configured with something like:
```
ListenStream=%t/niginx_sockets/<application>/<application.sock
SocketMode=0666
```
Where %t == $XDG_RUNTIME_DIR.  SocketMode is needed because not all applications run as root inside
their containers, and typically set unix-socket permissions as 0744.  There are various solutions (like
using `userns=keep-id` to launch the container, or using ACLs to grant additional permissions), however,
for simplicity I use `0666` permissions on the sockets, but restict access at the `nginx_sockets` 
sub-directory.

# Usage:
* ./build-reverse-proxy.sh
* cp reverse-proxy.service reverse-proxy.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable reverse-proxy.socket
* systemctl --user start reverse-proxy.socket

