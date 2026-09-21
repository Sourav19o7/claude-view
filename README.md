# claude-view

A live, documentation-style Markdown viewer for [Claude Code](https://claude.com/claude-code) responses.

Keep `claude-view` open in a second terminal. Every time you run `/copy` in Claude Code, the latest response is rendered there — headings, lists, tables, quotes and highlighted code blocks — with no raw `#` or `**` markers.

## Install

```bash
git clone https://github.com/Sourav19o7/claude-view.git
cd claude-view
./install.sh
```

The installer uses Homebrew to install `fzf` and `glow` if they are missing, then symlinks `claude-view` into `~/.local/bin` (override with `BIN_DIR=/usr/local/bin ./install.sh`).

## Usage

1. Run `claude-view` in a separate terminal (Warp, iTerm, a tmux pane…).
2. In Claude Code, run `/copy` — or use the copy button in the VS Code extension.
3. The response appears instantly, and updates on every subsequent `/copy`.

| Key   | Action                                    |
|-------|-------------------------------------------|
| Enter | Open the response in `$EDITOR` (default `nano`) |
| Esc   | Close the viewer                          |

Inside tmux, the viewer opens as a floating popup.

### Browser mode — real font sizes

Terminals render every line at one font size, so the terminal view distinguishes headings by colour and weight only. For true documentation typography (larger H1/H2/H3, proportional fonts, GitHub-style tables and code blocks), run:

```bash
claude-view --web
```

Each heading level gets its own typeface and size: H1 in Fraunces (serif), H2 in Space Grotesk, H3 in Inter, H4 in IBM Plex Sans, and H5/H6 as small uppercase IBM Plex Mono. Body text is Inter and code is JetBrains Mono. Change them in `viewer.html`.

This opens a live page in your browser that re-renders on every `/copy`, following your system's light/dark setting. It is served only on `127.0.0.1`, and the rendered Markdown is sanitised with DOMPurify. Press Ctrl-C in the terminal to stop it.

## How it works

- It watches two sources and shows whichever changed most recently:
  - `/tmp/claude-<uid>/response.md`, which the Claude Code CLI's `/copy` writes.
  - The clipboard (`pbpaste`, `xclip`, `wl-paste`), which covers the VS Code extension and any other copy button. Single-line clipboard content (a URL, a path) is ignored so stray copies don't replace the view.
- On a change, it tells `fzf` to redraw via its `--listen` HTTP port.
- The preview is rendered by `glow` using `docs-style.json`, a theme that drops heading markers and styles each level distinctly.

## Customising

Use a different glow theme:

```bash
CLAUDE_VIEW_STYLE=light claude-view
CLAUDE_VIEW_STYLE=/path/to/my-style.json claude-view
```

Edit `docs-style.json` to change colours — it is a standard [glamour](https://github.com/charmbracelet/glamour) style file.

## Requirements

- `fzf` 0.36+ (for `--listen`)
- `glow` (falls back to `bat` syntax highlighting if absent)
- `curl`
- `python3` (for `--web`)
