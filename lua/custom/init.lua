-- Custom Configuration Entry Point
-- This file loads all custom configurations and overrides

-- Check if running in VSCode
if vim.g.vscode then
  -- Load VSCode-specific configuration
  require 'custom.config.vscode'
  -- VSCode config handles its own plugin loading, so we return here
  return
end

-- For regular Neovim, load custom configurations
-- Load custom options and keymaps
require 'custom.config.options'
require 'custom.config.keymaps'

-- Note: Custom plugins in lua/custom/plugins/ are automatically loaded by lazy.nvim
-- via the import in lua/config/lazy.lua
