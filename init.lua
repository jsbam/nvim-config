-- <leader> key
vim.g.mapleader = ' '

if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  -- \\ in Lua strings → \ on disk
  vim.g.sqlite_clib_path = 'C:\\ProgramData\\chocolatey\\lib\\sqlite\\tools\\sqlite3.dll'
end
-- open config 
vim.cmd 'nmap <leader>oi :e ~/AppData/Local/nvim/init.lua<cr>'


-- save
vim.cmd 'nmap <leader>s :w<cr>'

-- paste without overwriting

-- clear search highlighting
-- vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
-- save & source current file
vim.keymap.set(
  'n',
  '<leader>%',
  '<Cmd>w | source %<CR>',
  { desc = 'Save & source current file', noremap = true, silent = true }
)
-- skip folds (down, up)

-- sync system clipboard
vim.opt.clipboard = 'unnamedplus'

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

--  change <ESC> with j-j
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'From I mode to N mode' })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.ignorecase = true

vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = '>>', trail = '.', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
-- set vim-visual-muti to add vertical cursors
vim.g.VM_defaults_mappings = 1
vim.g.VM_maps = {
  ['Select All'] = '<leader>a',
  ['Visual All'] = '<leader>a',
  ['Align'] = '<leader>A',
  -- ['Find Under'] = '<C-n>',
  ['Add Cursor Down'] = '<C-Down>',
  ['Add Cursor Up'] = '<C-Up>',
  -- ['Add Cursor Down'] = '<A-j>', -- example: Alt-j instead of <C-Down>
  -- ['Add Cursor Up'] = '<A-k>', -- example: Alt-k instead of <C-Up>
}

