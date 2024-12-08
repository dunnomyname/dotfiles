return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			default_component_configs = {
				git_status = {
					symbols = {
						-- Change type
						added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "✖", -- this can only be used in the git_status source
						renamed = "󰁕", -- this can only be used in the git_status source
						-- Status type
						untracked = "", -- "", Disabled this symbol because it was distracting
						ignored = "",
						unstaged = "", -- "󰄱", Disabled this symbol because it was distracting
						staged = "",
						conflict = "",
					},
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				-- hijack_netrw_behavior = "disabled",
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
				-- instead of relying on nvim autocmd events.
			},
		})
		vim.keymap.set("n", "<leader>e", ":Neotree toggle left<CR>")
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}
