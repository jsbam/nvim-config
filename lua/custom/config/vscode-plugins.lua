-- VSCode-specific plugin configuration
-- These plugins will only load in VSCode

if not vim.g.vscode then
  return
end

-- Bootstrap lazy.nvim if not already done
local lazypath = vim.fn.stdpath 'data' .. '/lazy-vscode/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load VSCode-specific plugins
local vscode_plugins = {
  -- Mini suite
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.comment').setup()
    end,
  },
  
  -- Vim visual multi (multiple cursors)
  {
    'mg979/vim-visual-multi',
    branch = 'master',
  },
  
  -- Flash (quick navigation)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },
}

require('lazy').setup(vscode_plugins, {
  root = vim.fn.stdpath 'data' .. '/lazy-vscode',
  defaults = { version = false },
})
