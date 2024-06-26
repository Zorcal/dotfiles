return {
  "stevearc/oil.nvim",
  opts = {},
  config = function()
    require("oil").setup {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return name == ".." or name == ".git"
        end,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },
    }

    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Directory explorer" })
  end,
}
