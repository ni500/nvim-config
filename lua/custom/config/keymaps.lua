local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Main keymaps from Kickstart
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- WARNING: Disable arrow keys in normal mode for advanced level practicing
keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- BUFFER NAVIGATION (VS Code: Ctrl+Tab)
keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', opts) -- Shift+L = next buffer
keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', opts) -- Shift+H = prev buffer
keymap('n', '<leader>x', ':bdelete<CR>', opts) -- Close buffer
keymap('n', '<leader>X', ':bufdo bd<CR>', opts) -- Close all buffers

-- BETTER EDITING
keymap('n', '<C-s>', ':w<CR>', opts) -- Save (Ctrl+S)
keymap('i', '<C-s>', '<Esc>:w<CR>a', opts) -- Save in insert mode

-- Cusom keymaps for Nicolass-Mac-Studio
keymap('n', 'gH', '0', { desc = 'Go to absolute start of line' })
keymap('n', 'gh', '^', { desc = 'Go to first non-blank charter' })
keymap('n', 'gl', 'g_', { desc = 'Go to last non-blank character' })
keymap('n', 'gL', '$', { desc = 'Go to absolute end of line' })

-- Angular-specific navigation for HTML templates
keymap('n', '<leader>ac', function()
  -- Jump to corresponding TypeScript component
  local current_file = vim.fn.expand('%:p')
  if current_file:match('%.html$') then
    local ts_file = current_file:gsub('%.html$', '.ts')
    if vim.fn.filereadable(ts_file) == 1 then
      vim.cmd('edit ' .. ts_file)
    else
      print('No matching .ts file found')
    end
  elseif current_file:match('%.ts$') then
    local html_file = current_file:gsub('%.ts$', '.html')
    if vim.fn.filereadable(html_file) == 1 then
      vim.cmd('edit ' .. html_file)
    else
      print('No matching .html file found')
    end
  end
end, { desc = '[A]ngular: Toggle [C]omponent/Template' })

-- Search for word under cursor across project (fallback for LSP)
keymap('n', '<leader>aG', function()
  Snacks.picker.grep_word()
end, { desc = '[A]ngular: [G]rep word under cursor' })
