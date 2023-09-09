# Kopia

Kopia includes unix-domain-socket support (not yet released), but not socket-activation support.
However, a patch for socket-activation support has been submitted [here](https://github.com/kopia/kopia/pull/3283)

When using socket-activation with Kopia, it is generally adviseable to enable both the socket and the service
in systemd.  This is to because on-demand enabling could prevent maintenance tasks from running on a regular
schedule.

With the patch socket-activation is automatically detected and used when available.

The following instructions build a light-weight Alpine based kopia-server container, rather than the
default Ubuntu based container.

## Usage

* Build socket-activated kopia:
  ./build_socket_activated_kopia.sh
* cp kopia.service kopia.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable kopia.socket
* systemctl --user enable kopia.service
* systemctl --user start kopia.socket

