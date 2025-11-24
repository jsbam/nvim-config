-- Vim Visual Multi - Multiple cursors plugin
-- This adds multiple cursor support similar to VSCode

return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    -- Configuration is loaded from lua/custom/config/options.lua
    -- where VM_maps is set
  end,
}
