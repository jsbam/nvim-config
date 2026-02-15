return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",   -- Optional: defer loading for performance
    config = function()
      -- Option 1: Use defaults (no extra settings needed)
      -- Option 2: Set up via global vim variable
      vim.g.rainbow_delimiters = {
        strategy = {
          -- [''] = 'rainbow-delimiters.strategy.global',
          -- vim = 'rainbow-delimiters.strategy.local',
          [''] = 'rainbow-delimiters.strategy.local',
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        -- Example: disable for C/C++
        blacklist = {'c', 'cpp'},
      }

      -- Optional: use the setup module instead
      -- require('rainbow-delimiters.setup').setup(vim.g.rainbow_delimiters)
    end,
  },
}
