return {
  'folke/flash.nvim',
  enabled = true,
  event = 'VeryLazy',
  opts = {
    modes = {
      search = {
        enabled = true,
      },
      char = {
        jump_labels = true,
      },
    },
  },
  keys = {
    -- { -- f/F/t/T was as well
    --   's',
    --   mode = { 'n', 'x', 'o' },
    --   function()
    --     require('flash').jump {
    --       continue = true,
    --     }
    --   end,
    -- },
    {
      'S',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter()
      end,
    },
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
    },
  },
}
