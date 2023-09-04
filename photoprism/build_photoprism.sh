#!/bin/bash
set -e
repo=photoprism/photoprism
project=photoprism
patch=3696.patch
tag=socketactivated
branch=develop
https://github.com/photoprism/photoprism/archive/refs/heads/develop.zip

if [[ -z $branch ]]; then
  if [[ "x$1" != "x" ]]; then
    ver=$1
  else
    ver=$(curl -I -s https://github.com/$repo/releases/latest | grep '^location:' | sed -e 's|.*/||' -e 's/\r$//')
  fi
  root=https://github.com/$repo/archive/refs/tags
else
  root=https://github.com/$repo/archive/refs/heads
  ver=$branch
fi
if [[ ! -f ${ver}.tar.gz ]]; then
  echo "Downloading version: $ver"
  wget ${root}/${ver}.tar.gz
fi
rm -rf $project-$ver
tar -xf ${ver}.tar.gz
cd $project-$ver
patch -p1 < ../$patch
podman build --tag dockerhub.lan/nas/$project:$tag --tag dockerhub.lan/nas/$project:$ver-$tag .
cd ..
rm -rf $project-$ver
rm ${ver}.tar.gz
