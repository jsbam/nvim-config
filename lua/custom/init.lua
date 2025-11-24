-- Custom Configuration Entry Point
-- This file loads all custom configurations and overrides

-- Load Windows-specific settings first (if applicable)
require 'custom.windows'

-- Check if running in VSCode
if vim.g.vscode then
  -- Load VSCode-specific configuration
  require 'custom.vscode'
  -- VSCode config handles its own plugin loading, so we return here
  return
end

-- For regular Neovim, apply custom overrides after base config loads
-- These will be loaded from the main init.lua after the base config

-- Load custom global setting overrides
require 'custom.overrides.global'

-- Load custom keymap additions/overrides
require 'custom.overrides.keymap'

-- Note: Plugin overrides are handled in lua/custom/plugins/init.lua
-- which is automatically picked up by lazy.nvim
