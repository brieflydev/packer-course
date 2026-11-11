#!/bin/sh
set -eu

if command -v cloud-init >/dev/null 2>&1; then
  echo "==> Waiting for cloud-init to finish"
  cloud-init status --wait >/dev/null || true
fi

APT="apt-get -o DPkg::Lock::Timeout=300"

echo "==> Installing security updates"
$APT update
$APT -y upgrade

echo "==> Installing nginx"
$APT install -y --no-install-recommends nginx openssl

nginx -v