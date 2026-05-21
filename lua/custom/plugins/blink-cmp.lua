return {

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
      { 'moyiz/blink-emoji.nvim' },
      { 'Kaiser-Yang/blink-cmp-git' },
      { 'nvim-tree/nvim-web-devicons' },
      {
        'jmbuhr/cmp-pandoc-references',
        ft = { 'markdown', 'quarto', 'rmarkdown' },
      },
      {
        'saghen/blink.compat',
        opts = {
          impersonate_nvim_cmp = true,
          enable_events = true,
        },
      },
      { 'kdheepak/cmp-latex-symbols' },
      { 'erooke/blink-cmp-latex' },
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<c-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-Space>'] = { 'show', 'hide' },
      },
      cmdline = {
        enabled = true,
      },
      appearance = { nerd_font_variant = 'mono' },

      completion = {
        documentation = {
          auto_show = true,
          window = {
            border = 'rounded',
          },
          treesitter_highlighting = true,
        },
        menu = {
          auto_show = true,
          border = 'rounded',
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'references', 'git', 'emoji', 'latex' },
        providers = {
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = -1,
            enabled = function()
              return vim.tbl_contains({ 'markdown', 'quarto' }, vim.bo.filetype)
            end,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            opts = {},
            enabled = function()
              return vim.tbl_contains({ 'octo', 'gitcommit', 'git' }, vim.bo.filetype)
            end,
          },
          references = {
            name = 'pandoc_references',
            module = 'cmp-pandoc-references.blink',
            score_offset = 2,
          },
          symbols = { name = 'symbols', module = 'blink.compat.source' },
          latex = {
            name = 'Latex',
            module = 'blink-cmp-latex',
            opts = {
              insert_command = function(ctx)
                local ft = vim.api.nvim_get_option_value('filetype', {
                  scope = 'local',
                  buf = ctx.bufnr,
                })
                if ft == 'tex' or ft == 'latex' then
                  return true
                end
                return false
              end,
            },
          },
        },
      },
      signature = { enabled = true },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
