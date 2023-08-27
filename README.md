# podman-socket-activated-services

This repo provides templates for enabling various podman services with systemd socket-activation.
Socket-activation of containers is supported in podman as of version 3.4.0, and can provide more secure and
performant containers by enabling rootless containers with `--network=none` or without the need
for `slirp4netns` or `pasta` network translation.  Socket activation can also improve startup
time by deferring application start to 1st use, which can be helpful for more rarely used
applications.

Socket-activated services can directly expose a port on the host machine, or can use
unix-domain-sockets behind a reverse-proxy like Nginx.

While many common services support socket-activation out of the box, others require some
additional coaxing to enable.

## Notes about testing socket activation

Changing service/socket files, reloading them, and restarting services can be tedious when
developing or testing socket-activation capabilities.  But systemd provides the
`systemd-socket-activate` utility that can be used to test socket activation standalone.

To use, run something like: `systemd-socket-activate -l 5000 podman run ...`
Then, check the connection in a 2nd terminal via: `curl http://localhost:5000/...`

This can also be used for testing unix-domain-sockets:
Start via: `systemd-socket-activate -l $PWD/uds.sock podman run ...`
Test via: `curl --unix-socket $PWD/uds.sock http://localhost/...`

# Inetd vs systemd socket activation

Some applications may support inetd socket-activation but not systemd socket-activation.
inetd passes the activated socket via stdin, whereas systemd uses FDs 3+ and sets the
`LISTEN_FDS` and `LISTEN_PID` environment variables.  Systemd can generate inetd compliant
socket-activation, however in the context of podman, this doesn't seem helpful, as podman
seems to replace the generated stdin socket with a pipe when `podman run -i` is used.

To address this, the `indetd_sock` wrapper can be used to move fd=3 to fd=0 inside the
container before starting the applictaion, thus converting a systemd-style socket-activation
into an inetd style one.
