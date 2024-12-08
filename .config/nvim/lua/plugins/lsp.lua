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
		lazy = true,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				-- The following on_attach allows format on save
				on_attach = function(client, bufnr)
					if client.name == "ts_ls" then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end

					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								async = false,
							})
						end,
					})
				end,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Disable other formatters if ESLint is handling formatting
					client.server_capabilities.documentFormattingProvider = true

					-- Create autocommands for formatting on save
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }, -- Make sure to include the filetypes you want ESLint to work on
			})

			-- Hover
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { noremap = true, silent = true })

			vim.keymap.set(
				"n",
				"<leader>gd",
				require("telescope.builtin").lsp_definitions,
				{ noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gr",
				require("telescope.builtin").lsp_references,
				{ noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gi",
				require("telescope.builtin").lsp_implementations,
				{ noremap = true, silent = true }
			)
			-- Show code actions
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
			-- Rename symbol
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
			-- Show error in a floating window
			vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { noremap = true, silent = true })
			-- Show errors in a list
			vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist, { noremap = true, silent = true })
		end,
	},
}
