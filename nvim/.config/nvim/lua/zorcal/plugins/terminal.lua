return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
        return 100
      end,
    }

    vim.keymap.set("t", "<M-n>", "<c-\\><c-n>")
    vim.keymap.set("t", "<C-w>", "<C-\\><C-N><C-w>")
    vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
      pattern = { "*" },
      callback = function()
        if vim.opt.buftype:get() == "terminal" then
          vim.cmd ":startinsert"
        end
      end,
    })
    vim.api.nvim_create_autocmd({ "TermLeave", "BufLeave" }, {
      pattern = { "*" },
      callback = function()
        if vim.opt.buftype:get() ~= "terminal" then
          vim.cmd ":stopinsert"
        end
      end,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local cdterm = Terminal:new {
      hidden = true,
      direction = "horizontal",
      -- cd into dir of last buffer
      on_open = (function()
        local lastdir = nil
        return function()
          local prevdir = vim.fn.expand("#:p"):match "(.*[/\\])"
          if prevdir ~= lastdir then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>\n", true, false, true), "t", false)
            vim.api.nvim_feedkeys("cd " .. prevdir .. "\n", "t", false)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "t", false)
          end
          lastdir = prevdir
        end
      end)(),
    }
    vim.keymap.set({ "n", "t" }, [[<c-\>]], function()
      cdterm:toggle()
    end, { noremap = true, silent = true })

    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    }
    vim.keymap.set("n", "<leader>LG", function()
      lazygit:toggle()
    end, { noremap = true, silent = true })
  end,
}
