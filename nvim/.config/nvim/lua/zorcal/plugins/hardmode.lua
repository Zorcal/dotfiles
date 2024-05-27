return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    opts = {
      -- Add "oil" to the disabled_filetypes
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
  },
  -- {
  --   "tris203/precognition.nvim",
  -- },
}
