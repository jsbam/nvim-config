-- Vim Visual Multi - Multiple cursors plugin
-- This adds multiple cursor support similar to VSCode

return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    -- Must be set BEFORE plugin loads
    vim.g.VM_default_mappings = 0
    vim.g.VM_quit_after_leaving_insert_mode = 0
    vim.g.VM_mouse_mappings = 1
    vim.g.VM_maps = vim.tbl_extend("force", vim.g.VM_maps or {}, {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      -- ["Select All"] = "<leader>ma",
      -- ["Visual All"] = "<leader>ma",
      ["Exit"] = "<Esc><Esc>",
      -- Avoid mapping bare [ and ] to Lua callbacks (shows errors in :VMDebug)
      ["Goto Prev"] = "",
      ["Goto Next"] = "",
      ["Align"] = "<leader>m=",
      ["Add Cursor Down"] = "<C-d>",
      ["Add Cursor Up"] = "<C-u>",
      ["Switch Mode"] = "<Tab>",
      ["Remove Region"] = "Q",                 -- remove current cursor position, move cursor backward.
      ["Skip Region"] = "q",                   -- skip current cursor position.
      [" VM-Mouse-Cursor"] = "<C-LeftMouse>",  --add VM-cursor with mouse click
      [" VM-Mouse-Column"] = "<C-RightMouse>", --add VM-cursor to column with mouse click
      ["Move Right"] = "<S-Right>",
      ["Move Left"] = "<S-Left>",
      -- Visual mode mappings (disabled, using direct <Plug> mappings below)
      ["Toggle Single Region"] = "",
      ["Visual Cursors"] = "",
      ["Visual Add"] = "",
      ["Visual Find"] = "",
      ["Visual Regex"] = "",
    })
  end,
  config = function()
    -- Setup which-key mappings for vim-visual-multi
    local wk = require 'which-key'

    -- local function visual_cursors_with_delay()
    --   -- Execute the vm-visual-cursors command.
    --   vim.cmd 'silent! execute "normal! \\<Plug>(VM-Visual-Cursors)"'
    --   -- Introduce delay via VimScript's 'sleep' (set to 500 milliseconds here).
    --   vim.cmd 'sleep 200m'
    --   -- Press 'A' in normal mode after the delay.
    --   vim.cmd 'silent! execute "normal! A"'
    -- end

    local function vm_visual_insert(kind)
      local replace = vim.api.nvim_replace_termcodes
      vim.api.nvim_feedkeys(replace("<Plug>(VM-Visual-Cursors)", true, false, true), "x", false)
      vim.defer_fn(function()
        vim.api.nvim_feedkeys(replace("<Plug>(VM-" .. kind .. ")", true, false, true), "n", false)
      end, 25)
    end

    local function vm_visual_end_mode()
      local replace = vim.api.nvim_replace_termcodes
      vm_visual_insert("A")
      vim.defer_fn(function()
        vim.api.nvim_feedkeys(replace("<Esc>", true, false, true), "n", false)
      end, 60)
    end

    wk.add({
      { "<leader>m",  group = "Visual Multi",          mode = { "n", "x" } },
      { "<leader>ma", "<Plug>(VM-Select-All)<Tab>",    desc = "Select [a]ll",         mode = "n", remap = true },
      { "<leader>mr", "<Plug>(VM-Start-Regex-Search)", desc = "Start [r]egex Search", mode = "n", remap = true },
      {
        "<leader>mp",
        "<Plug>(VM-Add-Cursor-At-Pos)",
        desc = "Add Cursor At [p]osition",
        mode = "n",
        remap = true,
      },
      -- Use <leader>mo if to togle VM keymaps on/off while on active moe
      -- Use if, while VM is active, you need normal keys for a moment (or want VM keys back again)
      { "<leader>mo", "<Plug>(VM-Toggle-Mappings)", desc = "Toggle Mapping", mode = "n", remap = true },
      -- from V-line to V-block visual mode, then multi-cursors in insert at line end/start of the lines
      {
        "<leader>mA",
        function()
          vm_visual_insert("A")
        end,
        desc = "Multi-cursor append at line end",
        mode = "x",
      },
      {
        "<leader>mI",
        function()
          vm_visual_insert("I")
        end,
        desc = "Multi-cursor insert at line start",
        mode = "x",
      },
      {
        "<leader>mv", vm_visual_end_mode, desc = "Multi-cursor at line end (VM mode)", mode = "x", } })
  end,
}
