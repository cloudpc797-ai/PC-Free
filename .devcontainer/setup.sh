#!/usr/bin/env bash
set -euo pipefail
cd /workspaces/PC-Free 2>/dev/null || cd "$(dirname "$0")/.."
mkdir -p windows
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI is not available in this Codespace. Check the Dev Container build log."
  exit 1
fi
if [ ! -f .env ]; then
  cat > .env <<'EOF'
WINDOWS_VERSION=10
WINDOWS_RAM=4G
WINDOWS_CPUS=2
WINDOWS_DISK=64G
EOF
  chmod 600 .env
fi
echo "PC-Free setup files are ready. Windows starts when the Codespace starts."
