return {
  "smart-splits-nvim/smart-splits.nvim",
  version = '^2',
  lazy = false,
  priority = 1000,
  build = './kitty/install-kittens.bash',
  config = function()
    local smart_splits = require('smart-splits')

    smart_splits.setup({
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
      multiplexer_integration = 'wezterm',
      at_edge = 'wrap',
    })

    local function set_navigation_keymaps()
      vim.keymap.set({ "n", "t" }, "<C-h>", smart_splits.move_cursor_left, { desc = "Move left" })
      vim.keymap.set({ "n", "t" }, "<C-j>", smart_splits.move_cursor_down, { desc = "Move down" })
      vim.keymap.set({ "n", "t" }, "<C-k>", smart_splits.move_cursor_up, { desc = "Move up" })
      vim.keymap.set({ "n", "t" }, "<C-l>", smart_splits.move_cursor_right, { desc = "Move right" })
    end

    set_navigation_keymaps()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = set_navigation_keymaps,
    })

    -- Resize splits with Alt+Shift+hjkl
    vim.keymap.set("n", "<A-S-h>", smart_splits.resize_left, { desc = "Resize left" })
    vim.keymap.set("n", "<A-S-j>", smart_splits.resize_down, { desc = "Resize down" })
    vim.keymap.set("n", "<A-S-k>", smart_splits.resize_up, { desc = "Resize up" })
    vim.keymap.set("n", "<A-S-l>", smart_splits.resize_right, { desc = "Resize right" })
  end,
}
