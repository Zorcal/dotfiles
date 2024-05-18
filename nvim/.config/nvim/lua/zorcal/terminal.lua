local M = {}

local term_bufnr = nil
local term_win_id = nil

local function set_win_opts(opts)
  local defaultopts = { height = 15 }
  opts = vim.tbl_deep_extend("force", defaultopts, opts or {})
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, opts.height)
  vim.wo.winfixheight = true
end

local function open_term(opts)
  if vim.fn.bufexists(term_bufnr) ~= 1 then
    vim.cmd.new()
    set_win_opts(opts)
    vim.cmd.term()
    term_win_id = vim.fn.win_getid()
    term_bufnr = vim.fn.bufnr "%"
  elseif vim.fn.win_gotoid(term_win_id) ~= 1 then
    vim.cmd("sb " .. term_bufnr)
    set_win_opts(opts)
    term_win_id = vim.fn.win_getid()
  end
end

local function hide_term()
  if term_win_id ~= nil then
    vim.api.nvim_win_hide(term_win_id)
  end
end

local function toggle_term(opts)
  opts = opts or {}
  if vim.fn.win_gotoid(term_win_id) == 1 then
    hide_term()
    if opts.on_hide ~= nil then
      opts.on_hide { bufnr = term_bufnr, win_id = term_win_id }
    end
  else
    open_term()
    if opts.on_open ~= nil then
      opts.on_open { bufnr = term_bufnr, win_id = term_win_id }
    end
  end
end

M.toggle = function(opts)
  toggle_term(opts)
end

return M
