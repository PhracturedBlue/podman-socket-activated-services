# calibre-web (https://github.com/janeczku/calibre-web)

Calibre-web supports communication via unix-sockets by using the
`CALIBRE_UNIX_SOCKET` environment variable.  However as of 2023-08-24,
it does not support socket-activation.

A patch to enable socket-activation was posted here: https://github.com/janeczku/calibre-web/pull/2871

Until enabled, the include Containerfile will apply the patch to the
current release.  This is not robust, and may break for future updates,
but the patch is simple, and should be easily fixed as needed.

The Containerfile also pulls in all of `calibre` in order to support
ebook conversion.  the ebook converted relies on Qt6 despite being a CLI
application, and so requires a full set of GUI libraries to be installed.

The included service file assumes the e-book library is stored in a named
volume: `ebooks` and that the calibre-web configuration is stored in a
named volume `calibreweb`.  Adjust as needed.

## Instructions

* podman build --tag calibreweb:socket-activated
* cp calibre-web.service calibre-web.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable calibre-web.socket
* systemctl --user start calibre-web.socket
