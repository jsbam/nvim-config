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
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_add_cursor_at_pos_no_mappings = 1
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
        ['Remove Region'] = 'Q', -- remove current cursor position, move cursor backward.
        ['Skip Region'] = 'q', -- skip current cursor position.
        ['Mouse Cursor'] = '<C-LeftMouse>', -- add VM-cursor with mouse click
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
        vm_visual_insert 'A'
        vim.defer_fn(function()
          vim.api.nvim_feedkeys(replace('<Esc>', true, false, true), 'n', false)
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
      -- to make S-arrows to move VM-multi-cursors
      vim.keymap.set('n', '<S-Up>', '<Plug>(VM-Motion-k)', { remap = true })
      vim.keymap.set('n', '<S-Down>', '<Plug>(VM-Motion-j)', { remap = true })
      vim.keymap.set('n', '<S-Left>', '<Plug>(VM-Motion-h)', { remap = true })
      vim.keymap.set('n', '<S-Right>', '<Plug>(VM-Motion-l)', { remap = true })
    end,
  },

  -- Flash (quick navigation)
  {
    'folke/flash.nvim',
    enabled = true,
    event = 'VeryLazy',
    --@type Flash.config
    opts = {
      labels = 'asdfghjklqwertyuiopzxcvbnm',
      search = {
        -- search/jump in all windows
        multi_window = true,
      },
      jump = {
        -- save location in the jumplist
        jumplist = true,
      },
      label = {
        -- allow uppercase labels
        uppercase = true,
        -- add any labels with the correct case here, that you want to exclude
        exclude = '',
        -- labels appear after the match
        after = true, ---@type boolean|number[]
        before = false, ---@type boolean|number[]
      },
      modes = {
        search = {
          enabled = true,
        },
        char = {
          enabled = true,
          jump_labels = true,
          -- Multi-line f/F/t/T
          multi_line = true,
          -- Label configuration - make labels appear AFTER the character
          label = {
            exclude = 'hjkliardc',
            after = { 0, 0 }, -- Show label after matched char
            before = false,
            style = 'inline', -- or "overlay"
          },
          -- Highlight matches
          highlight = { backdrop = true },
          -- Key mappings
          keys = { 'f', 'F', 't', 'T', ';', ',' },
        },
      },
    },
    keys = {
      -- 's' for jumping to line start
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump {
            search = { mode = 'search', max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = '^',
          }
        end,
        desc = 'Flash jump to line',
      },
      -- 'S' for treesitter selection
      {
        'S',
        mode = { 'n', 'o', 'x' },
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
        desc = 'Toggle Flash search',
      },
    },
  },

  {
    'nvim-mini/mini.jump2d',
    version = '*',
    config = function()
      require('mini.jump2d').setup {}
      vim.keymap.set({ 'n', 'x', 'o' }, 'z', '<Cmd>lua MiniJump2d.start()<CR>', { desc = 'Jump via mini.jump2d' })
    end,
  },

  {
    'kevinhwang91/nvim-hlslens',
    event = 'VeryLazy',

    opts = {
      -- override_lens = function(render, posList, nearest, idx, relIdx)
      -- 	local sfw = vim.v.searchforward == 1
      -- 	local indicator
      -- 	local text
      -- 	local chunks
      -- 	local absRelIdx = math.abs(relIdx)
      --
      -- 	if absRelIdx > 1 then
      -- 		indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
      -- 	elseif absRelIdx == 1 then
      -- 		indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
      -- 	else
      -- 		indicator = ""
      -- 	end
      --
      -- 	local lnum, col = unpack(posList[idx])
      --
      -- 	if nearest then
      -- 		local cnt = #posList
      --
      -- 		if indicator ~= "" then
      -- 			text = ("[%s %d/%d]"):format(indicator, idx, cnt)
      -- 		else
      -- 			text = ("[%d/%d]"):format(idx, cnt)
      -- 		end
      --
      -- 		chunks = {
      -- 			{ " " },
      -- 			{ text, "HlSearchLensNear" },
      -- 		}
      -- 	else
      -- 		text = ("[%s %d]"):format(indicator, idx)
      --
      -- 		chunks = {
      -- 			{ " " },
      -- 			{ text, "HlSearchLens" },
      -- 		}
      -- 	end
      --
      -- 	render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      -- end,
    },

    config = function(_, opts)
      require('hlslens').setup(opts)

      local map = vim.keymap.set

      map('n', 'n', function()
        vim.cmd('normal! ' .. vim.v.count1 .. 'n')
        require('hlslens').start()
      end, { silent = true, desc = 'Next search result' })

      map('n', 'N', function()
        vim.cmd('normal! ' .. vim.v.count1 .. 'N')
        require('hlslens').start()
      end, { silent = true, desc = 'Previous search result' })

      map('n', '*', function()
        vim.cmd 'normal! *'
        require('hlslens').start()
      end, { silent = true, desc = 'Search word under cursor' })

      map('n', '#', function()
        vim.cmd 'normal! #'
        require('hlslens').start()
      end, { silent = true, desc = 'Search word under cursor backward' })

      map('n', 'g*', function()
        vim.cmd 'normal! g*'
        require('hlslens').start()
      end, { silent = true, desc = 'Search partial word' })

      map('n', 'g#', function()
        vim.cmd 'normal! g#'
        require('hlslens').start()
      end, { silent = true, desc = 'Search partial word backward' })

      map('n', '<leader>l', '<cmd>nohlsearch<cr>', {
        silent = true,
        desc = 'Clear search highlighting',
      })
    end,
  },
}

require('lazy').setup(vscode_plugins, {
  root = vim.fn.stdpath 'data' .. '/lazy-vscode',
  defaults = { version = false },
})
