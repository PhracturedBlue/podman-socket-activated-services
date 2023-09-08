# VictoriaMetrics

Currently, VictoriaMetrics does not support systemd socket-activation.

A pull-request has been generated to add this support here: https://github.com/VictoriaMetrics/VictoriaMetrics/pull/4973

In the meantime, this patch can be manually applied to the latest version and the container rebuilt.

Because victoria-metrics can listen on several interfaces, depending on configuration, The socket-activation
patch requires the use of named file-descriptors in the systemd.socket file.  the names used for each socket must match
the options used when calling VictoriaMetrics.

For instance If the cosket file contains:
```
ListenStream=8428
FileDescriptorName=vm_http_port
```
Then VictoriaMetrics should be called with `victoria-metrics -httpListenAddr vm_http_port`

# Usage
* Build socket-activated VictoriaMetrics:
 ./build_socket_activated_victoria_metrics.sh
* update victoria-metrics.socket and victoria-metrics.service to include desired services
* cp victoria-metrics.service victoria-metrics.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable victoria-metrics.socket
* systemctl --user start victoria-metrics.socket

