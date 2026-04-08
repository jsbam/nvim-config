return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
      },
      { 'nvim-telescope/telescope-dap.nvim' },
      {
        'jmbuhr/telescope-zotero.nvim',
        dev = false,
        dependencies = {
          { 'kkharji/sqlite.lua' },
        },
        config = function()
          local zotero = require 'zotero'

          local collection = nil
          if vim.fn.getcwd():match 'phd%-thesis' then
            collection = 'phd-thesis'
          end

          zotero.setup {
            collection = collection,
          }
          vim.keymap.set('n', '<leader>fz', ':Telescope zotero<cr>', { desc = '[z]otero' })
        end,
      },
    },
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local previewers = require 'telescope.previewers'
      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        filepath = vim.fn.expand(filepath)
        vim.uv.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end

      local telescope_config = require 'telescope.config'
      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
      -- I don't want to search in the `docs` directory (rendered quarto output).
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!docs/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!_site/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!_reference/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!_inv/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!*_files/libs/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!.obsidian/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!.quarto/*')

      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!_freeze/*')

      telescope.setup {
        defaults = {
          buffer_previewer_maker = new_maker,
          vimgrep_arguments = vimgrep_arguments,
          file_ignore_patterns = {
            'node%_modules',
            '%_cache',
            '%.git/',
            'site%_libs',
            '%.venv/',
            '%_files/libs/',
            '%.obsidian/',
            '%.quarto/',
            '%_freeze/',
          },
          layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<esc>'] = actions.close,
              ['<c-j>'] = actions.move_selection_next,
              ['<c-k>'] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            find_command = {
              'rg',
              '--files',
              '--hidden',
              -- '--no-ignore',
              '--glob',
              '!.git/*',
              '--glob',
              '!**/.Rpro.user/*',
              '--glob',
              '!_site/*',
              '--glob',
              '!docs/**/*.html',
              '-L',
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'dap'
      telescope.load_extension 'zotero'
    end,
  },
}
