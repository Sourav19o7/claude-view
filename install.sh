#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

for tool in fzf glow; do
    if ! command -v "$tool" > /dev/null; then
        if command -v brew > /dev/null; then
            brew install "$tool"
        else
            echo "Please install $tool, then re-run this script." >&2
            exit 1
        fi
    fi
done

chmod +x "$REPO_DIR/claude-view"
mkdir -p "$BIN_DIR"
ln -sf "$REPO_DIR/claude-view" "$BIN_DIR/claude-view"
echo "Installed: $BIN_DIR/claude-view -> $REPO_DIR/claude-view"

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo "Note: add $BIN_DIR to your PATH." ;;
esac
