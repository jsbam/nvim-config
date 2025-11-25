-- Oil.nvim customization from your old config
-- This overrides jmbuhr's oil.nvim settings with your preferences

return {
  'stevearc/oil.nvim',
  enabled = true,
  lazy = false,
  opts = {
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['sh'] = 'actions.select_split',
      ['sv'] = 'actions.select_vsplit',
    },
    view_options = {
      show_hidden = true,
    },
    win_options = {
      -- Show the current directory with $HOME replaced by '~' and make it bold
      winbar = '%#Bold#%{v:lua._G.oil_home_path()}',
    },
  },
  config = function(_, opts)
    -- Global helper to return the path with $HOME replaced by '~'
    _G.oil_home_path = function()
      local dir = require('oil').get_current_dir()
      if not dir then
        return ''
      end
      dir = dir:gsub(vim.fn.getenv 'HOME', '~')
      return dir
    end

    require('oil').setup(opts)
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', ':Oil<cr>', desc = 'oil' },
    { '<leader>ef', ':Oil<cr>', desc = 'edit [f]iles' },
  },
  cmd = 'Oil',
}
