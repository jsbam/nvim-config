-- VSCode-specific plugin configuration
-- These plugins will only load in VSCode

if not vim.g.vscode then
  return
end

-- Bootstrap lazy.nvim if not already done
local lazypath = vim.fn.stdpath 'data' .. '/lazy-vscode/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load VSCode-specific plugins
local vscode_plugins = {
  -- Mini suite
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.comment').setup()
    end,
  },

  -- Vim visual multi (multiple cursors)
  {
    'mg979/vim-visual-multi',
    branch = 'master',
  },

  -- Flash (quick navigation)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        char = {
          jump_labels = true,
          multi_line = true,
          highlight = { backdrop = false },
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
    },
  },
}

require('lazy').setup(vscode_plugins, {
  root = vim.fn.stdpath 'data' .. '/lazy-vscode',
  defaults = { version = false },
})
