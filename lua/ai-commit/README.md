# AI Commit Message Generator

Generate commit messages using AI based on your staged changes.

## Usage

1. Stage your changes: `:G add <files>`
2. Open commit buffer: `:G commit` or `cc` in Fugitive
3. Generate message: `:GenerateCommitMessage` or `<leader>gm`

## Configuration

Edit `lua/plugins/ai-commit.lua` to configure:

```lua
opts = {
  provider = "claude",  -- or "copilot"
  commit_format = "conventional",
  custom_instructions = nil,
}
```

## Available Providers

### Claude (Recommended)

Uses Anthropic's Claude API directly. Requires an API key.

**Setup:**
1. Get an API key from https://console.anthropic.com/
2. Set environment variable:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```
3. Add to your shell profile (.zshrc, .bashrc, etc.)
4. Set `provider = "claude"` in plugin config

### Copilot

Uses GitHub Copilot API. Requires active Copilot subscription and authentication.

**Setup:**
1. Ensure Copilot is authenticated and working in Neovim
2. Set `provider = "copilot"` in plugin config

**Note:** Copilot token extraction can be tricky. If you get authentication errors, use Claude instead.

## Commit Format

The `conventional` format generates messages like:
- `feat(auth): add JWT token validation`
- `fix(api): handle null response in user endpoint`
- `docs: update installation instructions`
- `refactor: simplify error handling logic`

## Extending

To add a new provider, create `lua/ai-commit/providers/your-provider.lua` with:

```lua
local M = {}

function M.ask(prompt, callback)
  -- Your API call here
  -- Call: callback(response, nil) on success
  -- Call: callback(nil, error) on failure
end

return M
```

Then register it in `lua/ai-commit/providers/init.lua`.
