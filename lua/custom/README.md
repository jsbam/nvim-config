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
    ├── flash.lua                  # Quick navigation
    ├── lualine.lua               # Custom statusline
    ├── mini-nvim.lua             # Mini suite plugins
    ├── obsidian.lua              # OneDrive workspace override
    ├── oil-nvim.lua              # File browser customizations
    └── vim-visual-multi.lua      # Multiple cursors
```

## Your Customizations

### Regular Neovim (`config/keymaps.lua`)
- **`jj`** in insert mode → escape to normal mode
- **`<leader>oi`** → open init.lua
- **`<leader>s`** → quick save
- **`<leader>%`** → save & source current file

### Options (`config/options.lua`)
- Platform-specific SQLite path for database plugins (Windows only)
- Vim-visual-multi configuration for multiple cursors
- Extended timeout for flash + mini.surround coexistence

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

#### lualine.nvim
Custom statusline replacing snacks.nvim default
- Auto theme matching your colorscheme
- Shows: mode, branch, diff, diagnostics, filename, encoding, filetype, progress, location
- Global statusline across all windows
- Extensions for oil, quickfix, and fugitive

#### oil.nvim
File browser with your custom configuration
- `-` - Open oil
- `<leader>ef` - Edit files
- `sh` / `sv` - Split horizontal/vertical
- Shows hidden files, custom winbar

#### obsidian.nvim
Custom workspace override pointing to OneDrive location
- **Auto-detects platform:** Automatically uses correct path for Mac or Windows
- **Mac path**: `~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian`
- **Windows path**: `~/OneDrive - Örebro universitet/SCTO-Obsidian`
- **No manual configuration needed** when switching between platforms

## Integration with jmbuhr's Config

This custom config is loaded **after** jmbuhr's base configuration, so your settings will override or extend his where they conflict.

### Git Repository Setup

- **Origin**: `jsbam/nvim-config` (your fork)
- **Upstream**: `jmbuhr/nvim-config` (original repo)

## Updating From Upstream

To pull updates from jmbuhr/nvim-config:

```bash
cd ~/.config/nvim
git fetch upstream
git merge upstream/main
```

Your `lua/custom/` directory won't conflict with upstream changes. Only two files need manual re-application after upstream merges:
1. `init.lua` - Add `require 'custom'` at the end
2. `lua/config/lazy.lua` - Change `require('lazy').setup('plugins', {` to import custom.plugins

## Platform-Specific Considerations

### Mac (Current Setup)
- OneDrive path: `~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian`
- No SQLite path configuration needed (handled natively)
- All Unix/Linux LSP servers work without issues

### Windows (via jsbam/nvim-config)
- OneDrive path: `~/OneDrive - Örebro universitet/SCTO-Obsidian`
- SQLite path: `C:\ProgramData\chocolatey\lib\sqlite\tools\sqlite3.dll`
- Some plugins (presenterm.nvim) may need to be disabled

## Syncing Between Mac and Windows

**Fully automatic cross-platform support!** Both setups use the same `lua/custom/` structure:

- Custom configs are in `lua/custom/config/`
- Custom plugins are in `lua/custom/plugins/`
- **Platform detection is automatic:**
  - SQLite path: Only set on Windows (conditional in `config/options.lua`)
  - OneDrive path: Auto-detected in `plugins/obsidian.lua`
- **No manual changes needed** when switching between Mac and Windows

### How It Works

1. **SQLite** (`config/options.lua` lines 6-10):
   ```lua
   if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
     vim.g.sqlite_clib_path = 'C:\\...\\sqlite3.dll'
   end
   ```

2. **OneDrive** (`plugins/obsidian.lua` lines 5-10):
   ```lua
   local onedrive_path
   if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
     onedrive_path = '~/OneDrive - Örebro universitet/SCTO-Obsidian'
   else
     onedrive_path = '~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian'
   end
   ```

3. **Pull and go**: Simply `git pull origin main` on either platform and it works!

For detailed platform differences, see: `PLATFORM_DIFFERENCES.md` in the root directory.
