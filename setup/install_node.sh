#!/usr/bin/env bash
set -euo pipefail

# install_node.sh
# Usage:
#   ./install_node.sh /path/to/project              # install Node+pnpm only
#   ./install_node.sh /path/to/project --reinstall  # also clean-reinstall deps

PROJECT_DIR="${1:-}"
DO_REINSTALL="${2:-}"

if [[ -z "$PROJECT_DIR" ]]; then
  echo "Please provide the project directory."
  echo "   Example: ./install_node.sh \$HOME/dev/kioskbot_frontend"
  exit 1
fi

# 1) Install NVS via Homebrew (idempotent)
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install from https://brew.sh and re-run."
  exit 2
fi
brew list nvs >/dev/null 2>&1 || brew install nvs

# 2) Initialize NVS in the current shell
export NVS_HOME="$HOME/.nvs"
# shellcheck disable=SC1091
. "$NVS_HOME/nvs.sh"

# 3) Install and use Node.js v22.19.0 (arch auto-matches your Mac: arm64/x64)
nvs add 22.19.0
nvs use 22.19.0
nvs link 22.19.0   # make it default

# 4) Enable pnpm via corepack (pinned)
corepack enable
corepack prepare pnpm@10.16.1 --activate

echo "Node.js $(node -v) and pnpm $(pnpm -v) are ready."

# 5) Optional: clean reinstall in the project
if [[ "${DO_REINSTALL:-}" == "--reinstall" ]]; then
  echo "Reinstalling dependencies in: $PROJECT_DIR"
  cd "$PROJECT_DIR"

  rm -rf node_modules || true
  rm -f pnpm-lock.yaml || true
  pnpm store prune || true

  pnpm install --force
  echo "Dependencies reinstalled."
else
  echo "Skipping dependency reinstall. Pass --reinstall to run it."
fi
