--[[

=====================================================================
=============== CHECK MASTER BRANCH FOR A FRESH START ===============
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

--]]

require('custom.config.options')
require('custom.config.keymaps')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  -- { -- getsigns: Adds git related signs to the gutter, as well as utilities for managing changes
  --   'lewis6991/gitsigns.nvim',
  --   opts = {
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '∙' },
  --       delete = { text = '-' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '≈' },
  --     },
  --   },
  --   config = function(_, opts)
  --     require('gitsigns').setup(opts)
  --
  --     vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#26A269', bold = true })
  --     vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#E5A50A', bold = true })
  --     vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#C01C28', bold = true })
  --     vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { fg = '#C01C28', bold = true })
  --     vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { fg = '#E5A50A', bold = true })
  --     vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#5E5C64' })
  --   end,
  -- },
  { -- whick-key: Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = {},
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'v' } },
      },
    },
  },
  { -- telescope: Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      {
        'nvim-tree/nvim-web-devicons',
        opts = {
          color_icons = true,
          default = true,
          strict = true,
          variant = 'auto',
          override = {
            zsh = {
              icon = ' ',
              color = '#91C848',
              cterm_color = '65',
              name = 'Zsh',
            },
          },
          override_by_filename = {
            ['.gitignore'] = {
              icon = '',
              color = '#f1502f',
              name = 'Gitignore',
            },
          },
        },
      },
      { 'kkharji/sqlite.lua' },
      { 'nvim-telescope/telescope-frecency.nvim' },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup({
        defaults = {
          layout_config = {
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending', -- Results flow down from top
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          frecency = {
            auto_validate = false,
            matcher = 'fuzzy',
            path_display = { 'filename_first' },
          },
        },
      })
      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- NOTE: Telescope search keymaps removed - using Snacks.picker instead
      -- All search functionality now handled by Snacks.picker (see lua/custom/plugins/snacks.lua)
    end,
  },
  -- LSP Plugins
  { -- lazydev
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- nvim-lspconfig: Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' }, -- Load before file opens for proper highlighting
    dependencies = {
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
      'saghen/blink.cmp', -- Allows extra capabilities provided by blink.cmp
    },
    config = function()
      -- FIRST: Block ts_ls and html LSP from attaching in Angular projects
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('block-lsp-in-angular', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local util = require('lspconfig.util')
          local bufname = vim.api.nvim_buf_get_name(event.buf)
          local is_angular = util.root_pattern('nx.json', 'angular.json', 'project.json')(bufname)

          if is_angular then
            -- Block ts_ls - angularls handles TypeScript
            if client.name == 'ts_ls' then
              vim.lsp.stop_client(client.id)
              return
            end

            -- Block html LSP for Angular template files - angularls handles HTML templates
            if client.name == 'html' then
              local ft = vim.bo[event.buf].filetype
              if ft == 'html' or ft == 'htmlangular' then
                vim.lsp.stop_client(client.id)
                return
              end
            end

            -- Block emmet_ls for Angular templates - too heavy, angularls provides completion
            if client.name == 'emmet_ls' then
              local ft = vim.bo[event.buf].filetype
              if ft == 'html' or ft == 'htmlangular' then
                vim.lsp.stop_client(client.id)
                return
              end
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          -- This is not Goto Definition, this is Goto Declaration.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Hover Documentation
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- Signature Help
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

          -- NOTE: Telescope LSP navigation keymaps removed - using Snacks.picker instead
          -- LSP navigation now handled by Snacks.picker (gd, gr, gI, gD, gy)
          -- See lua/custom/plugins/snacks.lua for LSP keymaps

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has('nvim-0.11') == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
              end,
            })
          end
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config (Performance optimized)
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        update_in_insert = false, -- Don't update diagnostics while typing (big performance boost)
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        ts_ls = {}, -- TypeScript/JavaScript (disabled in Angular projects via custom handler)
        angularls = {
          filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
          root_dir = require('lspconfig.util').root_pattern('nx.json', 'angular.json', 'project.json', '.git'),
          -- Aggressive performance optimizations for large Nx monorepos
          on_attach = function(client, bufnr)
            -- Disable semantic tokens for faster startup
            client.server_capabilities.semanticTokensProvider = nil
            -- Disable document formatting (use prettier via conform instead)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            -- Disable hover for HTML files (reduces overhead on large templates)
            if vim.bo[bufnr].filetype == 'html' or vim.bo[bufnr].filetype == 'htmlangular' then
              client.server_capabilities.hoverProvider = false
            end
          end,
          -- Performance settings for Angular LS
          init_options = {
            enableIvy = true,
            strictTemplates = false,
            forceStrictTemplates = false,
          },
          flags = {
            debounce_text_changes = 500, -- Higher debounce for large HTML templates
          },
        },
        tailwindcss = {
          on_attach = function(client, bufnr)
            -- Disable hover in HTML files (tailwind info is heavy)
            if vim.bo[bufnr].filetype == 'html' or vim.bo[bufnr].filetype == 'htmlangular' then
              client.server_capabilities.hoverProvider = false
            end
          end,
          flags = {
            debounce_text_changes = 500,
          },
        },
        cssmodules_ls = {
          flags = {
            debounce_text_changes = 500,
          },
        },
        lua_ls = {
          settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'angular-language-server',
        'eslint-lsp',
        'prettier', -- TypeScript/HTML/CSS formatter
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
      require('mason-lspconfig').setup({
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
          -- Special handler for ts_ls to completely disable it in Angular/Nx projects
          -- This works for ALL Angular projects by checking for marker files
          ts_ls = function()
            -- Check if current working directory or any parent has Angular markers
            local util = require('lspconfig.util')
            local cwd = vim.fn.getcwd()
            local is_angular = util.root_pattern('nx.json', 'angular.json', 'project.json')(cwd)

            print('[DEBUG] ts_ls handler called, cwd:', cwd)
            print('[DEBUG] is_angular:', is_angular)

            if is_angular then
              -- Don't setup ts_ls at all in Angular projects
              print('[BLOCKED] ts_ls disabled in Angular/Nx project: ' .. is_angular)
              vim.notify('ts_ls BLOCKED in Angular project: ' .. is_angular, vim.log.levels.WARN)
              -- Do NOT call setup at all
              return
            end

            -- Setup ts_ls normally for non-Angular projects
            print('[ALLOWED] ts_ls allowed in non-Angular project')
            local server = servers.ts_ls or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig').ts_ls.setup(server)
          end,
        },
      })
    end,
  },
  { -- conform: Autoformat
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          -- Use longer timeout for TypeScript/Angular files
          local timeout = vim.bo[bufnr].filetype == 'typescript' and 2000 or 500
          return {
            timeout_ms = timeout,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        json = { 'prettier' },
      },
    },
  },
  { -- blink: Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { -- tokyotonight: You can easily change to a different colorscheme. `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup({
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      })
      vim.cmd.colorscheme('tokyonight-storm')
    end,
  },
  { -- todo-comments: Highlight, edit, and navigate code
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { -- mini: Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup({ n_lines = 500 })
    end,
  },
  { -- treesitter: Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'latex',
        'norg',
        'svelte',
        'typst',
        'vue',
        'regex',
        'css',
        'scss',
        'typescript',
        'tsx',
        'javascript',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      fold = { enable = true },
    },
  },
  require('kickstart.plugins.debug'),
  require('kickstart.plugins.lint'),
  require('kickstart.plugins.autopairs'),
  -- require('kickstart.plugins.gitsigns'), -- adds gitsigns recommend keymaps
  { import = 'custom.plugins' },
}, {})