if vim.g.vscode then
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })
  -- Move selected lines down in visual modes
  vim.keymap.set('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move lines down', silent = true })

  -- Move selected lines up in visual modes
  vim.keymap.set('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move lines up', silent = true })

  local opts = { noremap = true, silent = true }

  local mappings = {
    -- Word Navigation

    -- Code Navigation

    -- Quick Search & Peek Actions

    -- Line Editing & Code Maintenance

    -- File & Workspace Management
    { 'n', '<leader>rw', 'workbench.action.reloadWindow' },
    { 'n', '<leader>os', 'workbench.action.openSettingsJson' },
    { 'n', '<leader>ok', 'workbench.action.openGlobalKeybindingsFile' },
    -- toggle developer tools
    { 'n', '<leader>od', 'workbench.action.toggleDevTools' },
    -- copy file path to clipboard
    { 'n', '<leader>cp', 'copyRelativeFilePath' },

    -- open file ib currebt project
    { 'n', '<leader>ff', 'workbench.action.quickOpen' },
    -- open recent projects
    { 'n', '<leader>fF', 'workbench.action.openRecent' },
    -- create new file
    -- { 'n', '<leader>fa', 'workbench.action.files.newUntitledFile' },
    { 'n', '<leader>fa', 'fileutils.newFileAtRoot' },
    -- clode active file and all files
    { 'n', '<leader>fx', 'workbench.action.closeActiveEditor' },
    { 'n', '<leader>bd', 'workbench.action.closeActiveEditor' },
    { 'n', '<leader>fq', 'workbench.action.closeAllEditors' },
    { 'n', '<leader>bD', 'workbench.action.closeEditorsInOtherGroups' },
    -- search & replace in current file
    { 'n', '<leader>fg', 'actions.find' },
    { 'n', '<leader>fr', 'editor.action.startFindReplaceAction' },
    -- search and replace globally
    { 'n', '<leader>fG', 'workbench.action.findInFiles' },
    { 'n', '<leader>fR', 'workbench.action.replaceInFiles' },
    -- copy current lines
    { 'n', '<leader>yp', 'editor.action.copyLinesDownAction' },
    { 'n', '<leader>yP', 'editor.action.copyLinesUpAction' },
    -- move current lines
    { 'n', '<leader>dp', 'editor.action.moveLinesDownAction' },
    { 'n', '<leader>dP', 'editor.action.moveLinesUpAction' },
    -- apply code/language formatting
    { 'n', '<leader>cf', 'editor.action.formatDocument' },
    { 'n', '<leader>cF', 'editor.action.formatSelection' },
    -- move to nexrt/previous error or warning
    { 'n', '<leader>en', 'editor.action.marker.next' },
    { 'n', '<leader>ep', 'editor.action.marker.prev' },

    -- Navigation
    { 'n', 'Ctrl+h', 'workbench.action.navigateLeft' },
    { 'n', 'Ctrl+l', 'workbench.action.navigateRight' },
    { 'n', 'Ctrl+k', 'workbench.action.navigateUp' },
    { 'n', 'Ctrl+j', 'workbench.action.navigateDown' },
    -- toggle file explorer
    { 'n', '<leader>e', 'workbench.view.explorer' },
    { 'n', '<leader>e', 'workbench.explorer.fileView.focus' },
    -- toggleTerminal
    { 'n', '<leader>tt', 'workbench.action.terminal.toggleTerminal' },
    { 'n', '<leader>tc', 'workbench.panel.positronConsole.focus' },

    -- Window Management
    { 'n', '<leader>sh', 'workbench.action.splitEditor' },
    { 'n', '<leader>sv', 'workbench.action.splitEditorDown' },
    { 'n', '<leader>sj', 'workbench.action.joinTwoGroups' },
    -- equalize window sizes
    { 'n', '<leader>se', 'workbench.action.evenEditorWidths' },
    -- { 'n', '<leader>wa', 'workbench.action.evenEditorWidths' },
    -- quarto preview
    { 'n', '<leader>qp', 'quarto.preview' }, -- Ctrl+Shift+N
    { 'n', '<leader>qc', 'quarto.runCurrentCell' }, -- Ctrl+Shift+Enter
    { 'n', '<leader>qn', 'quarto.runNextCell' }, -- Ctrl+Alt+N
    { 'n', '<leader>qp', 'quarto.runPreviousCell' }, -- Ctrl+Alt+P
    { 'n', '<leader>qP', 'quarto.runCellsAbove' }, -- Ctrl+Shift+Alt+P
    { 'n', '<leader>qN', 'quarto.runCellsBelow' }, -- Ctrl+Shift+Alt+N
    { 'n', '<leader>qA', 'quarto.runAllCells' }, -- Ctrl+Alt+R
    { 'n', '<leader>qr', 'quarto.renderDocument' },
  }

  for _, mapping in ipairs(mappings) do
    local mode, key, command = mapping[1], mapping[2], mapping[3]
    vim.keymap.set(mode, key, function()
      vim.fn.VSCodeNotify(command)
    end, opts)
  end
  -- Bootstrap lazy.nvim
  require 'config.lazy-bootstrap'
  -- load ONLY the mini-suite (the table returned by lua/plugins/mini.lua)
  -- local mini_spec = require('plugins.mini') -- if only this plugin
  local mini_spec = {
    require 'plugins.mini', -- existing Mini suite
    require 'plugins.vim-visual-multi', -- new plugin added via require
    -- more plugins? just keep adding require('plugins.xxx')
    require 'plugins.flash',
  }
  require('lazy').setup(mini_spec, {
    root = vim.fn.stdpath 'data' .. '/lazy-vscode', -- separate install dir
    defaults = { version = false }, -- same defaults as desktop
  })
--   -- below is common quarto nvim-config
else
  -- NOTE: Throughout this config, some plugins are
  -- disabled by default. This is because I don't use
  -- them on a daily basis, but I still want to keep
  -- them around as examples.
  -- You can enable them by changing `enabled = false`
  -- to `enabled = true` in the respective plugin spec.
  -- Some of these also have the
  -- PERF: (performance) comment, which
  -- indicates that I found them to slow down the config.
  -- (may be outdated with newer versions of the plugins,
  -- check for yourself if you're interested in using them)

  -- vim.treesitter.language.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
  -- vim.treesitter.language.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
  -- vim.treesitter.language.register('pandoc_markdown', { 'quarto', 'rmarkdown' })

  require 'config.global'
  require 'config.lazy'
  require 'config.autocommands'
  require 'config.redir'

  vim.cmd.colorscheme 'oscura'
  vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })
  vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'dimgray', bg = '' })
end
