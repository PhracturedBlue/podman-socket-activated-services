There are several full-featured git-servers (Gogs is a great example), but for a simple,
bare-bones server, there is git-http-backend.

However git-http-backend is a CGI based utility, and needs some help to run with an nginx reverse-proxy.

One solution is to add an http-server + the CGI script into a container (lighttpd + git-http-backend
or nginx + fcgiwrap + git-http-backend).  This is probably a good solution if the traffic is expected
to be high, but seemed like over-kill for a lightly used personal server.

Another choice is to setup fcgiwrap in a podman conatiner alongside git-http-backend, but my attempts
to do so were unsuccessful.

I settled for a lightweight speacial-purpose http server from movsb (https://github.com/movsb/sgits).
I implemented socket-activation in this patch: https://github.com/movsb/sgits/pull/1

Until that is merged, The example Dckerfile builds from a forked copy of movsb's code.

# Usage
* modify sgits.yml with username and password if desired
* podman build --tag gitserver:socket-activated .
* alter the repo path in gitserver.sevice
* cp gitserver.service gitserver.socket ~/.config/systemd/user/
* systemctl --user daemon-reload
* systemctl --user enable gitserver.socket
* systemctl --user start gitserver.socket

