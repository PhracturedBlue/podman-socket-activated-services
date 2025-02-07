# Libsdsock
`libsdsock` can be used to enable socket-activate unix-domain-sockets on arbitrary applications.
To use ensure libsdsock.so is available, and add the following environment variables:
```
LD_PRELOAD=</path/to/libsdsock>
LIBSDSOCK_MAP=tcp://[::]:<listen_port>=<socket_name>.socket
```

Note: the tcp query must match the listen query of the application, it may look like:
```
LIBSDSOCK_MAP=tcp://127.0.0.1:<port>=<socket_name>.socket
```

Assuming it is compiled against a compatible OS, libsdscock can be used without modifying the upstream image as follows:
```
podman run -v </path/to/libsdsock.so>:/usr/local/lib/libsdsock.so:ro \
  -e LD_PRELOAD=/usr/local/lib/libsdsock.so \
  -e LIBSDSOCK_MAP=tcp://[::]:8080=myservice.socket \
  application_image
```

# Compiling libsdsock
The show_listen.patch 
```
git clone https://github.com/PhracturedBlue/libsdsock.git
make libsdsock-debug.so libsdsock.so
```

To validate how an application calls listen, use:
```
LD_PRELOAD=</path/to/libsdsock-debug.so>
```
