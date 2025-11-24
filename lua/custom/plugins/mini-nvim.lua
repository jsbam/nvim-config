-- Mini.nvim suite
-- Loaded with high priority to register 's' keymaps before flash

return {
  'echasnovski/mini.nvim',
  version = false,
  priority = 1000, -- Load before flash
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    
    -- Auto pairs
    require('mini.pairs').setup()
    
    -- Comment
    require('mini.comment').setup()
  end,
}
