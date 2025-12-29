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
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended if you want nicer :FlutterDevices / selections
			"stevearc/dressing.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				fvm = true, -- <— key line
				root_patterns = { ".git", "pubspec.yaml" },
				lsp = {
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
					},
				},
			})

			vim.keymap.set(
				"n",
				"<leader>fs",
				"<cmd>FlutterRun<CR>",
				{ desc = "Flutter run", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fr",
				"<cmd>FlutterReload<CR>",
				{ desc = "Flutter hot reload", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fR",
				"<cmd>FlutterRestart<CR>",
				{ desc = "Flutter hot restart", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fq",
				"<cmd>FlutterQuit<CR>",
				{ desc = "Flutter quit", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fd",
				"<cmd>FlutterDetach<CR>",
				{ desc = "Flutter detach", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fl",
				"<cmd>FlutterLogToggle<CR>",
				{ desc = "Toggle Flutter log", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>ft",
				"<cmd>FlutterLogToggle<CR>",
				{ desc = "Toggle Flutter log", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fc",
				"<cmd>FlutterLogClear<CR>",
				{ desc = "Clear Flutter log", noremap = true, silent = true }
			)
		end,
	},
	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- 	event = "InsertEnter",
	-- 	opts = {
	-- 		bind = true,
	-- 		handler_opts = { border = "rounded" },
	-- 		floating_window = true,
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("lsp_signature").setup(opts)
	-- 	end,
	-- },
}
