-- Custom LSP configuration override
-- This overrides the upstream lsp.lua to remove r-languageserver from Mason
-- due to PowerShell installation failures on Windows
-- The R languageserver is installed system-wide via R's package manager instead

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        opts = {
          ensure_installed = {
            'lua_ls',
            'bashls',
            'cssls',
            'html',
            'pyright',
            -- 'r_language_server', -- Removed: Use system-wide R languageserver instead
            'texlab',
            'dotls',
            'svelte',
            'ts_ls',
            'yamlls',
            'clangd',
          },
        },
      },
    },
  },
}
