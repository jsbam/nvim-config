-- Custom plugin configuration overrides
-- This file contains modifications to upstream plugin configurations

return {
  -- Oil.nvim customizations
  oil = {
    enabled = true,
    lazy = false,
    keymaps = {
      ['sh'] = 'actions.select_split',
      ['sv'] = 'actions.select_vsplit',
    },
    win_options = {
      winbar = '%#Bold#%{v:lua._G.oil_home_path()}',
    },
    -- Global helper function for oil winbar
    setup_helpers = function()
      _G.oil_home_path = function()
        local oil = require 'oil'
        local dir = oil.get_current_dir()
        if not dir then
          return ''
        end
        dir = dir:gsub(vim.fn.getenv 'HOME', '~')
        return dir
      end
    end,
  },

  -- Lualine customizations
  lualine = {
    enabled = true,
    options = {
      theme = 'oscura',
      icon_enabled = true,
      section_separators = { left = '', right = '' },
      component_separators = '|',
    },
    sections_c_override = {
      {
        'filename',
        file_status = true,
        path = 1,
        fmt = function(str)
          if vim.bo.filetype == 'oil' then
            return ''
          end
          str = str:gsub('^oil://', '')
          local tail = str:match '([^/]+)/?$'
          return tail or str
        end,
      },
    },
  },

  -- Conform.nvim (formatter) customizations
  conform = {
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    formatters_override = {
      r = { 'air' }, -- Use 'air' instead of 'styler' for R
    },
  },

  -- Monokai-pro theme with transparency toggle
  monokai_pro = {
    enabled = true,
    transparent_background = false,
    keybind = '<leader>bg', -- Toggle transparency
  },
}
