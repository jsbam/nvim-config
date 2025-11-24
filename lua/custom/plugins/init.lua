-- Custom Plugins
-- This file exports all custom plugins for lazy.nvim to load

return {
  -- Custom plugin overrides (modify upstream plugin behavior)
  require 'custom.plugins.lualine',
  require 'custom.plugins.blink-cmp',
  require 'custom.plugins.obsidian',
  require 'custom.plugins.presenterm',
  require 'custom.plugins.lsp-overrides',
  require 'custom.plugins.oscura',
  
  -- Custom plugins (not in upstream)
  require 'custom.plugins.bufferline',
  require 'custom.plugins.flash',
  require 'custom.plugins.vim-visual-multi',
  require 'custom.plugins.rainbow-delilimiters',

  -- Monokai-pro theme with transparency toggle
  {
    'loctvl842/monokai-pro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require 'monokai-pro'
      local transparent = false

      local function apply_theme()
        monokai.setup {
          transparent_background = transparent,
          terminal_colors = true,
          devicons = true,
          styles = {
            comment = { italic = true },
            keyword = { italic = true },
            type = { italic = true },
            storageclass = { italic = true },
            structure = { italic = true },
            parameter = { italic = true },
            annotation = { italic = true },
            tag_attribute = { italic = true },
          },
          filter = 'pro',
          background_clear = {
            'float_win',
            'toggleterm',
            'telescope',
            'which-key',
            'renamer',
            'notify',
          },
          plugins = {
            bufferline = {
              underline_selected = false,
              underline_visible = false,
            },
            indent_blankline = {
              context_highlight = 'default',
              context_start_underline = false,
            },
          },
          override = function(colors)
            return {}
          end,
        }
        vim.cmd.colorscheme 'monokai-pro'
      end

      apply_theme()

      local function toggle_transparency()
        transparent = not transparent
        apply_theme()
        vim.notify('Monokai‑Pro transparency: ' .. (transparent and 'ON' or 'OFF'))
      end

      vim.keymap.set('n', '<leader>bg', toggle_transparency, { desc = 'Toggle transparency bg' })
    end,
  },
}
