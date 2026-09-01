-- lua/custom/config/vscode_test.lua

vim.notify 'VSCode-Neovim test config loaded'

vim.keymap.set('n', '<leader>tt', function()
  vim.notify 'TEST KEYMAP WORKS'
end, { desc = 'Test keymap' })

vim.keymap.set('n', '<leader>A', function()
  vim.fn.VSCodeNotify 'editor.action.selectAll'
end, { desc = 'Select all' })
