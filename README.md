# podman-socket-activated-services

This repo provides templates for enabling various podman services with systemd socket-activation.
Socket-activation is supported in podman as of version 2.4, and can provide more secure and
performant containers by enabling rootless containers with `--network=none` or without the need
for `slirp4netns` or `pasta` network translation.  Socket activation can also improve startup
time by deferring application start to 1st use, which can be helpful for more rarely used
applications.

Socket-activated services can directly expose a port on the host machine, or can use
unix-domain-sockets behind a reverse-proxy like Nginx.

While many common services support socket-activation out of the box, others require some
additional coaxing to enable.
