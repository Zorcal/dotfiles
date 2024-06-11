local opt = vim.opt

opt.inccommand = "split"

opt.mouse = ""

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.textwidth = 0
opt.smartindent = true

opt.smartcase = true
opt.ignorecase = true

opt.hlsearch = false

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

-- Don't have `o` add a comment
opt.formatoptions:remove "o"

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv "HOME" .. "/.local/state/nvim/undodir"

opt.scrolloff = 8

opt.signcolumn = "yes"

-- Treat special characters as words so that we can jump to them with `w` and `b`
opt.iskeyword:append "?"
opt.iskeyword:append "&"
opt.iskeyword:append "!"

-- Ma fingers too fast
vim.cmd "cnoreabbrev W w"
vim.cmd "cnoreabbrev Wq wq"
vim.cmd "cnoreabbrev WQ wq"
vim.cmd "cnoreabbrev Wa wa"
vim.cmd "cnoreabbrev WA wa"
vim.cmd "cnoreabbrev Q q"
vim.cmd "cnoreabbrev Qa qa"
vim.cmd "cnoreabbrev QA qa"

-- Files we never want to edit
opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

opt.jumpoptions = "stack,view"

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
