# 🚀 LazyVim Beginner's Guide

Welcome to your new Neovim setup! This guide will help you master the installed tools in the recommended order of learning.

## ⌨️ General Shortcuts (Start Here)

**Leader Key:** `<Space>` (The most important key!)

| Action | Shortcut |
| :--- | :--- |
| **Save File** | `<C-s>` |
| **Quit/Close** | `<leader>qq` |
| **New File** | `<leader>fn` |
| **Close Buffer** | `<leader>bd` |
| **Previous/Next Buffer** | `<S-h>`, `<S-l>` or `[b`, `]b` |
| **Move Lines Up/Down** | `<A-j>`, `<A-k>` |
| **Toggle Terminal** | `<C-/>` or `<C-_>` |
| **Window Navigation** | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` |
| **Window Split** | `<leader>-` (horizontal), `<leader>\|` (vertical) |
| **Delete Without Yank** | `<leader>d` or `x` |
| **Change Without Yank** | `<leader>c` |
| **Undo** | `u` |
| **Redo** | `<C-r>` |

---

## 🏠 Dashboard & Projects

### Snacks Dashboard
*What it does:* Beautiful startup screen with quick access to files, projects, and commands.

**Access:** Opens automatically on startup or press `<Space>` then wait

| Key | Action |
| :--- | :--- |
| `f` | Find Files |
| `n` | New File |
| `g` | Find Text (Live Grep) |
| `r` | Recent Files |
| `c` | Open Config |
| `s` | Restore Session |
| `q` | Quit Neovim |

### 📂 Projects Management
*What it does:* The dashboard shows recent projects based on git roots from your recent files.

**How Projects Work:**
- Projects are auto-detected from git repositories you've opened
- The dashboard stores the last 5 projects by default
- Projects come from directories containing: `.git`, `package.json`, `Makefile`, etc.

**To Add Custom Projects:**
1. Navigate to any folder with a git repository: `:cd /path/to/your/project`
2. Open any file in that directory: `:e README.md`
3. The project will now appear in your dashboard on next startup

**Quick Access to Projects:**
- Press `<leader>fp` - Opens project picker
- Use `<C-e>` to open file explorer in project
- Use `<C-f>` to search files in project
- Use `<C-g>` to grep in project

**To Configure Custom Project Directories:**
Add to your `lua/config/options.lua`:
```lua
vim.g.snacks_projects_dev = { "~/dev", "~/projects", "~/work" }
```

---

## 🧩 Plugins & Learning Path

### 1. ❓ Which-Key (The Helper)
*What it does:* Shows a popup with available keybindings when you press a key like `<Space>`.

**Tips:** 
- Press `<Space>` and wait to see all leader commands
- Press `g`, `z`, `]`, `[` and wait to see motion commands
- Shows descriptions for every command!

### 2. 🔍 Snacks Picker (The Finder)
*What it does:* Powerful fuzzy finder for files, text, buffers, and more. Replaces Telescope.

| Action | Shortcut |
| :--- | :--- |
| **Find Files** | `<leader><space>` or `<leader>ff` |
| **Find Git Files** | `<leader>fg` |
| **Live Grep (Search Text)** | `<leader>/` or `<leader>sg` |
| **Find in Buffer** | `<leader>ss` |
| **Recent Files** | `<leader>fr` |
| **Buffers** | `<leader>fb` or `<leader>,` |
| **Command History** | `<leader>:` |
| **Search History** | `<leader>s:` |
| **Help Tags** | `<leader>sh` |
| **Projects** | `<leader>fp` |
| **Keymaps** | `<leader>sk` |
| **Notifications** | `<leader>sn` |
| **Grep Word Under Cursor** | `<leader>sw` |
| **Resume Last Picker** | `<leader>sR` |

**Inside Picker:**
- `<C-j/k>` or `<Down/Up>` - Navigate results
- `<CR>` - Select
- `<C-x>` - Open in horizontal split
- `<C-v>` - Open in vertical split
- `<Esc>` or `q` - Close picker
- `/` - Toggle focus between input/list
- `<C-/>` - Toggle help

### 3. 📁 File Explorer (Snacks Explorer / Neo-tree)
*What it does:* Shows your file structure in a sidebar.

| Action | Shortcut |
| :--- | :--- |
| **Toggle Explorer** | `<leader>e` or `<leader>E` |
| **Explorer (cwd)** | `<leader>fE` |

**Inside Explorer:**
- `l` or `<CR>` - Open file/folder
- `h` or `<BS>` - Go to parent directory
- `a` - Add file/folder (end with `/` for folder)
- `d` - Delete
- `r` - Rename
- `y` - Copy
- `x` - Cut
- `p` - Paste
- `c` - Copy file path
- `R` - Refresh
- `?` - Show help
- `q` - Close explorer
- `/` - Search/filter
- `.` - Toggle hidden files
- `g?` - Show all keymaps

### 4. 🧠 LSP & Mason (Code Intelligence)
*What it does:* Provides auto-completion, go-to-definition, and error checking.

| Action | Shortcut |
| :--- | :--- |
| **Go to Definition** | `gd` |
| **Go to References** | `gr` |
| **Go to Implementation** | `gI` |
| **Go to Type Definition** | `gy` |
| **Hover Documentation** | `K` |
| **Signature Help** | `<C-k>` (insert mode) |
| **Code Action** | `<leader>ca` |
| **Rename Symbol** | `<leader>cr` |
| **Format Document** | `<leader>cf` |
| **Organize Imports** | `<leader>co` |
| **LSP Info** | `<leader>cl` |
| **Mason (Install LSP/Tools)** | `<leader>cm` |
| **Show Line Diagnostics** | `<leader>cd` |
| **Next/Prev Diagnostic** | `]d`, `[d` |

### 5. 📝 Editing & Text Objects

| Action | Shortcut |
| :--- | :--- |
| **Comment Line** | `gcc` |
| **Comment Selection** | `gc` (visual mode) |
| **Comment Block** | `gbc` |
| **Surround Add** | `ysa)` (example: surround with `)`) |
| **Surround Delete** | `ds"` (delete surrounding `"`) |
| **Surround Change** | `cs"'` (change `"` to `'`) |
| **Select Inner/Around** | `vi{`, `va{`, `vip`, etc. |
| **Increment/Decrement Number** | `<C-a>`, `<C-x>` |
| **Toggle Word Case** | `~` |

