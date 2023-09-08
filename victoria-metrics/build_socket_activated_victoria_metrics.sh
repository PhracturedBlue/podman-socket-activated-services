#!/bin/bash
set -e
repo=VictoriaMetrics/VictoriaMetrics
project=VictoriaMetrics
patch=4973.patch
tag=socket

if [[ "x$1" != "x" ]]; then
  ver=$1
else
  ver=$(curl -I -s https://github.com/$repo/releases/latest | grep '^location:' | sed -e 's|.*/v||' -e 's/\r$//')
fi
echo "Downloading version: $ver"
if [[ ! -f v${ver}.tar.gz ]]; then
  wget https://github.com/$repo/archive/refs/tags/v${ver}.tar.gz
fi
rm -rf $project-$ver
tar -xf v${ver}.tar.gz
cd $project-$ver
patch -p1 < ../$patch
podman build --tag dockerhub.lan/nas/$project:$tag --tag dockerhub.lan/nas/$project:$ver-$tag .
cd ..
rm -rf $project-$ver
rm v${ver}.tar.gz
