# Socket activated reverse proxy

Nginx does not directly support socket-activation, but there is a 
[trick](https://freedesktop.org/wiki/Software/systemd/DaemonSocketActivation/)
that allows it to work well.

Erik Sjölund has created an example nginx configuration using socket-activation and podman
[here](https://github.com/eriksjolund/podman-nginx-socket-activation), but his example
does not specifically implement a reverse-proxy.

This example provides a capability similar to the [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)
container, but using socket existance to trigger config gerneration instead of using dockergen to do so.

The concept is to have systemd create all socket-activated unix-domain sockets in a specific subdirectory
(manually generated unix-domain sockets can be placed there too).
A utility will then monitor these sockets for change (creation/deletion) and reconfigure nginx accordingly
without any need for querying the docker (podman) control socket.

Since a socket-activated socket will appear as soon as systemd starts the <application>.socket service,
nginx will be reconfigured on systemctl start/stop

When configuring nginx with socket activation, it is important that the systemd socket matches the nginx
configuration file.  That means taht if systemd activates a socket on port 11080, then the default.conf
file should also listen on port 11080.  If a unix-domain-socket is used for socket activation
(ex /foo/bar.sock), then teh default.conf should also listen on 'unix:/foo/bar.sock' *even if it is not
imported into the container*.  Also, nginx matches the host as well, so nginx will not properly match a
port if only '11080' is specified in the systemd socket file.  Instead specify `ListenStream=0.0.0.0:11080`
or else nginx will not listen properly.  These are likely artifacts of using the `NGINX=3` hack.

This example uses `--network=none` meaning that all service forwarding is done exclusively using
unix-domain-sockets.  All containers are configured with something like:
```
ListenStream=%t/niginx_sockets/<application>/<application.sock
SocketMode=0666
```
Where %t == $XDG_RUNTIME_DIR.  SocketMode is needed because not all applications run as root inside
their containers.  There are various solutions (like using `userns=keep-id` to launch the container),
however, for simplicity I use `0666` permissions on the sockets, but restict access at the `nginx_sockets`
sub-directory.

# Usage:
* configure nginx
  * At the moment, the auto-updating template engine is not ready, so configuration is manual.
  * copy the default.conf.tmpl file to /srv/reverse-proxy/default.conf
  * Add sections for each container to forward to.  The example assumes a DNS server on the network
    creating <application.lan> addresses for each service all forwarded to the server running reverse-proxy
  * Change the listening port as needed (make sure to change it in all sections)
  * After changing a service, run `systemctl --user stop reverse-proxy.service` to trigger a reread
* cp reverse-proxy.service reverse-proxy.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable reverse-proxy.socket
* systemctl --user start reverse-proxy.socket

