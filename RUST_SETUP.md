# Rust Setup for blink.cmp

## Issue
`blink.cmp` plugin requires a fuzzy matching library that needs to be built from source using Rust.

**Warning (before fix):**
```
blink.cmp  No fuzzy matching library found! Try building from source via 
build = 'cargo build --release'  in your lazy.nvim spec and re-installing
(requires Rust nightly)
```

## Solution: Install Rust

### Installation (Done on 2025-11-24)

```bash
# Install Rust using rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Load Rust environment
source "$HOME/.cargo/env"

# Verify installation
cargo --version  # cargo 1.91.1
rustc --version  # rustc 1.91.1
```

### Build blink.cmp

After Rust installation, rebuild blink.cmp:

```bash
source "$HOME/.cargo/env"
nvim --headless "+Lazy! build blink.cmp" +qa
```

**Result:**
- Installed Rust nightly (1.93.0-nightly)
- Built blink-cmp-fuzzy successfully
- Warning eliminated ✅

## Persistent Setup

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Rust environment
source "$HOME/.cargo/env"
```

This ensures cargo is available in all new shell sessions.

## Verification

Test that blink.cmp loads without warnings:

```bash
nvim --version  # Should not show fuzzy matching warning
```

## Status

✅ **Rust installed:** cargo 1.91.1, rustc 1.91.1
✅ **blink.cmp built:** Fuzzy matching library compiled successfully
✅ **Warning resolved:** No more blink.cmp warnings on startup

## Notes

- Rust is installed in `~/.cargo/`
- Binary location: `~/.cargo/bin/cargo`
- blink.cmp build location: `~/.local/share/nvim/lazy/blink.cmp/target/release/`
- Build configuration is already in `lua/plugins/completion.lua`:
  ```lua
  build = 'cargo build --release',
  ```

## Cross-Platform

### Mac (Current) ✅
- Rust installed via rustup
- Works natively on Apple Silicon (aarch64-apple-darwin)

### Windows
- Install Rust from: https://rustup.rs/
- Or use: `winget install Rustlang.Rustup`
- Same lazy.nvim build command will work

## Future Updates

When blink.cmp updates, lazy.nvim will automatically rebuild it using cargo if needed.
