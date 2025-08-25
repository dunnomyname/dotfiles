return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "VeryLazy" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "eslint_d", "prettierd" },
				typescript = { "eslint_d", "prettierd" },
				javascriptreact = { "eslint_d", "prettierd" }, -- .jsx
				typescriptreact = { "eslint_d", "prettierd" }, -- .tsx
				svelte = { "eslint_d", "prettierd" },
				css = { "eslint_d", "prettierd" },
				scss = { "eslint_d", "prettierd" },
				html = { "eslint_d", "prettierd" },
				json = { "eslint_d", "prettierd" },
				yaml = { "eslint_d", "prettierd" },
				markdown = { "eslint_d", "prettierd" },
				graphql = { "eslint_d", "prettierd" },
				lua = { "stylua" },
				python = { "isort", "black" },
				bash = { "shfmt" },
				toml = { "taplo" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 10000,
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = true,
				async = true,
				timeout_ms = 10000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
