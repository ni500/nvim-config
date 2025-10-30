return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Disable netrw at the very start of your init.lua (recommended by nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- enable 24-bit colour
    vim.opt.termguicolors = true

    require('nvim-tree').setup {
      sync_root_with_cwd = true, -- Sync NvimTree root with current working directory
      respect_buf_cwd = true, -- Respect buffer's current working directory when opening NvimTree
      actions = {
        change_dir = {
          enable = true,
          global = false, -- Only change local CWD for the NvimTree window
        },
      },
      view = {
        width = 35,
        side = 'left',
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { '^.git$', 'node_modules', '.cache' },
      },
      git = {
        enable = true,
        ignore = false,
      },
    }
  end,
}
