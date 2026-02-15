---@diagnostic disable: undefined-global
-- Main Neovim Configuration Entry Point
-- This config structure allows easy upstream updates while keeping customizations separate

-- Set leader key early
vim.g.mapleader = ' '

-- Set sqlite path for Windows
if vim.fn.has 'win32' == 1 then
  vim.g.sqlite_clib_path = 'C:/Users/jsh001/AppData/Local/nvim-data/lazy/sqlite.lua/lua/sqlite/sqlite3.dll'
end

-- Optional treesitter language customizations (from upstream)
-- vim.treesitter.language.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
-- vim.treesitter.language.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
-- vim.treesitter.language.register('pandoc_markdown', { 'quarto', 'rmarkdown' })

-- vim.treesitter.language.add('quarto_markdown', { path = "/usr/local/lib/libtree-sitter-markdown.so" })
-- vim.treesitter.language.add('quarto_markdown_inline', { path = "/usr/local/lib/libtree-sitter-markdown-inline.so" })
-- vim.treesitter.language.register('quarto_markdown', { 'quarto', 'rmarkdown' })

-- If running in VSCode, load custom VSCode config and exit
if vim.g.vscode then
  require 'custom.config.vscode'
  return
end

-- For regular Neovim, load the base configuration first
require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

-- Then load custom configuration (options and keymaps take precedence)
require 'custom.config.options'
require 'custom.config.keymaps'
require 'custom.config.autocommands'

-- use latest treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
  end,
})
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

-- Transparent background if needed
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight ColorColumn ctermbg=none
  highlight ColorColumn guibg=none
  highlight SignColumn ctermbg=none
  highlight SignColumn guibg=none
  highlight LineNr ctermbg=none
  highlight LineNr guibg=none
  highlight CursorLine ctermbg=none
  highlight CursorLine guibg=none
  highlight CursorLineNr ctermbg=none
  highlight CursorLineNr ctermbg=none
  highlight CursorLineNr guibg=none
]]

-- Terminal cursor color
vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

-- Window separator color
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'dimgray', bg = '' })
