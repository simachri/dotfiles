vim.opt.termguicolors = true

-- Always use the block cursor.
vim.opt.guicursor = ""
-- Highlight the current line.
vim.opt.cursorline = true

-- Make it so there are always eight lines below my cursor.
vim.opt.scrolloff = 8

-- Disable swap file and use undo instead.
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Space for displaying messages
vim.opt.cmdheight = 1

vim.opt.updatetime = 50

-- c: Don't pass messages to |ins-completion-menu|.
-- s: don't give "search hit BOTTOM, continuing at TOP" or "search
--    hit TOP, continuing at BOTTOM" messages; when using the search
--    count do not show "W" after the count message (see S below)
vim.opt.shortmess:append({ c = true, s = true })
vim.opt.showcmd = true
vim.opt.laststatus = 2

vim.opt.clipboard:append({ "unnamedplus" })

vim.opt.spelllang = "en,de"
vim.opt.spell = false

-- Enable the creation of new buffers without the restriction
-- to save the currently open buffer
vim.opt.hidden = true

-- Disable delay when pressing Esc
vim.opt.timeoutlen = 600
vim.opt.ttimeoutlen = 0

-- Pasting
vim.opt.pastetoggle = "<F2>"

-- Create 'views' when exiting a window and load it when entering it.
vim.opt.viewoptions = "cursor"

-- Use relative line numbers.
vim.opt.nu = true
vim.opt.relativenumber = true
-- Always show sign column of width 2.
vim.opt.scl = "yes:2"

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.foldmethod = "indent"
-- Do not fold by default.
vim.opt.foldenable = false
vim.opt.foldlevel = 1

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.textwidth = 89
vim.opt.colorcolumn = "90"

vim.opt.fo = "cMroqwnjl" -- see :help fo-table
vim.opt.comments = "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:**"

-- Indicate that a line has been wrapped.
vim.opt.showbreak = '>  '
vim.opt.wrap = false

-- Disable the mouse such that 'select-to-copy' works.
vim.opt.mouse = ""
