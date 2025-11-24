-- Custom options that extend jmbuhr's config

-- Longer timeout for key sequences (for flash + mini.surround coexistence)
vim.opt.timeoutlen = 2000

-- Windows-specific: SQLite path for database plugins
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  -- \\\\ in Lua strings → \\ on disk
  vim.g.sqlite_clib_path = 'C:\\\\ProgramData\\\\chocolatey\\\\lib\\\\sqlite\\\\tools\\\\sqlite3.dll'
end

-- Vim-visual-multi configuration
vim.g.VM_defaults_mappings = 1
vim.g.VM_maps = {
  ['Select All'] = '<leader>a',
  ['Visual All'] = '<leader>a',
  ['Align'] = '<leader>A',
  ['Add Cursor Down'] = '<C-Down>',
  ['Add Cursor Up'] = '<C-Up>',
}
