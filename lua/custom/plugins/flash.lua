-- Flash.nvim customization from your old config
-- Quick navigation plugin with 2-character search

return {
  'folke/flash.nvim',
  enabled = true,
  event = 'VeryLazy',
  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      -- search/jump in all windows
      multi_window = true,
      -- search direction
      forward = true,
      -- when false, find only matches in the given direction
      wrap = true,
      -- Each mode will take ignorecase and smartcase into account.
      mode = "exact",
    },
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = "start", ---@type "start" | "end" | "range"
      -- automatically jump when there is only one match
      autojump = false,
    },
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add any labels with the correct case here, that you want to exclude
      exclude = "",
      -- labels appear after the match
      after = true, ---@type boolean|number[]
      before = false, ---@type boolean|number[]
      -- position of the label extmark
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = "lowercase", ---@type "lowercase" | "all" | "none"
    },
    modes = {
      search = {
        enabled = true,
      },
      char = {
        enabled = true,
        jump_labels = true,
        -- Multi-line f/F/t/T
        multi_line = true,
        -- Label configuration - make labels appear AFTER the character
        label = {
          exclude = "hjkliardc",
          after = { 0, 0 }, -- Show label after matched char
          before = false,
          style = "inline", -- or "overlay"
        },
        -- Highlight matches
        highlight = { backdrop = false },
        -- Key mappings
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
          }
        end,
      },
    },
  },
  keys = {
    -- 's' for jumping to line start
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump {
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '^',
        }
      end,
      desc = 'Flash jump to line',
    },
    -- 'S' for treesitter selection
    {
      'S',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
  },
}