### 6. 💻 Autocompletion (Blink.cmp)
*What it does:* Intelligent code completion while typing.

| Action | Shortcut |
| :--- | :--- |
| **Accept Suggestion** | `<CR>` or `<Tab>` |
| **Next Suggestion** | `<Tab>` or `<C-n>` |
| **Prev Suggestion** | `<S-Tab>` or `<C-p>` |
| **Scroll Docs Up/Down** | `<C-b>`, `<C-f>` |
| **Abort Completion** | `<C-e>` |

### 7. ⚡ Flash (Fast Navigation)
*What it does:* Jump anywhere on screen quickly.

| Action | Shortcut |
| :--- | :--- |
| **Flash Jump** | `s` (type 2 chars to jump) |
| **Flash Treesitter** | `S` |
| **Remote Flash** | `r` (in operator mode) |
| **Toggle Flash Search** | `/`, `?` in search |

### 8. 🔥 Git Integration (Gitsigns)
*What it does:* Shows git changes in the gutter and provides git operations.

| Action | Shortcut |
| :--- | :--- |
| **Next/Prev Hunk** | `]h`, `[h` |
| **Stage Hunk** | `<leader>hs` |
| **Reset Hunk** | `<leader>hr` |
| **Stage Buffer** | `<leader>hS` |
| **Undo Stage Hunk** | `<leader>hu` |
| **Preview Hunk** | `<leader>hp` |
| **Blame Line** | `<leader>hb` |
| **Diff This** | `<leader>hd` |
| **Toggle Deleted** | `<leader>htd` |
| **Git Status** | `<leader>gs` |
| **Git Commits** | `<leader>gc` |
| **Git Branches** | `<leader>gb` |

