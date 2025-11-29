-- Custom keymap overrides and additions
-- These keymaps are added on top of the base configuration

local config = vim.fn.stdpath 'config' .. '/init.lua'

local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

-- Custom keybindings
-- Open init.lua config

vim.cmd('nmap <leader>oi :e ' .. vim.fn.stdpath 'config' .. '/init.lua<CR>')
-- if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
--   vim.cmd 'nmap <leader>oi :e ~/AppData/Local/nvim/init.lua<cr>'
-- end

-- Quick save
vim.cmd 'nmap <leader>s :w<cr>'

-- Save & source current file
vim.keymap.set(
  'n',
  '<leader>%',
  '<Cmd>w | source %<CR>',
  { desc = 'Save & source current file', noremap = true, silent = true }
)

-- Clear search highlighting
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Buffer navigation with Tab/Shift-Tab
nmap('<Tab>', ':bnext<CR>')
nmap('<S-Tab>', ':bprevious<CR>')
nmap('<leader>x', ':bdelete!<CR>', 'close buffer')
nmap('<leader>b', '<cmd> enew <CR>', 'new buffer')

-- Additional buffer keymaps
nmap('<leader>bn', '<Cmd>bnext<CR>', 'Next buffer')
nmap('<leader>bp', '<Cmd>bprevious<CR>', 'Previous buffer')

-- Window splits
nmap('<leader>sv', '<Cmd>vsplit<CR>', 'Split window vertically')
nmap('<leader>sh', '<Cmd>split<CR>', 'Split window horizontally')

-- Quick config edit
nmap('<leader>rc', '<Cmd>e ' .. config .. '<CR>', 'Edit config')
-- nmap('<leader>rc', '<Cmd>e ~/AppData/Local/nvim/init.lua<CR>', 'Edit config')

-- Line joining that keeps cursor position
nmap('J', 'mzJ`z', 'Join lines and keep cursor position')

-- Vim-visual-multi configuration
vim.g.VM_defaults_mappings = 1
vim.g.VM_maps = {
  ['Select All'] = '<leader>a',
  ['Visual All'] = '<leader>a',
  ['Align'] = '<leader>A',
  ['Add Cursor Down'] = '<C-Down>',
  ['Add Cursor Up'] = '<C-Up>',
}
