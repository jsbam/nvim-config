-- Override blink.cmp configuration for Windows compatibility
-- Uses Lua fuzzy implementation instead of Rust binaries to avoid build issues
return {
  'saghen/blink.cmp',
  -- Use version instead of building from source on Windows
  build = vim.fn.has('win32') == 1 and nil or 'cargo build --release',
  opts = function(_, opts)
    -- Use Lua implementation for fuzzy matching (avoids Rust build on Windows)
    opts.fuzzy = opts.fuzzy or {}
    opts.fuzzy.implementation = 'lua'
    return opts
  end,
}
