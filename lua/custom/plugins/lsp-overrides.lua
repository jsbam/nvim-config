-- Override LSP configuration to exclude servers from Mason on Windows
-- These are installed via system package managers instead
return {
  'mason-org/mason-lspconfig.nvim',
  opts = function(_, opts)
    -- Remove certain servers from Mason's ensure_installed list on Windows
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      if opts.ensure_installed then
        local skip_servers = { 'r_language_server', 'clangd', 'lua_ls', 'texlab' }
        opts.ensure_installed = vim.tbl_filter(function(server)
          return not vim.tbl_contains(skip_servers, server)
        end, opts.ensure_installed)
      end
    end
    return opts
  end,
}
