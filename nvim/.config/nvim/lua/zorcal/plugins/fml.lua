return {
  {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>FML", "<cmd>CellularAutomaton make_it_rain<CR>")
    end,
  },
}
