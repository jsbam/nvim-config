-- Custom configuration loader
-- This file loads all your personal customizations on top of jmbuhr's config

-- Load VSCode-specific configuration if running in VSCode
if vim.g.vscode then
  require 'custom.config.vscode'
  return -- Don't load other customizations in VSCode
end

-- Load custom options and keymaps (only in regular Neovim)
require 'custom.config.options'
require 'custom.config.keymaps'

-- Note: Custom plugins in lua/custom/plugins/ will be automatically loaded by lazy.nvim
-- if you add 'custom.plugins' to the lazy.setup() import in lua/config/lazy.lua
