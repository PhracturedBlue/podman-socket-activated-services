# photoprism (https://github.com/photoprism/photoprism)

As of this writing (2023-09-03) PhotoPrism includes a patch for
unix-domain-sockets in the development branch, but not yet in the release.

Using a unix-domain-socket can be enough to run with --network=none, however
it does not provide the delayed-start functionality, does not provide the ability
to control the socket permissions, and does not allow using --network=none
with an exposed port.

Note that to use the 'essential' or 'plus' levels, PhotoPrism must be able to
phone-home in order to validate its keys, so using --network=none is only
valid for the community-edition.

A socket-activation patch has been posted [here](https://github.com/photoprism/photoprism/pull/3696)
But it only applies on to of the latest development branch, so cannot be applied
on top of the most recent release.

The included example runs with `--network=none`.  In order to use a MariaDB database, MariaDB
has been started with socket-activation exposing a unix-domain-socket at 
`$XDG_RUNTIME_DIR/mariadb/mysqld.sock`, which is then mounted into the PhotoPrism container.

## Usage
* Build socket-activated PhotoPrism
  ./build_socket_activated_photoprism.sh
* Alter photoprism.service:
  * Update database settings
  * select password if needed
  * remove `PHOTOPRISM_INIT=` if TLS is desired
* cp photoprism.service photoprism.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable photoprism.socket
* systemctl --user start photoprism.socket
