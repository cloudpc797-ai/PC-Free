#!/usr/bin/env bash
set -euo pipefail
cd /workspaces/PC-Free 2>/dev/null || cd "$(dirname "$0")/.."

echo "Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker CLI is unavailable. Check the Codespace build logs."
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not ready yet; waiting up to 60 seconds..."
  for _ in $(seq 1 30); do
    sleep 2
    docker info >/dev/null 2>&1 && break
  done
fi
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker daemon did not start. Windows cannot launch in this Codespace."
  exit 1
fi

if [ -e /dev/kvm ]; then
  echo "KVM device found: Windows may use hardware acceleration."
else
  echo "WARNING: /dev/kvm is not available. Windows may be extremely slow or fail to boot in Codespaces."
fi

mkdir -p windows
docker compose --env-file .env -f compose.yml up -d
echo
echo "PC-Free Windows container launch requested."
echo "Wait several minutes for the first Windows installation."
echo "Open the forwarded port 8006 using its PRIVATE Codespaces address."
echo "If the desktop does not appear, inspect logs with: docker logs --tail 150 pc-free-windows"
