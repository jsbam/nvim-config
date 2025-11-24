-- Custom lualine configuration
-- This overrides the upstream lualine config from lua/plugins/ui.lua

return {
  { -- statusline
    'nvim-lualine/lualine.nvim',
    enabled = true,
    config = function()
      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg == '' then
          return ''
        end
        return '📷[' .. reg .. ']'
      end

      ---@diagnostic disable-next-line: undefined-field
      require('lualine').setup {
        options = {
          theme = 'oscura',
          icon_enabled = true,
          section_separators = { left = '', right = '' },
          component_separators = '|',
          globalstatus = true,
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { 'mode', macro_recording },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              file_status = true,
              path = 1,
              fmt = function(str)
                if vim.bo.filetype == 'oil' then
                  return '' -- show nothing for oil buffer name
                end
                -- Clean up "oil://" and shorten to just folder name
                str = str:gsub('^oil://', '')
                local tail = str:match '([^/]+)/?$'
                return tail or str
              end,
            },
            'searchcount',
          },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        extensions = { 'nvim-tree' },
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
