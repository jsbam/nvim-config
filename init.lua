-- Main Neovim Configuration Entry Point
-- This config structure allows easy upstream updates while keeping customizations separate

-- Set leader key early
vim.g.mapleader = ' '

-- Optional treesitter language customizations (from upstream)
-- vim.treesitter.language.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
-- vim.treesitter.language.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
-- vim.treesitter.language.register('pandoc_markdown', { 'quarto', 'rmarkdown' })

-- vim.treesitter.language.add('quarto_markdown', { path = "/usr/local/lib/libtree-sitter-markdown.so" })
-- vim.treesitter.language.add('quarto_markdown_inline', { path = "/usr/local/lib/libtree-sitter-markdown-inline.so" })
-- vim.treesitter.language.register('quarto_markdown', { 'quarto', 'rmarkdown' })

-- Load custom configuration (handles VSCode, Windows-specific settings, etc.)
require 'custom'

-- If running in VSCode, custom.init handles everything, so we're done
if vim.g.vscode then
  return
end

-- For regular Neovim, load the base configuration
require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

-- Colorscheme configuration (from upstream with custom preference)
local use_minimal_default_colors = false

if use_minimal_default_colors then
  vim.cmd.colorscheme 'default'

  -- reload colors module if it was already loaded
  local mod = 'utils.colors'
  if package.loaded[mod] then
    package.loaded[mod] = nil
  end

  require(mod)
else
  -- Use oscura as default (custom preference)
  vim.cmd.colorscheme 'oscura'
end

-- Terminal cursor color
vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

-- Window separator color
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'dimgray', bg = '' })

