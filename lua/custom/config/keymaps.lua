local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key (already set in kickstart, but confirming)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- FILE TREE (VS Code: Ctrl+B)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
keymap("n", "<leader>o", ":NvimTreeFocus<CR>", opts)

-- BUFFER NAVIGATION (VS Code: Ctrl+Tab)
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts) -- Shift+L = next buffer
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts) -- Shift+H = prev buffer
keymap("n", "<leader>x", ":bdelete<CR>", opts) -- Close buffer
keymap("n", "<leader>X", ":bufdo bd<CR>", opts) -- Close all buffers

-- WINDOW SPLITS (VS Code-like)
keymap("n", "<leader>v", ":vsplit<CR>", opts) -- Vertical split
keymap("n", "<leader>h", ":split<CR>", opts) -- Horizontal split

-- Code Folding
keymap("n", "-", "<cmd>foldclose<CR>", { desc = "Close code fold" })
keymap("n", "+", "<cmd>foldopen<CR>", { desc = "Open code fold" })

-- BETTER EDITING
keymap("n", "<C-s>", ":w<CR>", opts) -- Save (Ctrl+S)
keymap("i", "<C-s>", "<Esc>:w<CR>a", opts) -- Save in insert mode

-- Cusom keymaps for Nicolass-Mac-Studio
keymap("n", ",", "$", { desc = "Move to end of line" })
keymap("n", "n", "0", { desc = "Move to start of line" })

-- Angular-specific navigation for HTML templates
vim.keymap.set("n", "<leader>ac", function()
	-- Jump to corresponding TypeScript component
	local current_file = vim.fn.expand("%:p")
	if current_file:match("%.html$") then
		local ts_file = current_file:gsub("%.html$", ".ts")
		if vim.fn.filereadable(ts_file) == 1 then
			vim.cmd("edit " .. ts_file)
		else
			print("No matching .ts file found")
		end
	elseif current_file:match("%.ts$") then
		local html_file = current_file:gsub("%.ts$", ".html")
		if vim.fn.filereadable(html_file) == 1 then
			vim.cmd("edit " .. html_file)
		else
			print("No matching .html file found")
		end
	end
end, { desc = "[A]ngular: Toggle [C]omponent/Template" })

-- Search for word under cursor across project (fallback for LSP)
vim.keymap.set("n", "<leader>aG", function()
	require("telescope.builtin").live_grep({
		default_text = vim.fn.expand("<cword>"),
	})
end, { desc = "[A]ngular: [G]rep word under cursor" })
