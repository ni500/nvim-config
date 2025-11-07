return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'onedark',
        component_separators = '|',
        section_separators = '·',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            function()
              local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
              return '📁 ' .. cwd
            end,
            color = { fg = '#7aa2f7', gui = 'bold' }, -- Blue like Claude Code
            padding = { left = 1, right = 1 },
          },
          {
            'filename',
            path = 1, -- Relative path from cwd
            separator = '|',
          },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    })
  end,
}
