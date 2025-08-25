return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false, -- Load immediately
		config = function()
			-- Keybindings for LSP
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true })
			vim.keymap.set(
				"n",
				"<leader>gr",
				require("telescope.builtin").lsp_references,
				{ noremap = true, silent = true }
			)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist, { noremap = true, silent = true })
		end,
	},
}
