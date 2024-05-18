local terminal = require "zorcal.terminal"

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("zorcal-termnal-open", { clear = true }),
  callback = function(event)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.bo[event.buf].buflisted = false
  end,
})

local lastdir = nil
vim.keymap.set({ "n", "t" }, "<c-x>", function()
  terminal.toggle {
    on_open = function()
      -- cd to dir of buf when opening the terminal
      local prevdir = vim.fn.expand("#:p"):match "(.*[/\\])"
      if prevdir ~= lastdir then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>\n", true, false, true), "t", false)
        vim.api.nvim_feedkeys("cd " .. prevdir .. "\n", "t", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "t", false)
      end
      lastdir = prevdir

      vim.cmd "startinsert!"
    end,
    on_hide = function()
      vim.cmd "stopinsert!"
    end,
  }
end)

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
