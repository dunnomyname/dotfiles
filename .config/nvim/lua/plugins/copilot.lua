vim.g.root_spec = { { ".git" }, "lsp", "cwd" }

-- vim.api.nvim_set_hl(0, "AvantePopupHint", { fg = "#9DA9A0", bg = "NONE" })
-- vim.api.nvim_set_hl(0, "AvanteInlineHint", { fg = "#9DA9A0", bg = "NONE" })
-- vim.api.nvim_set_keymap("n", "<leader>at", ":AvanteClear<CR>:AvanteToggle<CR>", { noremap = true, silent = true })

-- STOP PROCESSING: <leader>aS

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					hide_during_completion = true,
					debounce = 75,
					trigger_on_accept = true,
					keymap = {
						accept = "<S-Tab>",
						next = "<C-x>",
						prev = "<C-]>",
						dismiss = "<M-[>",
					},
				},
				copilot_model = "gpt-4o-copilot-2025-04-03",
			})
		end,
	},

	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Never set this value to "*"! Never!
	-- 	opts = {
	-- 		provider = "copilot",
	-- 		cursor_applying_provider = "copilot",
	-- 		providers = {
	-- 			copilot = {
	-- 				model = "gpt-4.1-2025-04-14",
	-- 				extra_request_body = {
	-- 					timeout = 60000, -- Timeout in milliseconds, increase this for reasoning models
	-- 					temperature = 0.7,
	-- 					max_completion_tokens = 32768 * 16, -- Increase this to include reasoning tokens (for reasoning models)
	-- 					reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
	-- 				},
	-- 				-- disable_tools = true,
	-- 			},
	-- 		},
	-- 		behaviour = {
	-- 			auto_suggestions = false,
	-- 			enable_cursor_planning_mode = true,
	-- 		},
	-- 		web_search_engine = {
	-- 			provider = "searxng",
	-- 		},
	-- 		mappings = {
	-- 			toggle = {
	-- 				default = "<leader>ar",
	-- 			},
	-- 		},
	-- 	},
	-- 	build = "make",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		--- The below dependencies are optional,
	-- 		"echasnovski/mini.pick", -- for file_selector provider mini.pick
	-- 		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	-- 		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
	-- 		"ibhagwan/fzf-lua", -- for file_selector provider fzf
	-- 		"stevearc/dressing.nvim", -- for input provider dressing
	-- 		"folke/snacks.nvim", -- for input provider snacks
	-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 			opts = {
	-- 				-- recommended settings
	-- 				default = {
	-- 					embed_image_as_base64 = false,
	-- 					prompt_for_file_name = false,
	-- 					drag_and_drop = {
	-- 						insert_mode = true,
	-- 					},
	-- 					-- required for Windows users
	-- 					use_absolute_path = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	{
	-- 		-- Make sure to set this up properly if you have lazy=true
	-- 		"MeanderingProgrammer/render-markdown.nvim",
	-- 		opts = {
	-- 			file_types = { "markdown", "Avante" },
	-- 		},
	-- 		ft = { "markdown", "Avante" },
	-- 	},
	-- },
	-- },
}
