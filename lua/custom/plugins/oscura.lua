-- Custom oscura colorscheme override
-- This ensures oscura is enabled in both configs

return {
  {
    'webhooked/oscura.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
