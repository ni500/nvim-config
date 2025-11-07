# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration based on Kickstart.nvim with extensive customizations. The configuration follows a modular structure:

- **init.lua**: Entry point that loads config modules and initializes Lazy.nvim plugin manager
- **lua/custom/config/**: Custom configuration files for options and keymaps
- **lua/custom/plugins/**: Custom plugin specifications
- **lua/kickstart/plugins/**: Standard Kickstart plugin modules (debug, lint, autopairs, gitsigns)

### Key Architecture Decisions

1. **Snacks.nvim Integration**: The config heavily relies on Snacks.nvim (by folke) for most UI interactions, replacing standard Telescope keymaps with Snacks.picker for file navigation, LSP navigation, git operations, and search
2. **Lazy.nvim Plugin Manager**: All plugins are lazy-loaded where possible for performance
3. **Custom Module Structure**: Custom configurations are separated into `lua/custom/` to avoid merge conflicts with upstream Kickstart updates

## Plugin Management

### Installing/Updating Plugins

```bash
# Open Neovim and run
:Lazy
```

Use these keys in the Lazy UI:
- `I` - Install missing plugins
- `U` - Update plugins
- `S` - Sync (clean, install, update)
- `C` - Check for updates
- `q` - Quit

### Adding New Plugins

Add plugin specifications in one of:
- `lua/custom/plugins/init.lua` - For simple single-line plugin additions
- `lua/custom/plugins/<plugin-name>.lua` - For complex plugin configs (preferred)

Format: `{ 'author/plugin-name', opts = { ... } }`

## LSP Configuration

LSP servers are managed through Mason and configured in init.lua:272-312.

### Currently Configured Servers
- pyright (Python)
- ts_ls (TypeScript/JavaScript)
- angularls (Angular)
- html, cssls, emmet_ls
- lua_ls (Lua)

### Adding a New LSP Server

1. Add server config to `servers` table in init.lua:272
2. Add server name to `ensure_installed` in init.lua:294-299
3. Restart Neovim - Mason will auto-install the server

### LSP Keymaps (via Snacks.picker)
- `gd` - Goto Definition
- `gD` - Goto Declaration
- `gr` - Find References
- `gI` - Goto Implementation
- `gy` - Goto Type Definition
- `grn` - Rename
- `gra` - Code Action

## Code Formatting

### Stylua (Lua Formatting)

Configuration in `.stylua.toml`:
```toml
column_width = 240
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "None"
```

**Format Lua files:**
```bash
stylua /path/to/file.lua
# Or format entire config
stylua lua/
```

**Auto-formatting**: Enabled on save via conform.nvim (init.lua:314-345)
- `<leader>f` - Manual format in any mode

### Adding Formatters for Other Languages

Edit `formatters_by_ft` in init.lua:341-343:
```lua
formatters_by_ft = {
  lua = { 'stylua' },
  python = { 'black' },  -- example
}
```

## Linting

Configured in `lua/kickstart/plugins/lint.lua`

Currently enabled:
- Markdown: markdownlint

Linting runs automatically on: `BufEnter`, `BufWritePost`, `InsertLeave`

## Custom Keymaps

Key custom keybindings in `lua/custom/config/keymaps.lua`:

### File Navigation (Snacks.picker)
- `<leader><space>` - Smart file finder (frecency-based)
- `<leader>ff` - Find files with frecency
- `<leader>fg` - Find git files
- `<leader>fr` - Recent files
- `<leader>fc` - Find config files

### Search (Snacks.picker)
- `<leader>sg` - Live grep
- `<leader>sw` - Grep word under cursor
- `<leader>sb` - Search buffer lines
- `<leader>sd` - Search diagnostics

### Git (Snacks.picker)
- `<leader>gs` - Git status
- `<leader>gl` - Git log
- `<leader>gb` - Git branches
- `<leader>gd` - Git diff (hunks)
- `<leader>gg` - Open Lazygit

### UI
- `<leader>e` - File explorer (Snacks.explorer)
- `<leader>z` - Toggle Zen mode
- `<C-/>` - Toggle terminal

### Angular-Specific
- `<leader>ac` - Toggle between component (.ts) and template (.html)
- `<leader>aG` - Grep word under cursor (Angular-specific)

### Buffer Management
- `<S-l>` / `<S-h>` - Next/previous buffer
- `<leader>x` - Close current buffer
- `<leader>bd` - Delete buffer (Snacks.bufdelete)

## Development Workflow

### Editing Configuration

1. Open config: `<leader>fc` (or `:e ~/.config/nvim/`)
2. Make changes to files
3. Reload: `:source %` for current file, or restart Neovim
4. For plugin changes: Open `:Lazy` and sync

### Testing LSP Changes

After modifying LSP config in init.lua:
1. Save the file
2. Run `:LspRestart` to reload LSP servers
3. Or restart Neovim

### Debugging

- `:checkhealth` - Check Neovim health (dependencies, plugins, LSP)
- `:Lazy log` - View Lazy.nvim logs
- `:messages` - View Neovim messages
- `:LspInfo` - Check LSP server status
- `:ConformInfo` - Check formatter status

### Important Global Variables

Set in `lua/custom/config/options.lua`:
- `vim.g.mapleader = ' '` - Leader key
- `vim.g.have_nerd_font = true` - Enables Nerd Font icons

## File Organization Rules

### Where to Add Code

1. **New plugin**: Create `lua/custom/plugins/<plugin-name>.lua`
2. **New keymap**: Add to `lua/custom/config/keymaps.lua`
3. **New option**: Add to `lua/custom/config/options.lua`
4. **Modify kickstart plugins**: Edit files in `lua/kickstart/plugins/`

### Avoid Direct init.lua Edits

Prefer modular files in `lua/custom/` over modifying init.lua when possible, as init.lua may receive upstream updates from Kickstart.nvim.

## Dependencies

External tools required (should be installed on system):
- `git`, `make`, `unzip`, C compiler (gcc)
- `ripgrep` (rg) - For grep functionality
- `fd` - For file finding
- `npm` - For TypeScript/Angular LSP servers
- Nerd Font - For icons
- `lazygit` - For git UI (optional, used by Snacks)

### Installing Dependencies on macOS

```bash
brew install ripgrep fd lazygit neovim
```

## Snacks.nvim Integration

Snacks is the primary UI framework, replacing Telescope for most operations. All Snacks keymaps are defined in `lua/custom/config/keymaps.lua`.

**Snacks modules enabled:**
- picker (file/grep/LSP navigation)
- explorer (file browser)
- dashboard (startup screen)
- notifier (notifications)
- terminal (floating terminal)
- lazygit (git UI)
- zen (distraction-free mode)
- words (word highlighting/navigation)
- scroll (smooth scrolling)

Configuration in `lua/custom/plugins/snacks.lua`.
