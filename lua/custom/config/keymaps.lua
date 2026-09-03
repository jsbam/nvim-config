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

-- Search and replace word under cursor in current file
vim.keymap.set(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/]],
  { desc = "Replace word under cursor globally in current file" }
)

-- -- Quick save
-- nmap('<C-s>', ':w<cr>', 'Save file')

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

-- Send current code chunk to terminal
nmap('<leader>rc', function()
  vim.fn['slime#send_cell']()
end, 'send [c]ode chunk to terminal')

-- Line joining that keeps cursor position
nmap('J', 'mzJ`z', 'Join lines and keep cursor position')

-- Vim-visual-multi configuration moved to lua/custom/plugins/vim-visual-multi.lua

-- Oil mappings moved to custom keymaps: maximize in float and open in current window
nmap('<leader>e', '<cmd>Oil --float<cr>', 'focus explorer (maximize Oil float)')
nmap('<leader>eo', ':Oil<cr>', 'open Oil in current window')

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

--- Send a complete R expression to the REPL.
--- Detects multi-line expressions by looking for continuation patterns:
---   pipes (|>, %>%), ggplot (+), trailing comma, assignment (<-),
---   and unbalanced brackets/parens/braces.
local function send_r_expression()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(bufnr)

  local lines = {}
  local paren, bracket, brace = 0, 0, 0
  local i = row

  while i <= total do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    table.insert(lines, line)

    -- strip trailing comment (naive: first # outside quotes)
    local code = line:match '^([^#]*)' or line

    for c in code:gmatch '.' do
      if c == '(' then
        paren = paren + 1
      elseif c == ')' then
        paren = paren - 1
      elseif c == '[' then
        bracket = bracket + 1
      elseif c == ']' then
        bracket = bracket - 1
      elseif c == '{' then
        brace = brace + 1
      elseif c == '}' then
        brace = brace - 1
      end
    end

    local trimmed = vim.trim(code)
    local continues = (paren > 0 or bracket > 0 or brace > 0)
        or trimmed:match '|>$'     -- base R pipe
        or trimmed:match '%%>%%$'  -- magrittr pipe
        or trimmed:match '%%<>%%$' -- magrittr assignment pipe
        or trimmed:match '%+$'     -- ggplot +
        or trimmed:match ',$'      -- trailing comma
        or trimmed:match '<%-$'    -- assignment at end of line

    i = i + 1
    if not continues then break end
  end

  local text = table.concat(lines, '\n') .. '\n'
  vim.fn['slime#send'](text)

  -- skip past empty and comment-only lines
  while i <= total do
    local next_line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    local stripped = vim.trim(next_line)
    if stripped == '' or stripped:match '^#' then
      i = i + 1
    else
      break
    end
  end

  vim.api.nvim_win_set_cursor(0, { math.min(i, total), 0 })
end

nmap('<leader>rl', send_r_expression, 'send R e[l]xpression to terminal')

--- Jump to the next code chunk and send it
local function send_next_chunk()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(bufnr)

  -- find next chunk opening: ```{...}
  local i = row + 1
  while i <= total do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match '^```{' then
      -- move cursor inside the chunk (line after opening fence)
      vim.api.nvim_win_set_cursor(0, { math.min(i + 1, total), 0 })
      vim.fn['slime#send_cell']()
      return
    end
    i = i + 1
  end
  vim.notify('No next code chunk found', vim.log.levels.WARN)
end

--- Jump to the previous code chunk and send it
local function send_prev_chunk()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- first, skip past current chunk's opening fence if we're inside one
  local i = row - 1
  while i >= 1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match '^```{' then
      -- found current chunk's opening, start searching above it
      i = i - 1
      break
    elseif line:match '^```$' then
      -- hit a closing fence, we were outside a chunk already
      break
    end
    i = i - 1
  end

  -- find previous chunk opening
  while i >= 1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match '^```{' then
      vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
      vim.fn['slime#send_cell']()
      return
    end
    i = i - 1
  end
  vim.notify('No previous code chunk found', vim.log.levels.WARN)
end

nmap('<leader>rn', send_next_chunk, 'send [n]ext code chunk')
nmap('<leader>rp', send_prev_chunk, 'send [p]revious code chunk')

-- Quarto run overrides
-- Override upstream <leader>qra (was SendAll) to SendAbove
nmap('<leader>qra', ':QuartoSendAbove<cr>', 'run [a]bove (to cursor)')
nmap('<leader>qrA', ':QuartoSendAll<cr>', 'run [A]ll chunks')
nmap('<leader>qrl', ':QuartoSendLine<cr>', 'run [l]ine')
nmap('<leader>qrc', ':QuartoSend<cr>', 'run [c]urrent chunk')
