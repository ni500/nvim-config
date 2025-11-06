return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          -- keys = {
          --   {
          --     icon = '󰈞 ',
          --     key = 'f',
          --     desc = 'Find Files (Frecency)',
          --     action = function()
          --       Snacks.picker.files({ frecency = true })
          --     end,
          --   },
          --   { icon = '󰈔 ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          --   {
          --     icon = '󰱼 ',
          --     key = 'g',
          --     desc = 'Find Text',
          --     action = function()
          --       Snacks.picker.grep()
          --     end,
          --   },
          --   {
          --     icon = '󰋚 ',
          --     key = 'r',
          --     desc = 'Recent Files',
          --     action = function()
          --       Snacks.picker.recent()
          --     end,
          --   },
          --   {
          --     icon = '󰒓 ',
          --     key = 'c',
          --     desc = 'Config',
          --     action = function()
          --       Snacks.picker.files({ cwd = vim.fn.stdpath('config') })
          --     end,
          --   },
          --   { icon = '󰁯 ', key = 's', desc = 'Restore Session', section = 'session' },
          --   { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          --   { icon = '󰗼 ', key = 'q', desc = 'Quit', action = ':qa' },
          -- },
        },
        sections = {
          { section = 'header' },
          { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
          { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          { section = 'startup' },
        },
        formats = {
          icon = function(item)
            if item.file and (item.icon == 'file' or item.icon == 'directory') then
              return Snacks.dashboard.icon(item.file, item.icon)
            end
            return item.icon and { { item.icon, hl = 'icon' } } or {}
          end,
          file = function(item, ctx)
            local filename = vim.fn.fnamemodify(item.file, ':t')
            return { { filename, hl = 'file' } }
          end,
        },
      },
      explorer = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        formatters = {
          file = {
            filename_first = true,
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    config = function(_, opts)
      local snacks = require('snacks')
      snacks.setup(opts)

      -- Set vim.ui.input for Snacks
      vim.ui.input = snacks.input
    end,
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has('nvim-0.11') == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
          Snacks.toggle.diagnostics():map('<leader>ud')
          Snacks.toggle.line_number():map('<leader>ul')
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
          Snacks.toggle.treesitter():map('<leader>uT')
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
          Snacks.toggle.inlay_hints():map('<leader>uh')
          Snacks.toggle.indent():map('<leader>ug')
          Snacks.toggle.dim():map('<leader>uD')
        end,
      })
    end,
  },
}
