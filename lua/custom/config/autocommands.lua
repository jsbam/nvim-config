-- -- format on save using efm langserver and configured formatters
-- local lsp_fmt_group = vim.api.nvim_create_augroup("FormatOnSaveGroup", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = lsp_fmt_group,
-- 	callback = function() -- install efm formater.
-- 		local efm = vim.lsp.get_clients({ name = "efm" })
-- 		if vim.tbl_isempty(efm) then
-- 			return
-- 		end
-- 		vim.lsp.buf.format({ name = "efm", async = true })
-- 	end,
-- })

-- fyle type to .tmpl files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.tmpl' },
  callback = function(args)
    local fname = vim.fn.fnamemodify(args.file, ':t')
    local match = fname:match '.*%.([a-zA-Z0-9_-]+)%.tmpl$'
    if match then
      vim.bo.filetype = match
    end
  end,
})
-- template for .zshrc and .bashrc files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'shell-common.tmpl',
  callback = function(args)
    vim.bo[args.buf].filetype = 'sh'
  end,
})

-- Custom highlights for oscura theme
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'oscura',
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#75715E' })
    -- vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff', bold = true })
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#75715E', italic = true })
  end,
})
