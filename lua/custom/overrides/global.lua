-- Custom global settings overrides
-- These settings are applied after the base configuration

-- Basic display options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- List chars customization (override base config)
vim.opt.list = true
vim.opt.listchars = { tab = '>>', trail = '.', nbsp = '␣' }

-- Incremental command preview
vim.opt.inccommand = 'split'

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- jj to escape from insert mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'From I mode to N mode' })

-- Vim-visual-multi settings for multiple cursors
-- vim.g.VM_defaults_mappings = 1
-- vim.g.VM_maps = {
--   ['Select All'] = '<leader>a',
--   ['Visual All'] = '<leader>a',
--   ['Align'] = '<leader>A',
--   ['Add Cursor Down'] = '<C-Down>',
--   ['Add Cursor Up'] = '<C-Up>',
-- }
