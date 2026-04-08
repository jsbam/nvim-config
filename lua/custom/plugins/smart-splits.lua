return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  priority = 1000,
  build = './kitty/install-kittens.bash',
  config = function()
    local smart_splits = require('smart-splits')
    
    -- Helper to check if we're in WezTerm
    local function is_wezterm()
      return os.getenv('WEZTERM_PANE') ~= nil
    end
    
    -- Helper to navigate with WezTerm CLI when at edge
    local function move_with_wezterm(direction)
      if is_wezterm() then
        local wezterm_dir = ({
          h = 'Left',
          j = 'Down', 
          k = 'Up',
          l = 'Right'
        })[direction]
        os.execute('wezterm cli activate-pane-direction ' .. wezterm_dir)
      end
    end

    smart_splits.setup({
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
      at_edge = 'stop',  -- Stop at edge, don't wrap
    })

    -- Custom navigation that falls back to WezTerm
    local function smart_move(direction)
      return function()
        local ok = smart_splits['move_cursor_' .. ({h='left',j='down',k='up',l='right'})[direction]]()
        -- If we couldn't move (at edge), try WezTerm
        if not ok then
          move_with_wezterm(direction)
        end
      end
    end

    -- Navigation with Ctrl+hjkl
    vim.keymap.set({ "n", "t" }, "<C-h>", smart_move('h'), { desc = "Move left" })
    vim.keymap.set({ "n", "t" }, "<C-j>", smart_move('j'), { desc = "Move down" })
    vim.keymap.set({ "n", "t" }, "<C-k>", smart_move('k'), { desc = "Move up" })
    vim.keymap.set({ "n", "t" }, "<C-l>", smart_move('l'), { desc = "Move right" })
    
    -- Resize splits with Alt+Shift+hjkl
    vim.keymap.set("n", "<A-S-h>", smart_splits.resize_left, { desc = "Resize left" })
    vim.keymap.set("n", "<A-S-j>", smart_splits.resize_down, { desc = "Resize down" })
    vim.keymap.set("n", "<A-S-k>", smart_splits.resize_up, { desc = "Resize up" })
    vim.keymap.set("n", "<A-S-l>", smart_splits.resize_right, { desc = "Resize right" })
  end,
}
