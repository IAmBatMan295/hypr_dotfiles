# Tmux Keybindings Reference

This document covers useful tmux keybindings. Your custom overrides are marked with ⚡.

## Prefix Key

| Keybinding | Action |
|------------|--------|
| `Ctrl + b` | Prefix key (all commands below require this first unless marked otherwise) |

---

## Sessions

| Keybinding | Action |
|------------|--------|
| `prefix + d` | Detach from session |
| `prefix + s` | List/switch sessions |
| `prefix + $` | Rename current session |
| `prefix + (` | Switch to previous session |
| `prefix + )` | Switch to next session |

---

## Windows

| Keybinding | Action |
|------------|--------|
| ⚡ `Ctrl + q` | Create new window (no prefix needed) |
| ⚡ `prefix + c` | Kill current window |
| ⚡ `prefix + n` | Next window |
| ⚡ `prefix + p` | Previous window |
| `prefix + 0-9` | Switch to window by number |
| `prefix + ,` | Rename current window |
| `prefix + w` | List all windows |
| `prefix + &` | Kill window (with confirmation) |
| `prefix + l` | Toggle to last active window |

---

## Panes

### Creating Panes

| Keybinding | Action |
|------------|--------|
| ⚡ `prefix + h` | Split horizontally (side by side) |
| ⚡ `prefix + v` | Split vertically (top/bottom) |

### Navigating Panes

| Keybinding | Action |
|------------|--------|
| ⚡ `Ctrl + h` | Move to left pane (no prefix needed) |
| ⚡ `Ctrl + j` | Move to pane below (no prefix needed) |
| ⚡ `Ctrl + k` | Move to pane above (no prefix needed) |
| ⚡ `Ctrl + l` | Move to right pane (no prefix needed) |
| `prefix + o` | Cycle through panes |
| `prefix + ;` | Toggle to last active pane |
| `prefix + q` | Show pane numbers (press number to jump) |

### Resizing Panes

| Keybinding | Action |
|------------|--------|
| `prefix + Ctrl + Arrow` | Resize pane in arrow direction (small) |
| `prefix + Alt + Arrow` | Resize pane in arrow direction (large) |
| `prefix + z` | Toggle pane zoom (fullscreen) |

### Managing Panes

| Keybinding | Action |
|------------|--------|
| `prefix + x` | Kill current pane |
| `prefix + !` | Convert pane to window |
| `prefix + {` | Swap with previous pane |
| `prefix + }` | Swap with next pane |
| `prefix + Space` | Cycle through pane layouts |

---

## Copy Mode (Scrolling & Selection)

| Keybinding | Action |
|------------|--------|
| `prefix + [` | Enter copy mode |
| `q` | Exit copy mode |
| `Space` | Start selection (in copy mode) |
| `Enter` | Copy selection (in copy mode) |
| `prefix + ]` | Paste buffer |
| Arrow keys / `hjkl` | Navigate in copy mode |
| `g` | Go to top |
| `G` | Go to bottom |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search match |
| `N` | Previous search match |

---

## Miscellaneous

| Keybinding | Action |
|------------|--------|
| `prefix + :` | Enter command mode |
| `prefix + ?` | List all keybindings |
| `prefix + t` | Show clock |
| `prefix + r` | Reload config (via tmux-sensible) |

---

## Quick Reference Summary

### Your Custom Bindings (⚡)

| Default | Your Override | Action |
|---------|---------------|--------|
| `prefix + c` | `Ctrl + q` (no prefix) | New window |
| `prefix + &` | `prefix + c` | Kill window |
| `prefix + %` | `prefix + h` | Split horizontal |
| `prefix + "` | `prefix + v` | Split vertical |
| `prefix + arrows` | `Ctrl + hjkl` (no prefix) | Pane navigation |

---

## Plugin Commands (TPM)

| Keybinding | Action |
|------------|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + Alt + u` | Uninstall plugins not in config |
