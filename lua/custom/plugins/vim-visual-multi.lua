-- Vim Visual Multi - Multiple cursors plugin
-- This adds multiple cursor support similar to VSCode

return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    -- Must be set BEFORE plugin loads
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ['Find Under'] = '<C-n>',
      ['Find Subword Under'] = '<C-n>',
      ['Select All'] = '<leader>a',
      ['Visual All'] = '<leader>a',
      ['Align'] = '<leader>A',
      ['Add Cursor Down'] = '<C-Down>',
      ['Add Cursor Up'] = '<C-Up>',
      -- Disable C-v related mappings
      ['Switch Mode'] = '',
      ['Visual Cursors'] = '',
      ['Visual Add'] = '',
      ['Visual Find'] = '',
      ['Visual Regex'] = '',
    }
  end,
}
