#!bin/bash
set -e
if [[ "x$1" != "x" ]]; then
  ver=$1
else
  ver=$(curl -s https://raw.githubusercontent.com/grafana/grafana/main/CHANGELOG.md | head -n 1 | sed -e 's/^<.-- *//' -e 's/ *START *-->//')
fi
if [[ ! -f v${ver}.tar.gz ]]; then
  wget https://github.com/grafana/grafana/archive/refs/tags/v${ver}.tar.gz
fi
rm -rf grafana-$ver
tar -xf v${ver}.tar.gz
cd grafana-$ver
patch < ../25423.diff
podman build --tag dockerhub.lan/nas/grafana:sa-$ver .
cd ..
rm -rf grafana-$ver
rm tar -xf v${ver}.tar.gz