### 9. 🔧 Trouble (Diagnostics)
*What it does:* Better UI for diagnostics, references, and quickfix.

| Action | Shortcut |
| :--- | :--- |
| **Toggle Trouble** | `<leader>xx` |
| **Workspace Diagnostics** | `<leader>xX` |
| **Document Diagnostics** | `<leader>xd` |
| **Quickfix** | `<leader>xq` |
| **Location List** | `<leader>xl` |
| **Todo Comments** | `<leader>xt` |

### 10. 🔍 Search & Replace
*What it does:* Find and replace across files.

| Action | Shortcut |
| :--- | :--- |
| **Search & Replace** | `<leader>sr` |
| **Search Word** | `<leader>sw` (under cursor) |
| **Search Selection** | `<leader>sw` (visual mode) |

### 11. 📋 Buffers & Tabs

| Action | Shortcut |
| :--- | :--- |
| **Next/Prev Buffer** | `<S-l>`, `<S-h>` or `]b`, `[b` |
| **Close Buffer** | `<leader>bd` |
| **Close Other Buffers** | `<leader>bo` |
| **Buffer Picker** | `<leader>fb` or `<leader>,` |
| **New Tab** | `<leader><tab>l` |
| **Close Tab** | `<leader><tab>d` |
| **Next/Prev Tab** | `<leader><tab>]`, `<leader><tab>[` |

### 12. 🪟 Window Management

| Action | Shortcut |
| :--- | :--- |
| **Navigate Windows** | `<C-h/j/k/l>` |
| **Split Horizontal** | `<leader>-` or `<C-w>s` |
| **Split Vertical** | `<leader>\|` or `<C-w>v` |
| **Close Window** | `<C-w>q` or `<leader>wd` |
| **Resize Height** | `<C-Up>`, `<C-Down>` |
| **Resize Width** | `<C-Left>`, `<C-Right>` |
| **Maximize Toggle** | `<leader>wm` |

---

## 🔑 Essential Vim Motions

| Motion | Description |
| :--- | :--- |
| `h`, `j`, `k`, `l` | Left, Down, Up, Right |
| `w`, `b` | Next/prev word start |
| `e` | End of word |
| `0`, `$` | Start/end of line |
| `gg`, `G` | Start/end of file |
| `{`, `}` | Prev/next paragraph |
| `%` | Jump to matching bracket |
| `f{char}`, `F{char}` | Find char forward/backward |
| `t{char}`, `T{char}` | Till char forward/backward |
| `*`, `#` | Search word under cursor |
| `/{pattern}` | Search forward |
| `?{pattern}` | Search backward |

---

## 🛠️ Customization

**Add Plugins:** Create new files in `lua/plugins/`
```lua
return {
  "username/plugin-name",
  config = function()
    -- plugin configuration
  end,
}
```

**Configure Options:** Edit `lua/config/options.lua`
**Custom Keymaps:** Edit `lua/config/keymaps.lua`
**Auto Commands:** Edit `lua/config/autocmds.lua`

**Configure Projects:**
Add to `lua/config/options.lua`:
```lua
-- Custom project directories
vim.g.snacks_projects_dev = { "~/dev", "~/workspace", "~/projects" }

-- Custom project patterns
vim.g.snacks_projects_patterns = {
  ".git", "package.json", "Makefile", "Cargo.toml", "go.mod"
}
```

---

## 💡 Pro Tips

1. **Learning New Commands:** Press `<Space>` and explore! Which-Key will guide you.
2. **Quick File Navigation:** Use `<leader><space>` (fuzzy find) instead of manual navigation.
3. **Projects:** Your most-used git repos automatically show up on the dashboard!
4. **Don't Yank on Delete:** Use `<leader>d` or `x` to delete without affecting clipboard.
5. **Jump Anywhere:** Use `s` + 2 chars to jump instantly anywhere on screen.
6. **Git at Your Fingertips:** Press `<leader>g` to see all git commands.
7. **Universal Search:** `<leader>/` to search any text across all project files.
8. **Sessions:** Your session auto-saves! Use `<leader>qs` to restore it.

Happy Coding! 🚀
