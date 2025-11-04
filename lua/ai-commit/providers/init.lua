local M = {}

-- Available providers
M.providers = {
  copilot = "ai-commit.providers.copilot",
  claude = "ai-commit.providers.claude",
  openai = "ai-commit.providers.openai",
}

-- Get the configured provider
function M.get_provider(provider_name)
  local provider_module = M.providers[provider_name]

  if not provider_module then
    return nil, string.format("Unknown provider: %s", provider_name)
  end

  local ok, provider = pcall(require, provider_module)
  if not ok then
    return nil, string.format("Failed to load provider '%s': %s", provider_name, provider)
  end

  return provider, nil
end

-- Ask a provider a question
-- This is the main interface that all providers must implement
function M.ask(provider_name, prompt, callback)
  local provider, err = M.get_provider(provider_name)

  if not provider then
    callback(nil, err)
    return
  end

  -- Each provider must implement an `ask` function that takes:
  -- - prompt: the question/prompt to send to the AI
  -- - callback: function(response, error) to call when done
  if type(provider.ask) ~= "function" then
    callback(nil, string.format("Provider '%s' does not implement ask() function", provider_name))
    return
  end

  provider.ask(prompt, callback)
end

return M
