-- Windows-specific configuration
-- This file contains settings that are specific to Windows environment

if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  -- Set SQLite library path for Windows
  -- Required by some plugins like telescope-frecency
  vim.g.sqlite_clib_path = 'C:\\ProgramData\\chocolatey\\lib\\sqlite\\tools\\sqlite3.dll'
end
