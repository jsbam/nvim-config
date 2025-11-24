-- Custom blink.cmp configuration override
-- This overrides the upstream completion.lua to use Lua fuzzy implementation
-- instead of Rust binaries due to Windows compatibility issues

return {
  {
    'saghen/blink.cmp',
    enabled = true,
    dev = false,
    version = '0.*', -- Pin to 0.* instead of upstream's commented version
    -- build = 'cargo build --release', -- Commented out - using Lua implementation
    opts = {
      -- Use Lua fuzzy implementation instead of Rust for Windows compatibility
      fuzzy = {
        implementation = 'lua',
      },
    },
  },
}
