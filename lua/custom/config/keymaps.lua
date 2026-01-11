-- Custom keymaps that extend jmbuhr's config
-- These are your personal keybindings

-- jj to escape insert mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'From I mode to N mode' })

-- Open init.lua
vim.keymap.set('n', '<leader>oi', ':e ~/.config/nvim/init.lua<cr>', { desc = 'Open init.lua' })

-- Quick save
vim.keymap.set('n', '<leader>s', ':w<cr>', { desc = 'Save file' })

-- Save & source current file
vim.keymap.set(
  'n',
  '<leader>%',
  '<Cmd>w | source %<CR>',
  { desc = 'Save & source current file', noremap = true, silent = true }
)
-- Use leader+V (capital V) to enter visual block mode (since Ctrl+v is intercepted by terminal)
vim.keymap.set('n', '<leader>V', '<C-v>', { noremap = true, desc = 'Visual block mode' })
