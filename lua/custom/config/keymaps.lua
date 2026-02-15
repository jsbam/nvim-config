-- Custom keymaps that extend jmbuhr's config
-- These are your personal keybindings

local config = vim.fn.stdpath 'config' .. '/init.lua'

local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

-- jj to escape insert mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'From I mode to N mode' })

-- Open init.lua
nmap('<leader>oi', ':e ' .. config .. '<cr>', 'Open init.lua')

-- Quick save
nmap('<leader>s', ':w<cr>', 'Save file')

-- Save & source current file
vim.keymap.set(
  'n',
  '<leader>%',
  '<Cmd>w | source %<CR>',
  { desc = 'Save & source current file', noremap = true, silent = true }
)

-- Use leader+V (capital V) to enter visual block mode (since Ctrl+v is intercepted by terminal)
-- vim.keymap.set('n', '<leader>V', '<C-v>', { noremap = true, desc = 'Visual block mode' })
-- vim.keymap.set('n', '<^-V>', '<C-v>', { noremap = true, desc = 'Visual block mode' })

-- Clear search highlighting
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Buffer management
nmap('<Tab>', ':bnext<CR>', 'Next buffer')
nmap('<S-Tab>', ':bprevious<CR>', 'Previous buffer')
nmap('<leader>x', ':bdelete!<CR>', 'close buffer')
nmap('<leader>b', '<cmd>enew<CR>', 'new buffer')
nmap('<leader>bn', '<Cmd>bnext<CR>', 'Next buffer')
nmap('<leader>bp', '<Cmd>bprevious<CR>', 'Previous buffer')
nmap('<leader>bd', ':bd<cr>', '[d]elete current [b]uffer')

-- Window splits
nmap('<leader>sv', '<Cmd>vsplit<CR>', 'Split window vertically')
nmap('<leader>sh', '<Cmd>split<CR>', 'Split window horizontally')

-- Quick config edit
nmap('<leader>rc', '<Cmd>e ' .. config .. '<CR>', 'Edit config')

-- Line joining that keeps cursor position
nmap('J', 'mzJ`z', 'Join lines and keep cursor position')

-- Vim-visual-multi configuration moved to lua/custom/plugins/vim-visual-multi.lua

-- Windows-specific terminal overrides
-- Use VeryLazy to ensure this runs AFTER all plugins (including which-key) have loaded
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      -- Override R terminal to use full path on Windows
      vim.keymap.set('n', '<leader>cr', function()
        vim.cmd 'vnew'
        vim.fn.jobstart({ 'C:/Program Files/R/R-4.5.2/bin/R.exe', '--no-save' }, { term = true })
      end, { desc = 'new [R] terminal', silent = true })
    end,
  })
end
