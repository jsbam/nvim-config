return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",

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
      require("hlslens").setup(opts)

      local map = vim.keymap.set

      map("n", "n", function()
        vim.cmd("normal! " .. vim.v.count1 .. "n")
        require("hlslens").start()
      end, { silent = true, desc = "Next search result" })

      map("n", "N", function()
        vim.cmd("normal! " .. vim.v.count1 .. "N")
        require("hlslens").start()
      end, { silent = true, desc = "Previous search result" })

      map("n", "*", function()
        vim.cmd("normal! *")
        require("hlslens").start()
      end, { silent = true, desc = "Search word under cursor" })

      map("n", "#", function()
        vim.cmd("normal! #")
        require("hlslens").start()
      end, { silent = true, desc = "Search word under cursor backward" })

      map("n", "g*", function()
        vim.cmd("normal! g*")
        require("hlslens").start()
      end, { silent = true, desc = "Search partial word" })

      map("n", "g#", function()
        vim.cmd("normal! g#")
        require("hlslens").start()
      end, { silent = true, desc = "Search partial word backward" })

      map("n", "<leader>l", "<cmd>nohlsearch<cr>", {
        silent = true,
        desc = "Clear search highlighting",
      })
    end,
  },
}
