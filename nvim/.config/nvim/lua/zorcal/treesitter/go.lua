local M = {}

local ts = require "zorcal.treesitter"

local parse_test_funcs = function(bufnr)
  local query = vim.treesitter.query.parse(
    "go",
    [[
(function_declaration
  name: (identifier) @name (#match? @name "^Test*")
  parameters: (parameter_list
    (parameter_declaration
      name: (identifier)
      type: (pointer_type
        (qualified_type
          package: (package_identifier) @pkgid (#eq? @pkgid "testing")
          name: (type_identifier) @typeid (#eq? @typeid "T")
          )
        )
      )
    )
) @decl
]]
  )

  local funcs = {}
  for _, match, _ in query:iter_matches(ts.root_node(bufnr, "go"), bufnr, 0, -1, { all = true }) do
    local name = nil
    local range = nil

    for id, nodes in pairs(match) do
      local capture_name = query.captures[id]
      local node = nodes[1]

      if capture_name == "name" then
        name = vim.treesitter.get_node_text(node, bufnr)
        goto continue
      end

      if capture_name == "decl" then
        local node_range = { node:range() }
        range = { start_row = node_range[1] + 1, end_row = node_range[3] + 1 } -- +1 to make 1-indexed
        goto continue
      end

      ::continue::
    end

    if name ~= nil and range ~= nil then
      table.insert(funcs, { name = name, range = range })
    end
  end

  return funcs
end

M.test_name_under_cursor = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "go" then
    vim.notify "can only be used in Go"
    return
  end

  local current_row = vim.api.nvim_win_get_cursor(0)[1]
  for _, f in ipairs(parse_test_funcs(bufnr)) do
    if current_row >= f.range.start_row and current_row <= f.range.end_row then
      return f.name
    end
  end
end

return M
