-- lua/plugins/vim-visual-multi.lua
return {
  'mg979/vim-visual-multi',
  branch = 'master',            -- optional
  init = function()
    vim.g.VM_default_mappings = 0   -- your options here
  end,
}
