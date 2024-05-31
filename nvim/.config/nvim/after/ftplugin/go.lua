local vo = vim.opt_local
vo.tabstop = 4
vo.shiftwidth = 4
vo.softtabstop = 4
vo.expandtab = false

vim.keymap.set("n", "<leader>td", function()
  require("dap-go").debug_test()
end, { buffer = 0 })

vim.keymap.set("n", "<leader>ty", function()
  local name = require("zorcal.treesitter.go").test_name_under_cursor()
  if name == nil then
    return
  end
  local cmd = "go test -run=" .. name
  vim.fn.setreg("+", cmd)
end, { buffer = 0 })
