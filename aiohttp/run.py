"""A trivial aiohttp server supporting socket-activation"""
# Use 'pip install aiohttp' to get dependencies
import os
import sys
import socket
from aiohttp import web

SD_LISTEN_FDS_START = 3

async def handler(request):
    return web.Response(text="Hello World")


def main():
    address = sys.argv[1] if len(sys.argv) > 1 else None
    args = {}
    if 'LISTEN_FDS' in os.environ and 'LISTEN_PID' in os.environ:
        try:
            assert int(os.environ['LISTEN_PID']) == os.getpid()
            count = int(os.environ['LISTEN_FDS'])
            socks = [socket.socket(fileno=_+SD_LISTEN_FDS_START) for _ in range(count)]
            for sock in socks:
                print(f"Found socket-activated socket: {sock.getsockname()}")
            args['sock'] = socks
        except Exception as _e:
            print(f"ERROR: Failed to use activated socket: {repr(_e)}")
            sys.exit(1)
    elif address:
        try:
            host, port = address.split(':', 1)
            port = int(port)
            assert '/' not in host
            args['host'] = host
            args['port'] = port
        except:
            args['path'] = address

    app = web.Application()
    app.add_routes([web.get('/', handler)])
    web.run_app(app, **args)

if __name__ == "__main__":
    main()
