-- Override upstream presenterm.nvim to disable on Windows
-- Due to LuaRocks path concatenation issues with Cygwin/Git Bash
return {
  "Piotr1215/presenterm.nvim",
  enabled = vim.fn.has('win32') == 0,
}
