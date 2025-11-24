-- VSCode-Neovim specific configuration
-- This file is loaded only when running inside VSCode

if not vim.g.vscode then
  return
end

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Move selected lines down in visual mode
vim.keymap.set('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move lines down', silent = true })

-- Move selected lines up in visual mode
vim.keymap.set('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move lines up', silent = true })

local opts = { noremap = true, silent = true }

-- VSCode-specific command mappings
local mappings = {
  -- File & Workspace Management
  { 'n', '<leader>rw', 'workbench.action.reloadWindow' },
  { 'n', '<leader>os', 'workbench.action.openSettingsJson' },
  { 'n', '<leader>ok', 'workbench.action.openGlobalKeybindingsFile' },
  { 'n', '<leader>od', 'workbench.action.toggleDevTools' },
  { 'n', '<leader>cp', 'copyRelativeFilePath' },

  -- File operations
  { 'n', '<leader>ff', 'workbench.action.quickOpen' },
  { 'n', '<leader>fF', 'workbench.action.openRecent' },
  { 'n', '<leader>fa', 'fileutils.newFileAtRoot' },
  { 'n', '<leader>fx', 'workbench.action.closeActiveEditor' },
  { 'n', '<leader>bd', 'workbench.action.closeActiveEditor' },
  { 'n', '<leader>fq', 'workbench.action.closeAllEditors' },
  { 'n', '<leader>bD', 'workbench.action.closeEditorsInOtherGroups' },

  -- Search & replace
  { 'n', '<leader>fg', 'actions.find' },
  { 'n', '<leader>fr', 'editor.action.startFindReplaceAction' },
  { 'n', '<leader>fG', 'workbench.action.findInFiles' },
  { 'n', '<leader>fR', 'workbench.action.replaceInFiles' },

  -- Line editing
  { 'n', '<leader>yp', 'editor.action.copyLinesDownAction' },
  { 'n', '<leader>yP', 'editor.action.copyLinesUpAction' },
  { 'n', '<leader>dp', 'editor.action.moveLinesDownAction' },
  { 'n', '<leader>dP', 'editor.action.moveLinesUpAction' },

  -- Formatting
  { 'n', '<leader>cf', 'editor.action.formatDocument' },
  { 'n', '<leader>cF', 'editor.action.formatSelection' },

  -- Error navigation
  { 'n', '<leader>en', 'editor.action.marker.next' },
  { 'n', '<leader>ep', 'editor.action.marker.prev' },

  -- Navigation
  { 'n', 'Ctrl+h', 'workbench.action.navigateLeft' },
  { 'n', 'Ctrl+l', 'workbench.action.navigateRight' },
  { 'n', 'Ctrl+k', 'workbench.action.navigateUp' },
  { 'n', 'Ctrl+j', 'workbench.action.navigateDown' },

  -- File explorer
  { 'n', '<leader>e', 'workbench.view.explorer' },

  -- Terminal
  { 'n', '<leader>tt', 'workbench.action.terminal.toggleTerminal' },
  { 'n', '<leader>tc', 'workbench.panel.positronConsole.focus' },

  -- Window Management
  { 'n', '<leader>sh', 'workbench.action.splitEditor' },
  { 'n', '<leader>sv', 'workbench.action.splitEditorDown' },
  { 'n', '<leader>sj', 'workbench.action.joinTwoGroups' },
  { 'n', '<leader>se', 'workbench.action.evenEditorWidths' },

  -- Quarto commands (if using Quarto extension in VSCode)
  { 'n', '<leader>qp', 'quarto.preview' },
  { 'n', '<leader>qc', 'quarto.runCurrentCell' },
  { 'n', '<leader>qn', 'quarto.runNextCell' },
  { 'n', '<leader>qP', 'quarto.runCellsAbove' },
  { 'n', '<leader>qN', 'quarto.runCellsBelow' },
  { 'n', '<leader>qA', 'quarto.runAllCells' },
  { 'n', '<leader>qr', 'quarto.renderDocument' },
}

-- Apply all VSCode command mappings
for _, mapping in ipairs(mappings) do
  local mode, key, command = mapping[1], mapping[2], mapping[3]
  vim.keymap.set(mode, key, function()
    vim.fn.VSCodeNotify(command)
  end, opts)
end

-- Bootstrap lazy.nvim for VSCode
require 'config.lazy-bootstrap'

-- Load only minimal plugins for VSCode environment
local vscode_plugins = {
  require 'custom.plugins.mini',
  require 'custom.plugins.vim-visual-multi',
  require 'custom.plugins.flash',
}

require('lazy').setup(vscode_plugins, {
  root = vim.fn.stdpath 'data' .. '/lazy-vscode', -- separate install dir from main nvim
  defaults = { version = false },
})
