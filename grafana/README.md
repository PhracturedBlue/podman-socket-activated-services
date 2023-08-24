# Socket Activated grafana container

Grafana does support unix-domain-sockets, but does not support socket-activation.
A patch was posted to support this (https://github.com/grafana/grafana/pull/25423)
whoever developers felt that the interest didn't warrnt the additional suppot load.
There is an open ticket to track interest here: https://github.com/grafana/grafana/issues/25885

The patch in question is trivial, but does need changes to support the current garfana (10.0 as of the writing of this README).
The included script will rebuild grafana from source using the updated patch

# Usage
* Build socket-activated grafana:
  ./build_socket_activated_grafana.sh
* cp grafana.service grafana.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable calibre-web.socket
* systemctl --user start calibre-web.socket
