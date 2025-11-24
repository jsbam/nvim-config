# Custom Configuration

This directory contains all personal customizations for this nvim-config fork, isolated from the upstream base configuration. This structure makes it easy to sync updates from the parent repository without merge conflicts.

## Directory Structure

```
lua/custom/
├── README.md                   # This file
├── init.lua                    # Entry point, loads all custom modules
├── windows.lua                 # Windows-specific settings (SQLite path, etc.)
├── vscode.lua                  # VSCode-Neovim specific configuration
├── overrides/
│   ├── global.lua             # Custom global settings overrides
│   ├── keymap.lua             # Additional/custom keymaps
│   └── plugin-overrides.lua   # Configuration overrides for upstream plugins
└── plugins/
    ├── init.lua               # Custom plugins entry point
    ├── bufferline.lua         # Bufferline plugin
    ├── flash.lua              # Flash navigation plugin
    ├── vim-visual-multi.lua   # Multiple cursors plugin
    ├── rainbow-delimiters.lua # Rainbow delimiters plugin
    └── mini.lua               # Mini.nvim suite

```

## How It Works

1. **Main init.lua** loads `require 'custom'` early in the boot process
2. **custom/init.lua** handles:
   - Loading Windows-specific settings
   - Detecting VSCode and loading VSCode-specific config
   - Loading custom overrides for regular Neovim
3. **custom/plugins/** contains all custom plugins that aren't in upstream
4. **lua/config/lazy.lua** imports both `plugins/` and `custom/plugins/`

## Adding New Customizations

### Adding a New Plugin
Create a new file in `lua/custom/plugins/your-plugin.lua`:
```lua
return {
  'author/plugin-name',
  config = function()
    -- your config
  end,
}
```
Then add it to `lua/custom/plugins/init.lua`.

### Adding Custom Settings
Add your settings to the appropriate override file:
- **Global settings**: `lua/custom/overrides/global.lua`
- **Keymaps**: `lua/custom/overrides/keymap.lua`
- **Plugin configs**: `lua/custom/overrides/plugin-overrides.lua`

### Platform-Specific Settings
- **Windows**: Add to `lua/custom/windows.lua`
- **VSCode**: Add to `lua/custom/vscode.lua`

## Updating from Upstream

To pull updates from the parent repository (jmbuhr/nvim-config):

```bash
git fetch upstream
git merge upstream/main
```

Since your customizations are isolated in `lua/custom/`, upstream changes should merge cleanly without conflicts.

## VSCode Integration

When running in VSCode-Neovim, only the following plugins are loaded:
- mini.nvim suite
- vim-visual-multi
- flash.nvim

All VSCode-specific keymaps and commands are defined in `lua/custom/vscode.lua`.

## Known Issues

### r-languageserver - Mason PowerShell Installation Failure on Windows

**Status**: Resolved - removed from Mason's `ensure_installed` list

**Issue**: Mason fails to install r-languageserver with PowerShell error:
```
InvalidOperation: Cannot set property. Property setting is supported only on core types in this language mode.
```

**Root Cause**: Mason's installation script for r-languageserver uses PowerShell commands that are incompatible with certain PowerShell configurations on Windows.

**Solution**: Since the R `languageserver` package was already installed system-wide via R (v0.3.16), the solution was to:
1. Remove `'r_language_server'` from Mason's `ensure_installed` list in `lua/plugins/lsp.lua` (line 29)
2. Keep `vim.lsp.enable 'r_language_server'` (line 232) which uses the system-wide installation

**Result**: nvim-lspconfig automatically detects and uses the R languageserver package installed through R's package manager, bypassing Mason entirely. The LSP works correctly for `.r`, `.rmd`, and `.rmarkdown` files.

### presenterm.nvim - LuaRocks Path Handling on Windows

**Status**: Plugin disabled in `lua/plugins/presenterm.lua`

**Issue**: When using LuaRocks on Windows with Cygwin-style paths (Git Bash), the plugin fails to install with:
```
Error: command 'install' requires exclusive write access to C:
\Users\jsh001\AppData\Local\nvim-data\lazy\presenterm.nvim\C:
\Users\jsh001\AppData\Local\nvim-data\lazy-rocks\presenterm.nvim - Unknown error
```

**Root Cause**: Path concatenation issue where the drive letter appears twice (`C:\...\C:\...`). This occurs because:
- LuaRocks 3.11.1 (newer version) has incompatible path handling for Windows/Cygwin environments
- LuaRocks 2.4.4 (Chocolatey version) doesn't support some features needed by modern plugins
- The `luarocks.nvim` dependency manager doesn't properly handle mixed path styles

**Environment**:
- Windows with Git Bash (Cygwin)
- LuaRocks installed via Chocolatey
- Lua 5.1

**Workaround**: Plugin disabled with `enabled = false` in configuration file.

**Potential Solutions for Upstream**:
1. Add Windows/Cygwin detection and path normalization
2. Document LuaRocks installation requirements for Windows users
3. Consider alternative installation methods that don't require LuaRocks on Windows
4. Add `enabled = vim.fn.has('win32') == 0` to disable automatically on Windows

### obsidian.nvim - OneDrive Path Configuration

**Status**: Resolved - updated vault path to OneDrive location

**Issue**: obsidian.nvim failed to run with "Failed to run `config` for obsidian.nvim" error.

**Root Cause**: The workspace path was configured as `~/notes` which doesn't exist. The actual Obsidian vault is located in OneDrive at `~/OneDrive - Örebro universitet/SCTO-Obsidian/`.

**Solution**: Updated `lua/plugins/notes.lua` (line 51) to point to the correct path:
```lua
workspaces = {
  {
    name = 'scto',
    path = '~/OneDrive - Örebro universitet/SCTO-Obsidian',
  },
}
```

**Note**: Windows with OneDrive and special characters in paths (like `ö`) work correctly with tilde (`~`) expansion in Neovim when using the full path.

### blink.cmp - Fuzzy Matching Pre-built Binaries

**Status**: Resolved - configured to use Lua implementation

**Issue**: blink.cmp showed warnings on startup:
```
No fuzzy matching library found! Try building from source via build = 'cargo build --release'
Falling back to Lua implementation due to error while downloading pre-built binary
```

**Root Cause**: Pre-built Rust binaries for the fuzzy matching library were not available or failed to download for the Windows/Git Bash environment.

**Solution**: Configured `lua/plugins/completion.lua` to explicitly use the Lua implementation:
```lua
opts = {
  fuzzy = {
    implementation = 'lua',
  },
  -- ...
}
```

**Note**: The Lua implementation works well for most use cases. If you need the performance of the Rust implementation, you would need to install Rust nightly and build from source with `build = 'cargo build --release'`.

## Notes

- The main `init.lua` in the root remains minimal and clean
- Upstream files in `lua/config/` and `lua/plugins/` are kept unmodified
- Your custom LSP changes have been discarded in favor of upstream LSP config
- Backups of the old config are saved as `init.lua.backup` and `lua/config/lazy.lua.backup`
