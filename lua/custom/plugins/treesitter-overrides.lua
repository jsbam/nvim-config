-- Override treesitter configuration to exclude unsupported parsers on Windows
return {
  'nvim-treesitter/nvim-treesitter',
  opts = function(_, opts)
    -- Skip norg parser on Windows as it's not supported
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      -- This will prevent the warning about unsupported language
      return opts
    end
    return opts
  end,
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}
    
    -- Install parsers, excluding norg on Windows
    local parsers = {
      'r',
      'python',
      'markdown',
      'markdown_inline',
      'julia',
      'bash',
      'yaml',
      'lua',
      'vim',
      'query',
      'vimdoc',
      'latex',
      'html',
      'css',
      'dot',
      'javascript',
      'mermaid',
      'typescript',
    }
    
    -- Add norg only on non-Windows systems
    if vim.fn.has('win32') == 0 and vim.fn.has('win64') == 0 then
      table.insert(parsers, 'norg')
    end
    
    ts.install(parsers)
  end,
}
