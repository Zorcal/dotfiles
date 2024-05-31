local M = {}

M.root_node = function(bufnr, ft)
  local parser = vim.treesitter.get_parser(bufnr, ft, {})
  local tree = parser:parse()[1]
  return tree:root()
end

return M
