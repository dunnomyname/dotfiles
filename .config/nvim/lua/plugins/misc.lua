return {
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"wellle/targets.vim",
	{
		"kiyoon/jupynium.nvim",
		config = function()
			require("jupynium").setup({
				python_host = "/Users/black/Desktop/Projects/mlx-gpt/.venv/bin/python3", -- optional

				-- The following are now nested under a `jupyter_server` table
				jupyter_server = {
					auto_start = true, -- instead of `auto_start_server`
					auto_attach = true, -- instead of `auto_attach_to_server`
					open_browser = false, -- don't auto-open browser
				},

				-- optional: control kernel / display behavior
				auto_download_ipynb = false,
				use_default_keybindings = true,
			})
		end,
		dependencies = {
			"rcarriga/nvim-notify",
			"stevearc/dressing.nvim",
		},
	},
	{
		"3rd/image.nvim",
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
		opts = {
			processor = "magick_cli",
		},
		config = function()
			require("image").setup({
				backend = "sixel",
				integrations = {
					markdown = {
						enabled = false,
						clear_in_insert_mode = true,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						only_render_image_at_cursor_mode = "popup", -- or "inline"
						floating_windows = false, -- if true, images will be rendered in floating markdown windows
						filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
					},
				},
				max_height_window_percentage = 70,
				scale_factor = 8.0,
			})
		end,
	},
	{
		"3rd/diagram.nvim",
		dependencies = { "3rd/image.nvim" },
		opts = {
			events = {
				render_buffer = {},
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					theme = "forest",
				},
			},
		},
		keys = {
			{
				"K",
				function()
					require("diagram").show_diagram_hover()
				end,
				mode = "n",
				ft = { "markdown" },
				desc = "Show diagram in new tab",
			},
		},
		config = function(opts)
			require("diagram").setup(opts)
		end,
	},
}
