#!/bin/bash
set -e
if [[ "x$1" != "x" ]]; then
  ver=$1
else
  ver=$(curl -I -s https://github.com/distribution/distribution/releases/latest | grep '^location:' | sed -e 's|.*/v||' -e 's/\r$//')
fi
echo "Downloading version: $ver"
if [[ ! -f v${ver}.tar.gz ]]; then
  wget https://github.com/distribution/distribution/archive/refs/tags/v${ver}.tar.gz
fi
rm -rf distribution-$ver
tar -xf v${ver}.tar.gz
cd distribution-$ver
patch -p1 < ../4020.patch
cp ../config.yml cmd/registry/config-dev.yml
podman build --tag registry:2-sa --tag registry:$ver-sa .
cd ..
rm -rf distribution-$ver
rm v${ver}.tar.gz
