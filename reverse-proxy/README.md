# Socket activated reverse proxy

Nginx does not directly support socket-activation, but there is a trick that allows it to work well (https://freedesktop.org/wiki/Software/systemd/DaemonSocketActivation/)

Erik Sjölund has created an example reverse-proxy configuration using socket-activation and podman here: https://github.com/eriksjolund/podman-nginx-socket-activation

This container provides a capability similar to the 'nginx-proxy' conmtainer (https://github.com/nginx-proxy/nginx-proxy) but using socket existance to trigger config gerneration
instead of using dockergen to do so.

The concept is to have systemd create all socket-activated unix-domain sockets in a specific subdirectory (manually generated unix-domain sockets can be placed there too).
A utility will then monitor these sockets for change (creation/deletion) and reconfigure nginx accordingly without any need for querying the docker (podman) control socket.

Since a socket-activated socket will appear as soon as systemd starts the <application>.socket service, nginx will be reconfigured on systemctl start/stop

# Usage: WIP
