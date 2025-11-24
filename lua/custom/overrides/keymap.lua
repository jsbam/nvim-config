-- Custom keymap overrides and additions
-- These keymaps are added on top of the base configuration

local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

-- Custom keybindings
-- Open init.lua config
vim.cmd 'nmap <leader>oi :e ~/AppData/Local/nvim/init.lua<cr>'

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
nmap('<leader>rc', '<Cmd>e ~/.config/nvim/init.lua<CR>', 'Edit config')

-- Line joining that keeps cursor position
nmap('J', 'mzJ`z', 'Join lines and keep cursor position')
