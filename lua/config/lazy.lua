--  bootstrap lazy package manager
--  <https://github.com/folke/lazy.nvim>
require 'config.lazy-bootstrap'
-- local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system {
--     'git',
--     'clone',
--     '--filter=blob:none',
--     '--single-branch',
--     'https://github.com/folke/lazy.nvim.git',
--     lazypath,
--   }
-- end
-- vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
  { import = 'custom.plugins' },
}, {
  defaults = {
    version = false,
  },
  dev = {
    path = '~/projects',
    fallback = true,
  },
  install = {
    missing = true,
    colorscheme = { 'default' },
  },
  checker = { enabled = false },
  rtp = {
    disabled_plugins = {
      'gzip',
      'matchit',
      'matchparen',
      -- 'netrwPlugin',
      'tarPlugin',
      'tohtml',
      'tutor',
      'zipPlugin',
      -- 'lualine',
    },
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- require 'config.keymap'
