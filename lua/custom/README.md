# Custom Configuration Directory

This directory contains your personal Neovim customizations that extend jmbuhr's nvim-config.

## Structure

```
lua/custom/
├── init.lua                       # Main loader for custom config
├── README.md                      # This file
├── config/                        # Custom configuration files
│   ├── options.lua               # Custom vim options
│   ├── keymaps.lua               # Custom keybindings
│   ├── vscode.lua                # VSCode-neovim specific settings
│   └── vscode-plugins.lua        # VSCode plugin loader
└── plugins/                       # Custom plugin configurations
    └── vim-visual-multi.lua      # Multiple cursors plugin
```

## Your Customizations

### Regular Neovim (`config/keymaps.lua`)
- **`jj`** in insert mode → escape to normal mode
- **`<leader>oi`** → open init.lua
- **`<leader>s`** → quick save
- **`<leader>%`** → save & source current file

### Options (`config/options.lua`)
- Windows SQLite path for database plugins
- Vim-visual-multi configuration for multiple cursors

### VSCode-Neovim (`config/vscode.lua`)
- Comprehensive VSCode command bindings
- File operations, search/replace, navigation
- Window management
- Quarto integration commands
- Line movement in visual mode (J/K)

### Plugins

#### vim-visual-multi
Multiple cursors support
- `<leader>a` - Select/Visual all
- `<leader>A` - Align
- `<C-Down>` / `<C-Up>` - Add cursors

#### mini.nvim
Suite of small independent plugins (loaded with high priority)
- **mini.ai**: Better text objects (e.g., `va)`, `ci'`)
- **mini.surround**: Add/delete/replace surroundings
  - `sa` - Add surround
  - `sd` - Delete surround
  - `sr` - Replace surround
- **mini.pairs**: Auto-close brackets/quotes
- **mini.comment**: Comment lines (`gcc`)

#### flash.nvim
Quick navigation with labeled jumps
- `s` (hold 2 sec) - Jump to line start (shows labels)
- `S` - Treesitter selection
- `f`/`F`/`t`/`T` - Enhanced with flash labels
- `;` / `,` - Next/previous match

**Note:** `s` key is shared between flash and mini.surround:
- Quick `sa`/`sd`/`sr` (within 2 sec) → mini.surround
- Press `s` and wait 2 seconds → flash line jumping
- This coexistence is achieved via `priority = 1000` on mini.nvim and `timeoutlen = 2000`

#### oil.nvim
File browser with your custom configuration
- `-` - Open oil
- `<leader>ef` - Edit files
- `sh` / `sv` - Split horizontal/vertical
- Shows hidden files, custom winbar

## Integration with jmbuhr's Config

This custom config is loaded **after** jmbuhr's base configuration, so your settings will override or extend his where they conflict.

## Updating From Upstream

To pull updates from jmbuhr/nvim-config:

```bash
cd ~/.config/nvim
git pull origin main
```

Your `lua/custom/` directory won't conflict with upstream changes since it's gitignored by default.

## Backup Location

Your previous config is backed up at: `~/.config/nvim-backup`
