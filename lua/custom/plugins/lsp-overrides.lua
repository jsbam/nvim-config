-- Override LSP configuration to exclude r_language_server from Mason on Windows
-- r_language_server is installed via R's package manager instead
return {
  'mason-org/mason-lspconfig.nvim',
  opts = function(_, opts)
    -- Remove r_language_server from Mason's ensure_installed list on Windows
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      if opts.ensure_installed then
        opts.ensure_installed = vim.tbl_filter(function(server)
          return server ~= 'r_language_server'
        end, opts.ensure_installed)
      end
    end
    return opts
  end,
}
