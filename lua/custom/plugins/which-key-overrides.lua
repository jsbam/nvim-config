-- Custom which-key overrides
-- Restrict triggers to avoid C-v delay for visual block mode

return {
  'folke/which-key.nvim',
  config = function(_, opts)
    -- Merge our triggers with any existing opts
    opts = opts or {}
    opts.triggers = {
      { '<leader>', mode = { 'n', 'v' } },
      { 'g', mode = { 'n', 'v' } },
      { 'z', mode = { 'n', 'v' } },
      { '[', mode = { 'n', 'v' } },
      { ']', mode = { 'n', 'v' } },
    }
    require('which-key').setup(opts)
    require 'config.keymap'
  end,
}
