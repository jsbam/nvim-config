-- Custom obsidian.nvim configuration override
-- This overrides the upstream notes.lua to point to OneDrive location
-- Cross-platform: automatically detects Windows vs Mac paths

local onedrive_path
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  onedrive_path = '~/OneDrive - Örebro universitet/SCTO-Obsidian'
else
  onedrive_path = '~/Library/CloudStorage/OneDrive-Örebrouniversitet/SCTO-Obsidian'
end

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
          path = onedrive_path,
        },
      },
    },
  },
}
