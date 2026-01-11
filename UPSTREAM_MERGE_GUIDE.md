# Upstream Merge Guide

## Merge Workflow

### 1. Fetch & Preview

```bash
git fetch upstream
git log --oneline HEAD..upstream/main -10
```

### 2. Test Merge

```bash
# Dry run
git merge upstream/main --no-commit --no-ff

# If OK, complete it
git merge --continue

# If issues, abort
git merge --abort
```

### 3. Verify Key Integrations

Run the automated check script:

```bash
./check-merge.sh
```

### 4. Manual Verification (if needed)

**VSCode integration** (init.lua lines 16-20):
```bash
sed -n '16,20p' init.lua
```

**Custom plugins** (lazy.lua line 19):
```bash
sed -n '17,20p' lua/config/lazy.lua
```

**Custom config loading** (init.lua lines 29-30):
```bash
sed -n '29,30p' init.lua
```

### 5. Test & Push

```bash
# Test Neovim starts without errors
nvim --headless +qa

# Push to your fork
git push origin main
```

## Conflict Resolution

### Debugging Conflicts

```bash
# Check which files have conflicts
git status

# View conflict markers in files
git diff --name-only --diff-filter=U
```

### If `init.lua` Conflicts

**Critical sections to preserve:**

1. **VSCode handling** (lines 16-20):
```lua
if vim.g.vscode then
  require 'custom.config.vscode'
  return
end
```

2. **Custom config loading** (lines 29-30):
```lua
require 'custom.config.options'
require 'custom.config.keymaps'
```

3. **Custom colorscheme** (lines 55-56):
```lua
vim.cmd.colorscheme 'oscura'
```

**Resolution:**
```bash
# Edit to preserve sections above
nvim init.lua

# Stage and continue
git add init.lua && git merge --continue
```

### If `lazy.lua` Conflicts

**Critical section:** Custom plugins import (line 19)

```lua
require('lazy').setup({
  { import = 'plugins' },
  { import = 'custom.plugins' },  -- Must keep this
}, {
```

**Resolution:**
```bash
nvim lua/config/lazy.lua
git add lua/config/lazy.lua && git merge --continue
```

## Reference: Modified Core Files

### `init.lua`
- Lines 16-20: VSCode handling
- Lines 29-30: Custom config loading
- Lines 55-56: Custom colorscheme

### `lua/config/lazy.lua`
- Line 19: Custom plugins import

### `lua/custom/`
All customizations isolated here (never conflicts with upstream)

## Verification

Use `check-merge.sh` to verify setup after merges:

```bash
./check-merge.sh
```
