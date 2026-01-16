-- Override Mason tool installer to exclude tools from Mason on Windows
-- These are installed via system package managers instead
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  opts = function(_, opts)
    -- Remove certain tools from Mason's ensure_installed list on Windows
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      if opts.ensure_installed then
        local skip_tools = { 'stylua' }
        opts.ensure_installed = vim.tbl_filter(function(tool)
          return not vim.tbl_contains(skip_tools, tool)
        end, opts.ensure_installed)
      end
    end
    return opts
  end,
}
