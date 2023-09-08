#!/bin/bash
set -e
repo=VictoriaMetrics/VictoriaMetrics
project=VictoriaMetrics
patch="4973.patch 4978.patch"
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
for _p in $patch; do patch -p1 < ../$_p; done
make package-victoria-metrics-pure DOCKER=podman DOCKER_RUN="podman run --userns=keep-id"
set -x
reltag=`podman image ls --format '{{.Repository}}:{{.Tag}}' | grep '^localhost/victoriametrics/victoria-metrics' | head -n 1`
podman tag $reltag victoria-metrics:$tag
podman tag $reltag victoria-metrics:$ver-$tag
podman image rm $reltag
cd ..
rm -rf $project-$ver
rm v${ver}.tar.gz
