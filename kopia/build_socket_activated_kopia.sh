#!/bin/bash
repo=kopia/kopia
project=kopia
tag=socketactivated
#branch=master

set -e
if [[ -z $branch ]]; then
  if [[ "x$1" != "x" ]]; then
    ver=$1
  else
    ver=$(curl -I -s https://github.com/$repo/releases/latest | grep '^location:' | sed -e 's|.*/v||' -e 's/\r$//')
  fi
  vver=v$ver
  root=https://github.com/$repo/archive/refs/tags
else
  root=https://github.com/$repo/archive/refs/heads
  ver=$branch
  vver=$ver
fi
if [[ ! -f ${vver}.tar.gz ]]; then
  echo "Downloading version: $ver"
  wget ${root}/${vver}.tar.gz
fi
rm -rf $project-$ver
tar -xf ${vver}.tar.gz
cd $project-$ver
podman build --tag $project:$tag --tag $project:$ver-$tag -f ../Dockerfile .
cd ..
rm -rf $project-$ver
rm ${vver}.tar.gz
