---@diagnostic disable: undefined-global
return {
  {
    'nvim-treesitter/nvim-treesitter',
    dev = false,
    branch = 'main',

    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
          -- Disable entire built-in ftplugin mappings to avoid conflicts.
          -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
          vim.g.no_plugin_maps = true

          -- Or, disable per filetype (add as you like)
          -- vim.g.no_python_maps = true
          -- vim.g.no_ruby_maps = true
          -- vim.g.no_rust_maps = true
          -- vim.g.no_go_maps = true
        end,
        config = function()
          require('nvim-treesitter-textobjects').setup {
            select = {
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
            },
          }

          local select = require('nvim-treesitter-textobjects.select').select_textobject
          local move = require 'nvim-treesitter-textobjects.move'

          -- Helper to create select keymaps
          local function map_select(keys, query, group)
            vim.keymap.set({ 'x', 'o' }, keys, function()
              select(query, group or 'textobjects')
            end)
          end

          -- Helper to create move keymaps
          local function map_move(keys, fn_name, query, group)
            vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
              move[fn_name](query, group or 'textobjects')
            end)
          end

          -- Select keymaps
          map_select('am', '@function.outer') -- around method/function
          map_select('im', '@function.inner') -- inner method/function
          map_select('ac', '@class.outer') -- around class
          map_select('ic', '@class.inner') -- inner class
          map_select('as', '@local.scope', 'locals') -- around scope

          -- Move keymaps
          map_move(']m', 'goto_next_start', '@function.outer') -- next function start
          map_move('[m', 'goto_previous_start', '@function.outer') -- previous function start
          map_move(']M', 'goto_next_end', '@function.outer') -- next function end
          map_move('[M', 'goto_previous_end', '@function.outer') -- previous function end
          map_move(']]', 'goto_next_start', '@class.inner') -- next class start
          map_move('[[', 'goto_previous_start', '@class.inner') -- previous class start
          map_move('][', 'goto_next_end', '@class.inner') -- next class end
          map_move('[]', 'goto_previous_end', '@class.inner') -- previous class end
          map_move(']s', 'goto_next_start', '@local.scope', 'locals') -- next scope start
          map_move(']o', 'goto_next_start', { '@loop.inner', '@loop.outer' }) -- next loop start
          map_move(']z', 'goto_next_start', '@fold', 'folds') -- next fold start
        end,
      },
    },

    run = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ---@diagnostic disable-next-line: missing-fields
      ts.setup {}
      ts.install {
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
        'latex', -- requires tree-sitter-cli (installed automatically via Mason)
        'html',
        'css',
        'dot',
        'javascript',
        'mermaid',
        'typescript',
      }
    end,
  },
}
