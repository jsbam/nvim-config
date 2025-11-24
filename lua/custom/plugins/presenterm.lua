-- Custom presenterm.nvim configuration override
-- This overrides the upstream presenterm.lua to disable on Windows
-- due to LuaRocks path handling issues with Cygwin/Git Bash

return {
  {
    'Piotr1215/presenterm.nvim',
    -- Disable on Windows due to LuaRocks path concatenation issues
    enabled = false,
  },
}
