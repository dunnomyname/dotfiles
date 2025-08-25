return {
	"voldikss/vim-floaterm",
	config = function()
		function RunJestOnTestFile()
			local file_name = vim.fn.expand("%:p")
			local src_path = file_name:match("(.*)(/src/)")

			if file_name:match("jest%.js$") or file_name:match("jest%.ts$") or file_name:match("test.ts") then
				if src_path then
					local command = string.format(
						"FloatermNew --title=Jest --wintype=float --height=0.9 --width=0.9 bash -c 'cd %s; yarn jest %s; exec zsh'",
						src_path,
						vim.fn.shellescape(file_name)
					)
					vim.cmd(command)
				else
					print("No '/src/' found in the path")
				end
			else
				print("Not a Jest test file")
			end
		end

		-- Set the default width and height for Floaterm, pressing F12 when there are no open terminals will open a new one with these dimensions
		vim.g.floaterm_width = 0.9 -- 90% of screen width
		vim.g.floaterm_height = 0.9 -- 90% of screen height

		-- Run jest test with the current test file. Both are the same, two different shortcuts
		vim.api.nvim_set_keymap("n", "<leader>yj", ":lua RunJestOnTestFile()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>jt", ":lua RunJestOnTestFile()<CR>", { noremap = true, silent = true })

		-- Open lazygit
		vim.api.nvim_set_keymap(
			"n",
			"<leader>lg",
			":FloatermNew --disposable --title=LazyGit --wintype=float --height=0.9 --width=0.9 lazygit<CR>",
			{ noremap = true, silent = true }
		)

		-- Create floating terminal
		vim.api.nvim_set_keymap(
			"n",
			"<F7>",
			":FloatermNew --wintype=float --height=0.9 --width=0.9<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"t",
			"<F7>",
			"<C-\\><C-n>:FloatermNew --wintype=float --height=0.9 --width=0.9<CR>",
			{ noremap = true, silent = true }
		)

		-- Toggle floating terminal
		vim.api.nvim_set_keymap("n", "<F12>", ":FloatermToggle<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<F12>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })

		-- Kill floating terminal
		vim.api.nvim_set_keymap("n", "<F9>", ":FloatermKill<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<F9>", "<C-\\><C-n>:FloatermKill<CR>", { noremap = true, silent = true })

		-- Next floating terminal
		vim.api.nvim_set_keymap("n", "<F8>", ":FloatermNext<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<F8>", "<C-\\><C-n>:FloatermNext<CR>", { noremap = true, silent = true })

		-- Previous floating terminal
		vim.api.nvim_set_keymap("n", "<F6>", ":FloatermPrev<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<F6>", "<C-\\><C-n>:FloatermPrev<CR>", { noremap = true, silent = true })
	end,
}
