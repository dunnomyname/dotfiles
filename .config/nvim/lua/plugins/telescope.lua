return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
		},
		config = function()
			local builtin = require("telescope.builtin")

			require("telescope").setup({
				defaults = {
					use_quickfix = true,
					layout_config = {
						width = 0.80,
						preview_width = 0.5,
					},
				},
			})

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { noremap = true })
			-- vim.keymap.set("n", "<leader>fw", builtin.live_grep, { noremap = true })
			vim.keymap.set(
				"n",
				"<leader>fw",
				":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
			)
			vim.keymap.set("n", "<leader>fg", builtin.grep_string, { noremap = true })
			vim.keymap.set("n", "<leader>fe", builtin.diagnostics, { noremap = true })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { noremap = true })
			vim.keymap.set("n", "<leader>fr", builtin.registers, { noremap = true })

			vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { noremap = true })

			-- Keybinding to switch between live_grep and grep_string
			vim.api.nvim_set_keymap("n", "<C-g>", ":Telescope grep_string<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("live_grep_args")
		end,
	},
}
