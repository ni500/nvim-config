local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key (already set in kickstart, but confirming)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- FILE TREE (VS Code: Ctrl+B)
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
keymap('n', '<leader>o', ':NvimTreeFocus<CR>', opts)

-- BUFFER NAVIGATION (VS Code: Ctrl+Tab)
keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', opts) -- Shift+L = next buffer
keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', opts) -- Shift+H = prev buffer
keymap('n', '<leader>x', ':bdelete<CR>', opts) -- Close buffer
keymap('n', '<leader>X', ':bufdo bd<CR>', opts) -- Close all buffers

-- WINDOW SPLITS (VS Code-like)
keymap('n', '<leader>v', ':vsplit<CR>', opts) -- Vertical split
keymap('n', '<leader>h', ':split<CR>', opts) -- Horizontal split

-- Code Folding
keymap('n', '-', '<cmd>foldclose<CR>', { desc = 'Close code fold' })
keymap('n', '+', '<cmd>foldopen<CR>', { desc = 'Open code fold' })

-- BETTER EDITING
keymap('n', '<C-s>', ':w<CR>', opts) -- Save (Ctrl+S)
keymap('i', '<C-s>', '<Esc>:w<CR>a', opts) -- Save in insert mode

-- CLAUDE CODE
keymap('n', '<leader>c', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })

-- Cusom keymaps for Nicolass-Mac-Studio
keymap('n', ',', '$', { desc = 'Move to end of line' })
keymap('n', 'n', '0', { desc = 'Move to start of line' })
