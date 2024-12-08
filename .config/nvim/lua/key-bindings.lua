-- Duplicate the current line
vim.api.nvim_set_keymap("n", "<leader>d", ":t.<CR>", { noremap = true, silent = true })

-- Move lines up and down with Control + j/k in Normal mode
vim.api.nvim_set_keymap("n", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Move lines up and down with Control + arrow keys in Normal mode
vim.api.nvim_set_keymap("n", "<C-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Move lines up and down with Control + j/k in Insert mode
vim.api.nvim_set_keymap("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })

-- Move lines up and down with Control + arrow keys in Insert mode
vim.api.nvim_set_keymap("i", "<C-Down>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-Up>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })

-- Move lines up and down with Control + j/k in Visual mode
vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move lines up and down with Control + arrow keys in Visual mode
vim.api.nvim_set_keymap("v", "<C-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Clear the search highlights
vim.api.nvim_set_keymap("n", "<leader>c", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Replace text with the contents of the unnamed register without altering the register
vim.api.nvim_set_keymap("v", "<leader>p", '"_dP', { noremap = true, silent = true })

-- Press Esc to go to normal mode from terminal mode
-- vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Copy current buffer path to clipboard
vim.api.nvim_set_keymap("n", "<leader>cp", ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })

-- Copy current buffer relative path to clipboard
vim.api.nvim_set_keymap("n", "<leader>crp", ':let @+=expand("%:p:.")<CR>', { noremap = true, silent = true })
