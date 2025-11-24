-- Custom obsidian.nvim configuration override
-- This overrides the upstream notes.lua to point to OneDrive location

return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    enabled = true,
    lazy = false,
    ft = 'markdown',
    opts = {
      workspaces = {
        {
          name = 'scto',
          path = '~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian',
        },
      },
    },
  },
}
