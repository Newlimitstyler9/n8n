#!/usr/bin/env bash
# Replaces the community node's default browser.js with our stealth loader

set -e

TARGET="$(npm root -g)/n8n-nodes-youtube-audio/dist/helpers/browser.js"

echo "Patching $TARGET to load stealth-loader.js …"
echo "module.exports = require('/data/patch/stealth-loader');" > "$TARGET"

echo "✅  browser.js patched"
