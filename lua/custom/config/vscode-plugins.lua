-- VSCode-specific plugin configuration
-- These plugins will only load in VSCode

if not vim.g.vscode then
  return
end

-- Bootstrap lazy.nvim if not already done
local lazypath = vim.fn.stdpath 'data' .. '/lazy-vscode/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load VSCode-specific plugins
local vscode_plugins = {
  -- Mini suite
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()
      -- require('mini.comment').setup()
    end,
  },

  -- Vim visual multi (multiple cursors)
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Must be set BEFORE plugin loads
      vim.g.VM_default_mappings = 0
      vim.g.VM_quit_after_leaving_insert_mode = 0
      vim.g.VM_maps = vim.tbl_extend('force', vim.g.VM_maps or {}, {
        ['Exit'] = '<Esc><Esc>',
        ['Find Under'] = '<C-n>',
        ['Find Subword Under'] = '<C-n>',
        -- ['Select All'] = '<leader>ma',
        -- ['Visual All'] = '<leader>ma',
        -- Avoid mapping bare [ and ] to Lua callbacks (shows errors in :VMDebug)
        ['Goto Prev'] = '',
        ['Goto Next'] = '',
        ['Align'] = '<leader>m=',
        ['Add Cursor Down'] = '<C-d>',
        ['Add Cursor Up'] = '<C-u>',
        ['Switch Mode'] = '<Tab>',
        ['Remove Region'] = 'Q',             -- remove current cursor position, move cursor backward.
        ['Skip Region'] = 'q',               -- skip current cursor position.
        ['Mouse Cursor'] = '<C-LeftMouse>',  -- add VM-cursor with mouse click
        ['Mouse Column'] = '<C-RightMouse>', -- add VM-cursor to column with mouse click
        ['Move Right'] = '<S-Right>',
        ['Move Left'] = '<S-Left>',
        -- Visual mode mappings (disabled, using direct <Plug> mappings below)
        ['Toggle Single Region'] = '',
        ['Visual Cursors'] = '',
        ['Visual Add'] = '',
        ['Visual Find'] = '',
        ['Visual Regex'] = '',

      })
    end,
    config = function()
      local function vm_visual_insert(kind)
        local replace = vim.api.nvim_replace_termcodes
        vim.api.nvim_feedkeys(replace('<Plug>(VM-Visual-Cursors)', true, false, true), 'x', false)
        vim.defer_fn(function()
          vim.api.nvim_feedkeys(replace('<Plug>(VM-' .. kind .. ')', true, false, true), 'n', false)
        end, 25)
      end

      local function vm_visual_end_mode()
        local replace = vim.api.nvim_replace_termcodes
        vm_visual_insert("A")
        vim.defer_fn(function()
          vim.api.nvim_feedkeys(replace("<Esc>", true, false, true), "n", false)
        end, 60)
      end

      -- from V-line to V-block visual mode, then multi-cursors in insert at line end/start of the lines
      vim.keymap.set('x', '<leader>mA', function()
        vm_visual_insert 'A'
      end, { desc = 'Multi-cursor append at line end' })

      vim.keymap.set('x', '<leader>mI', function()
        vm_visual_insert 'I'
      end, { desc = 'Multi-cursor insert at line start' })

      vim.keymap.set('x', '<leader>mv', function()
        vm_visual_end_mode()
      end, { desc = 'Multi-cursor at line end (VM mode)' })


      vim.keymap.set('n', '<leader>ma', '<Plug>(VM-Select-All)<Tab>', {
        remap = true,
        desc = 'Select [a]ll',
      })
      vim.keymap.set('n', '<leader>mr', '<Plug>(VM-Start-Regex-Search)', {
        remap = true,
        desc = 'Start [r]egex Search',
      })
      vim.keymap.set('n', '<leader>mp', '<Plug>(VM-Add-Cursor-At-Pos)', {
        remap = true,
        desc = 'Add Cursor At [p]osition',
      })
      -- Use <leader>mo if to togle VM keymaps on/off while on active moe
      -- Use if, while VM is active, you need normal keys for a moment (or want VM keys back again)
      vim.keymap.set('n', '<leader>mo', '<Plug>(VM-Toggle-Mappings)', {
        remap = true,
        desc = 'Toggle Mapping',
      })
    end,
  },

  -- Flash (quick navigation)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = true,
        },
        char = {
          jump_labels = true,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
}

require('lazy').setup(vscode_plugins, {
  root = vim.fn.stdpath 'data' .. '/lazy-vscode',
  defaults = { version = false },
})
