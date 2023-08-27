# vncserver

This is a socket-activated vnc server running in a rootless podman container.
It includes a barebones VNC server with just enough added to enable an xterm
and Firefox.  It is meant primarily as a template for how to enable a VNC
server in a container (which requires some tricks even-without socket-activation).

TigerVNC does support inetd-style socket activation, however it is not supported
directly from the wrapper, only through the Xvnc application.  This requires using
something like xinit or startx to start the desktop after the server is running.

Using xinit does work, however, it seems to take up to 10 seconds between X-server
startup and desktop start.

Instead, this container uses a lightly modified `sxinit` from https://github.com/sineemore/sxinit
which is extremely barebones but starts quickly. One drawback to this approach
is that when using sxinit, the container will not shutdown on a SIGTERM
(meaning that a `podman stop` will need to use SIGKILL to terminate the container).
This is probably easily fixable, but so far remains unfixed.

This example also uses the [inetd_sock](../inetd_sock/README.md) helper in order to convert
a systemd-style activated socket into an inetd activated one (because as documented above,
podman does not preserve sockets passed on stdin into containers)

The service is configured to use a named-volume `vnchome` for persistent storage, but
does not persist the $HOME/.cache directory.

The Containerfile can easily be modified for non socket-activated use, as setting up
a vncserver inside a container requires a few quirks.

# Usage

* gcc -o inetd_sock ../inetd_sock/inetd_sock.c
* gcc -o sxinit sxinit.c
* generate the `passwd` file in the current directory
  * This is most easily one running vncpasswd on the host machine and copying ~.vnc/passwd
    file
* podman build --tag vncserver:socket-activated
* cp vncserver.service vncserver.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable vncserver.socket
* systemctl --user start vncserver.socket
