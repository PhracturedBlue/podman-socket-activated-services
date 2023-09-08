#!/bin/bash
set -e
ver=main
if [[ ! -f v${ver}.tar.gz ]]; then
  wget https://github.com/PhracturedBlue/socket-gen/archive/refs/heads/$ver.tar.gz
fi
rm -rf socket-gen-$ver
tar -xf ${ver}.tar.gz
cd socket-gen-$ver
podman build --tag reverse-proxy:sa -f example/nginx/Dockerfile .
cd ..
rm -rf socket-gen-$ver
rm ${ver}.tar.gz
