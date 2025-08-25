vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set mouse=a")

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

vim.opt.swapfile = false -- Don't use swapfiles
vim.opt.autoread = true -- Auto read file if changed outside of vim
vim.opt.backspace = "indent,eol,start" -- Allow backspacing over everything in insert mode
vim.opt.scrolloff = 5 -- Always show 5 lines above and below the cursor
vim.opt.fillchars = "eob: " -- Hide the tilde (~) sign on blank lines

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--vim.cmd()
vim.opt.clipboard = "unnamedplus"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Concealer for Neorg
vim.o.conceallevel = 2

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Reload files when changed outside of vim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { command = "checktime" })

-- Open vim to neo-tree
-- vim.api.nvim_create_autocmd("VimEnter", {
--   pattern = "*",
--   callback = function()
--     if vim.fn.isdirectory(vim.fn.argv()[1]) == 1 and vim.fn.argc() == 1 then
--       vim.cmd("Neotree toggle left")
--     end
--   end,
-- })
