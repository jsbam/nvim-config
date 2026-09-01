-- VSCode-specific configuration
-- Only loaded when running in VSCode context
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

local cursor_group = vim.api.nvim_create_augroup('vscode-restore-cursor', { clear = true })
local cursor_db_path = vim.fn.stdpath 'data' .. '\\vscode-cursor-positions.json'
local cursor_db = nil

local function is_real_file_buffer()
  local bt = vim.bo.buftype
  if bt ~= '' and bt ~= 'acwrite' then
    return false
  end

  local name = vim.api.nvim_buf_get_name(0)
  return name ~= '' and not name:match '^term://'
end

local function cursor_key()
  local name = vim.api.nvim_buf_get_name(0)
  if name:match '^[a-z]+://' then
    return name
  end
  return vim.fn.fnamemodify(name, ':p')
end

local function load_cursor_db()
  if cursor_db ~= nil then
    return
  end

  cursor_db = {}
  local ok, lines = pcall(vim.fn.readfile, cursor_db_path)
  if not ok or not lines or #lines == 0 then
    return
  end

  local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, '\n'))
  if decoded_ok and type(decoded) == 'table' then
    cursor_db = decoded
  end
end

local function save_cursor_db()
  if cursor_db == nil then
    return
  end

  local ok, encoded = pcall(vim.json.encode, cursor_db)
  if not ok then
    return
  end

  pcall(vim.fn.writefile, { encoded }, cursor_db_path)
end

local function remember_cursor_position()
  if not is_real_file_buffer() then
    return
  end

  load_cursor_db()
  local key = cursor_key()
  local pos = vim.api.nvim_win_get_cursor(0)
  cursor_db[key] = { line = pos[1], col = pos[2] }
  save_cursor_db()
end

local function restore_last_cursor_position()
  if not is_real_file_buffer() then
    return
  end

  load_cursor_db()
  local key = cursor_key()
  local saved = cursor_db and cursor_db[key] or nil
  if type(saved) == 'table' and type(saved.line) == 'number' and type(saved.col) == 'number' then
    local last = vim.fn.line '$'
    if saved.line > 0 and saved.line <= last then
      pcall(vim.api.nvim_win_set_cursor, 0, { saved.line, math.max(saved.col, 0) })
      return
    end
  end

  local line = vim.fn.line [["]]
  local col = vim.fn.col [["]]
  local last = vim.fn.line '$'

  if line > 0 and line <= last then
    pcall(vim.api.nvim_win_set_cursor, 0, { line, math.max(col - 1, 0) })
  end
end

-- Persist marks/shada in VSCode sessions (embedded nvim may not flush on close)
vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWinLeave', 'VimLeavePre' }, {
  group = cursor_group,
  callback = function()
    if is_real_file_buffer() then
      remember_cursor_position()
      pcall(vim.cmd, 'silent! wshada!')
    end
  end,
})

-- Restore after open and once again after VSCode finishes focusing/rendering the editor
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWinEnter', 'BufEnter' }, {
  group = cursor_group,
  callback = function()
    vim.schedule(restore_last_cursor_position)
    vim.defer_fn(restore_last_cursor_position, 120)
  end,
})
-- Prevent clipboard overwrite when pasting in visual mode
vim.keymap.set('x', 'p', '"_dP', { noremap = true })
vim.keymap.set('x', 'P', '"_dP', { noremap = true })

-- Use system clipboard for all operations
vim.opt.clipboard = 'unnamedplus'
-- ESC key to clear search highlights
vim.keymap.set('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- Show search matches as you type
vim.opt.incsearch = true
-- Ignore case unless uppercase letters are used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Paste over selected text without yanking it
vim.keymap.set('x', 'p', '"_dP', { noremap = true, silent = true })
-- Move selected lines down in visual modes
vim.keymap.set('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move lines down', silent = true })

-- Move selected lines up in visual modes
vim.keymap.set('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move lines up', silent = true })

local opts = { noremap = true, silent = true }

local mappings = {
  -- editing
  { 'n', '<leader>A', 'editor.action.selectAll' },

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

  -- comment with gcc
  { 'n', 'gcc', 'editor.action.commentLine' },
  { 'x', 'gc', 'editor.action.commentLine' },

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
