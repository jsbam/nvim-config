-- VSCode-specific configuration
-- Only loaded when running in VSCode context
print '🔧 LOADED VSCODE mappings'

if not vim.g.vscode then
  return
end

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('custom-vscode-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Use system clipboard for all operations
vim.opt.clipboard = 'unnamedplus'
-- Show search matches as you type
vim.opt.incsearch = true
-- Ignore case unless uppercase letters are used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Move selected lines down in visual modes
vim.keymap.set('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move lines down', silent = true })

-- Move selected lines up in visual modes
vim.keymap.set('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move lines up', silent = true })

local opts = { noremap = true, silent = true }

local mappings = {
  -- File & Workspace Management
  { 'n', '<leader>rw', 'workbench.action.reloadWindow' },
  { 'n', '<leader>os', 'workbench.action.openSettingsJson' },
  { 'n', '<leader>ok', 'workbench.action.openGlobalKeybindingsFile' },
  { 'n', '<leader>od', 'workbench.action.toggleDevTools' },
  { 'n', '<leader>cp', 'copyRelativeFilePath' },

  -- File Operations
  { 'n', '<leader>ff', 'workbench.action.quickOpen' },
  { 'n', '<leader>fF', 'workbench.action.openRecent' },
  { 'n', '<leader>fa', 'fileutils.newFileAtRoot' },
  { 'n', '<leader>fx', 'workbench.action.closeActiveEditor' },
  { 'n', '<leader>bd', 'workbench.action.closeActiveEditor' },
  { 'n', '<leader>fq', 'workbench.action.closeAllEditors' },
  { 'n', '<leader>bD', 'workbench.action.closeEditorsInOtherGroups' },

  -- Search & Replace
  { 'n', '<leader>fg', 'actions.find' },
  { 'n', '<leader>fr', 'editor.action.startFindReplaceAction' },
  { 'n', '<leader>fG', 'workbench.action.findInFiles' },
  { 'n', '<leader>fR', 'workbench.action.replaceInFiles' },

  -- Line Operations
  { 'n', '<leader>yp', 'editor.action.copyLinesDownAction' },
  { 'n', '<leader>yP', 'editor.action.copyLinesUpAction' },
  { 'n', '<leader>dp', 'editor.action.moveLinesDownAction' },
  { 'n', '<leader>dP', 'editor.action.moveLinesUpAction' },

  -- Code Actions
  { 'n', '<leader>cf', 'editor.action.formatDocument' },
  { 'n', '<leader>cF', 'editor.action.formatSelection' },
  { 'n', '<leader>en', 'editor.action.marker.next' },
  { 'n', '<leader>ep', 'editor.action.marker.prev' },

  -- Navigation
  { 'n', '<C-h>', 'workbench.action.navigateLeft' },
  { 'n', '<C-l>', 'workbench.action.navigateRight' },
  { 'n', '<C-k>', 'workbench.action.navigateUp' },
  { 'n', '<C-j>', 'workbench.action.navigateDown' },

  -- Views
  { 'n', '<leader>e', 'workbench.view.explorer' },
  { 'n', '<leader>tt', 'workbench.action.terminal.toggleTerminal' },
  { 'n', '<leader>tc', 'workbench.panel.positronConsole.focus' },

  -- Window Management
  { 'n', '<leader>sh', 'workbench.action.splitEditor' },
  { 'n', '<leader>sv', 'workbench.action.splitEditorDown' },
  { 'n', '<leader>sj', 'workbench.action.joinTwoGroups' },
  { 'n', '<leader>se', 'workbench.action.evenEditorWidths' },

  -- Quarto
  { 'n', '<leader>qp', 'quarto.preview' },
  { 'n', '<leader>qc', 'quarto.runCurrentCell' },
  { 'n', '<leader>qn', 'quarto.runNextCell' },
  { 'n', '<leader>qP', 'quarto.runCellsAbove' },
  { 'n', '<leader>qN', 'quarto.runCellsBelow' },
  { 'n', '<leader>qA', 'quarto.runAllCells' },
  { 'n', '<leader>qr', 'quarto.renderDocument' },
}

for _, mapping in ipairs(mappings) do
  local mode, key, command = mapping[1], mapping[2], mapping[3]
  vim.keymap.set(mode, key, function()
    vim.fn.VSCodeNotify(command)
  end, opts)
end

-- Load VSCode-specific plugins
require 'custom.config.vscode-plugins'
