# Windows vs Mac Platform Differences

This document outlines the platform-specific settings and how they were adapted for Mac compatibility.

## Path Adjustments

### 1. OneDrive Path (Obsidian Workspace)

**Windows:**
```lua
path = '~/OneDrive - Örebro universitet/SCTO-Obsidian'
```

**Mac:**
```lua
path = '~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian'
```

**Location:** `lua/custom/plugins/obsidian.lua`

**Why different?**
- Windows: OneDrive syncs to `~/OneDrive - Organization Name/`
- Mac: OneDrive syncs to `~/Library/CloudStorage/OneDrive-OrganizationName/` (no spaces, hyphens instead)

---

## Conditional Settings (Cross-Platform Compatible)

### 2. SQLite Library Path

**Implementation in `lua/custom/config/options.lua`:**
```lua
-- Windows-specific: SQLite path for database plugins
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  vim.g.sqlite_clib_path = 'C:\\\\ProgramData\\\\chocolatey\\\\lib\\\\sqlite\\\\tools\\\\sqlite3.dll'
end
```

**Why conditional?**
- **Windows:** Requires explicit path to SQLite DLL (installed via Chocolatey)
- **Mac:** SQLite is available natively via system libraries - no configuration needed

**Affected plugins:**
- `telescope-zotero.nvim` (uses sqlite.lua dependency)
- Any plugin using `kkharji/sqlite.lua`

---

## Settings That Work on Both Platforms

These settings in your custom config work identically on both Windows and Mac:

1. **Keymaps** (`lua/custom/config/keymaps.lua`)
   - All keybindings are platform-agnostic
   - `jj` to escape, `<leader>` mappings, etc.

2. **Plugin configurations** (`lua/custom/plugins/`)
   - flash.nvim
   - mini-nvim.lua
   - vim-visual-multi.lua
   - oil-nvim.lua
   - lualine.lua
   - All work identically on both platforms

3. **VSCode Integration** (`lua/custom/config/vscode.lua`)
   - VSCode command mappings are platform-independent
   - Same VSCode extension commands work on both

4. **Vim Options** (`lua/custom/config/options.lua`)
   - `timeoutlen = 2000`
   - `VM_maps` configuration
   - All vim settings are cross-platform

---

## Summary Table

| Setting | Windows | Mac | Status |
|---------|---------|-----|--------|
| OneDrive Path | `~/OneDrive - Örebro universitet/` | `~/Library/CloudStorage/OneDrive-Örebrouniversitet/` | ✅ Adjusted |
| SQLite Path | `C:\\ProgramData\\...\\sqlite3.dll` | Not needed (native) | ✅ Conditional |
| All keymaps | Same | Same | ✅ Compatible |
| All plugins | Same | Same | ✅ Compatible |
| VSCode config | Same | Same | ✅ Compatible |

---

## How to Sync Between Platforms

When syncing your config between Windows and Mac:

1. **Pull from your fork** (`jsbam/nvim-config`)
2. **Platform-specific files are already handled:**
   - SQLite: Conditional check in `options.lua` (line 7-10)
   - OneDrive: Separate override in `plugins/obsidian.lua` (adjust per machine)

3. **To update obsidian path** on a different platform:
   ```bash
   # On Mac
   vim lua/custom/plugins/obsidian.lua
   # Change to: ~/Library/CloudStorage/OneDrive-Örebrouniversitet/...
   
   # On Windows
   vim lua/custom/plugins/obsidian.lua
   # Change to: ~/OneDrive - Örebro universitet/...
   ```

**Note:** Consider creating platform-specific branches if you need different obsidian paths, or use an environment variable to detect the platform and set the path dynamically.

---

## Future Improvements

To make obsidian path fully cross-platform, you could use:

```lua
local onedrive_path
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  onedrive_path = '~/OneDrive - Örebro universitet/SCTO-Obsidian'
else
  onedrive_path = '~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian'
end

return {
  {
    'obsidian-nvim/obsidian.nvim',
    opts = {
      workspaces = {
        { name = 'scto', path = onedrive_path },
      },
    },
  },
}
```
