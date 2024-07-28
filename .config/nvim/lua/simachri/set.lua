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

vim.opt.spelllang = "en,de"
vim.opt.spell = false

-- Enable the creation of new buffers without the restriction
-- to save the currently open buffer
vim.opt.hidden = true

-- Disable delay when pressing Esc
vim.opt.timeoutlen = 600
vim.opt.ttimeoutlen = 0

-- Create 'views' when exiting a window and load it when entering it.
vim.opt.viewoptions = "cursor"

-- Use relative line numbers.
vim.opt.number = true
vim.opt.relativenumber = true
-- For wrapped lines, do not show the line number of the wrapped line, see :h 'rnu'
vim.opt.cpoptions:remove("n")
-- Always display a sign column of width 3. Use a maximum of 4.
-- 2024-07-27: Test a smaller default width of 1.
-- vim.opt.scl = "auto:3-4"
vim.opt.scl = "auto:1-4"

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
-- vim.opt.showbreak = '\\>  '
vim.opt.showbreak = ''
vim.opt.wrap = false

-- Disable the mouse such that 'select-to-copy' works.
vim.opt.mouse = ""

-- Wider statuscolumn to the left.
-- see :h statuscolumn
-- vim.opt.statuscolumn='%{v:relnum?" ":v:lnum}%= %{v:relnum?v:relnum:" "} %s '
vim.opt.statuscolumn="%s%=%{v:virtnum?'':(v:relnum?v:relnum:v:lnum)}  "

-- Disalbe netrw in favour of nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard = "unnamedplus"

vim.filetype.add({
  extension = {
    jira = "confluencewiki",
    confluencewiki = "confluencewiki",
    cds = "cds",
  },
})
