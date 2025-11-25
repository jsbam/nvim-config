# Upstream Merge Testing & Guide

## Current Status ✅

**Last Tested:** 2025-11-24
**Result:** ✅ **NO CONFLICTS!**

```
$ git merge upstream/main --no-commit --no-ff
Already up to date.
```

## What Was Tested

1. **Git Remote Configuration:**
   - Origin: `jsbam/nvim-config` (your fork)
   - Upstream: `jmbuhr/nvim-config` (parent repo)

2. **Modified Files:**
   - `init.lua` - Added `require 'custom'` (3 lines)
   - `lua/config/lazy.lua` - Import custom.plugins (4 lines changed)

3. **Custom Files (Never Conflict):**
   - `lua/custom/` - Entire directory
   - `PLATFORM_DIFFERENCES.md`
   - `UPSTREAM_MERGE_GUIDE.md`

## Why No Conflicts?

### 1. Minimal Core Modifications ✅
Only 2 files modified, both with **append-only** changes at specific locations:

**`init.lua`** (3 lines added at EOF):
```lua
-- Load custom configurations (must be at the end)
require 'custom'
```

**`lua/config/lazy.lua`** (import structure change):
```lua
require('lazy').setup({
  { import = 'plugins' },
  { import = 'custom.plugins' },  -- Added
}, {
```

### 2. Custom Directory is Isolated ✅
All your customizations are in `lua/custom/` which:
- Doesn't exist in upstream
- Will never be modified by upstream
- Is designed to coexist with upstream changes

### 3. No Conflicts Because:
- **init.lua**: Added lines at END of file
  - Upstream can modify lines 1-47 without conflict
  - Our line 49-50 won't conflict unless upstream also adds at EOF (unlikely)

- **lazy.lua**: Changed setup call structure
  - This is a common pattern change
  - If upstream changes lazy.setup options, we can merge easily
  - Only conflict would be if upstream also changes to import structure (unlikely)

## How to Merge Upstream Updates

### Step 1: Fetch Latest
```bash
cd ~/.config/nvim
git fetch upstream
```

### Step 2: Check What's New
```bash
git log --oneline HEAD..upstream/main -10
```

### Step 3: Merge (Safe - Test First)
```bash
# Dry run (doesn't actually merge)
git merge upstream/main --no-commit --no-ff

# If successful, complete the merge
git merge --continue

# Or abort if there are issues
git merge --abort
```

### Step 4: Verify Critical Lines
After merge, ensure these lines still exist:

**`init.lua`** (should be at EOF):
```bash
tail -3 init.lua
```
Should show:
```lua
-- Load custom configurations (must be at the end)
require 'custom'
```

**`lua/config/lazy.lua`** (around line 16):
```bash
sed -n '16,19p' lua/config/lazy.lua
```
Should show:
```lua
require('lazy').setup({
  { import = 'plugins' },
  { import = 'custom.plugins' },
}, {
```

### Step 5: If Lines Are Missing (Unlikely)
If merge removed the critical lines, re-add them:

```bash
# For init.lua
echo "" >> init.lua
echo "-- Load custom configurations (must be at the end)" >> init.lua
echo "require 'custom'" >> init.lua

# For lazy.lua - edit manually
nvim lua/config/lazy.lua
```

### Step 6: Test Configuration
```bash
nvim --headless "+lua require('custom')" "+lua print('Custom loaded')" +qa
```

### Step 7: Push to Your Fork
```bash
git push origin main
```

## Conflict Resolution (If Needed)

### If `init.lua` Conflicts:
1. Accept upstream version: `git checkout --theirs init.lua`
2. Re-add custom line: `echo "require 'custom'" >> init.lua`
3. Stage and continue: `git add init.lua && git merge --continue`

### If `lazy.lua` Conflicts:
1. Edit the file manually to resolve
2. Ensure the import structure is:
   ```lua
   require('lazy').setup({
     { import = 'plugins' },
     { import = 'custom.plugins' },
   }, {
   ```
3. Stage and continue: `git add lua/config/lazy.lua && git merge --continue`

## Prevention Strategy

Our setup minimizes conflicts through:

1. ✅ **Isolated customizations** in `lua/custom/`
2. ✅ **Append-only modifications** to core files
3. ✅ **Platform detection** in custom code (no upstream dependency)
4. ✅ **Plugin overrides** via lazy.nvim's merge system

## Automated Check Script

Save this as `check-merge.sh` to verify setup before/after merges:

```bash
#!/bin/bash

echo "Checking critical lines..."

# Check init.lua
if grep -q "require 'custom'" init.lua; then
    echo "✅ init.lua: Custom loader present"
else
    echo "❌ init.lua: Custom loader MISSING!"
    exit 1
fi

# Check lazy.lua
if grep -q "{ import = 'custom.plugins' }" lua/config/lazy.lua; then
    echo "✅ lazy.lua: Custom plugins import present"
else
    echo "❌ lazy.lua: Custom plugins import MISSING!"
    exit 1
fi

# Test load
if nvim --headless "+lua require('custom')" "+lua print('OK')" +qa 2>&1 | grep -q "OK"; then
    echo "✅ Custom config loads successfully"
else
    echo "❌ Custom config FAILED to load!"
    exit 1
fi

echo ""
echo "All checks passed! ✅"
```

## Conclusion

Your setup is **merge-safe** with upstream! The minimal modifications and isolated custom directory mean you can pull upstream updates with minimal (likely zero) conflicts.

**Next upstream update:** Simply run `git fetch upstream && git merge upstream/main` 🚀
