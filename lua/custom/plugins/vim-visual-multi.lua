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
      ['Align'] = '',
      ['Add Cursor Down'] = '<C-Down>',
      ['Add Cursor Up'] = '<C-Up>',
      ['Start Regex Search'] = '',
      ['Toggle Single Region'] = 'q',
      ['Skip Region'] = 'n',
      ['Remove Region'] = 'x',
      -- Visual mode mappings (disabled, using direct <Plug> mappings below)
      ['Visual Cursors'] = '',
      ['Visual Add'] = '',
      ['Switch Mode'] = '',
      ['Visual Find'] = '',
      ['Visual Regex'] = '',
    }
  end,
  config = function()
    -- Setup which-key mappings for vim-visual-multi
    local wk = require('which-key')
    wk.add({
      { "<leader>m", group = "vim-visual-multi" },
      { "<leader>ma", "<Plug>(VM-Select-All)", desc = "Select all occurrences" },
      { "<leader>mn", "<Plug>(VM-Find-Under)", desc = "Find under cursor" },
      { "<leader>mp", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add cursor at position" },
      { "<leader>md", "<C-Down>", desc = "Add cursor down" },
      { "<leader>mt", "<Plug>(VM-Toggle-Multiline)", desc = "Toggle multiline mode" },
      { "<leader>mr", "<Plug>(VM-Start-Regex-Search)", desc = "Start regex search" },
      { "<leader>m=", "<Plug>(VM-Align)", desc = "Align cursors" },
      { "<leader>mv", "<Plug>(VM-Visual-Cursors)", desc = "Enter VM from visual mode", mode = "x" },
    })
  end,
}
