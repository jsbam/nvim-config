-- Override Mason plugins and LSP config on Windows
-- These servers/tools are installed via system package managers instead

local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1

-- Windows-specific R language server config
-- Set via autocmd to ensure it runs before LSP attaches
if is_windows then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'r', 'rmd', 'rmarkdown' },
    once = true,
    callback = function()
      vim.lsp.config.r_language_server = {
        cmd = {
          'C:/Program Files/R/R-4.5.2/bin/Rscript.exe',
          '-e',
          '.libPaths(c("C:/Users/jsh001/AppData/Local/R/win-library/4.5", "C:/Program Files/R/R-4.5.2/library")); languageserver::run()',
        },
        filetypes = { 'r', 'rmd', 'rmarkdown' },
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
            },
          },
        },
      }
    end,
  })
end

return {
  -- LSP servers to exclude from mason-lspconfig
  {
    'mason-org/mason-lspconfig.nvim',
    opts = function(_, opts)
      if is_windows and opts.ensure_installed then
        local skip_servers = { 'r_language_server', 'clangd', 'lua_ls', 'texlab' }
        opts.ensure_installed = vim.tbl_filter(function(server)
          return not vim.tbl_contains(skip_servers, server)
        end, opts.ensure_installed)
      end
      return opts
    end,
  },

  -- Tools to exclude from mason-tool-installer
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      if is_windows and opts.ensure_installed then
        local skip_tools = { 'stylua' }
        opts.ensure_installed = vim.tbl_filter(function(tool)
          return not vim.tbl_contains(skip_tools, tool)
        end, opts.ensure_installed)
      end
      return opts
    end,
  },

}
