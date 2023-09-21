# Kopia

Kopia includes unix-domain-socket support ans socket-activetion support as of v0.14.0

When using socket-activation with Kopia, it is generally adviseable to enable both the socket and the service
in systemd.  This is to because on-demand enabling could prevent maintenance tasks from running on a regular
schedule.

The following instructions build a light-weight Alpine based kopia-server container, rather than the
default Ubuntu based container.

## Usage

* ./build_socket_activated_kopia
* cp kopia.service kopia.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable kopia.socket
* systemctl --user enable kopia.service
* systemctl --user start kopia.socket

