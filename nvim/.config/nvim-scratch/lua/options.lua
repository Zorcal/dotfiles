vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.local/state/nvim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx' -- files that u never want to edit

vim.opt.completeopt = 'menuone,noselect'

-- Treat special characters as words so that we can jump to them with w and b.
vim.opt.iskeyword:append '?'
vim.opt.iskeyword:append '&'
vim.opt.iskeyword:append '!'

vim.opt.updatetime = 50

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd [[ set nofoldenable foldmethod=manual foldlevelstart=99 ]]

-- .templ files not recognized with my current version.
vim.filetype.add {
  extension = {
    templ = 'templ',
  },
}

-- Sometimes my fingers are just too quick (or too slow?) for vim...
vim.cmd 'cnoreabbrev W w'
vim.cmd 'cnoreabbrev Wq wq'
vim.cmd 'cnoreabbrev WQ wq'
vim.cmd 'cnoreabbrev Wa wa'
vim.cmd 'cnoreabbrev WA wa'
vim.cmd 'cnoreabbrev Q  q'
vim.cmd 'cnoreabbrev Qa  qa'
vim.cmd 'cnoreabbrev QA  qa'

vim.opt.virtualedit = 'block'
vim.opt.inccommand = 'split'

vim.opt.breakindent = true
