# Agent Guidelines for Neovim Configuration

## Overview
This is a Neovim configuration using lazy.nvim plugin manager with Lua. No build/test commands - changes take effect on restart.

## Testing Changes
- Reload config: `:source %` (current file) or restart Neovim
- Check plugins: `:Lazy` (install/update/sync)
- Check LSP: `:LspInfo` | `:Mason` (LSP servers)
- Check formatting: `:ConformInfo`

## Code Style
- **Language**: Lua only
- **Indentation**: 2 spaces (no tabs), use `vim.opt.tabstop = 2`
- **Naming**: snake_case for variables/functions, follow Neovim conventions
- **String quotes**: Use double quotes for strings
- **Plugin structure**: Each plugin in separate file under `lua/plugins/`
- **Imports**: Use `require()` for modules, organize by: `require("config.*")` then `require("plugins.*")`
- **Comments**: Use `--` for single line, keep descriptions concise
- **Error handling**: Minimal in config files, rely on Neovim error messages

## Formatting
- Auto-format on save enabled (conform.nvim)
- Lua: stylua | JS/TS/React/CSS/HTML/JSON/YAML/Markdown: prettier
- Format manually: `<leader>f` in normal mode

## Key Conventions
- Leader: `<space>` | Local leader: `\`
- Plugin config uses `opts` table pattern with lazy.nvim
- LSP keymaps auto-configured on LspAttach event
- Always use `vim.keymap.set()` not `vim.api.nvim_set_keymap()`
