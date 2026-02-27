#!/usr/bin/env bash
# Post home-manager setup for tools not managed by Nix.
# Run after `home-manager switch` on a fresh machine.

set -euo pipefail

echo "==> Installing GitButler CLI (but)..."
if command -v but &>/dev/null; then
  echo "    Already installed: $(but --version 2>/dev/null || echo 'unknown version')"
else
  curl -fsSL https://gitbutler.com/install.sh | sh
fi
