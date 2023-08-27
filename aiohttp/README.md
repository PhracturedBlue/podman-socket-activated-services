Many python applications provide aiohttp based web services.
Whie aiohttp does not have integrated socket-activation support, enabling
it can be very easy.  The included `run.py` shows how to detect and send
the relevant arguments to `aiohttp.web.run_app` to support socket-activation,
unix-domain-sockets, and tcp sockets.
