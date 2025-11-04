local M = {}

-- Build the prompt for generating a commit message
function M.build_commit_prompt(diff, opts)
  opts = opts or {}
  local format = opts.commit_format or "conventional"
  local custom_instructions = opts.custom_instructions

  local prompt = [[You are an expert at writing clear, concise git commit messages.

Generate a commit message for the following staged changes.

]]

  -- Add format-specific instructions
  if format == "conventional" then
    prompt = prompt .. [[Follow the Conventional Commits format:
- Use a type prefix: feat, fix, docs, style, refactor, test, chore
- Format: <type>(<optional scope>): <description>
- Keep the first line under 72 characters
- Use present tense ("add feature" not "added feature")
- Don't capitalize the first letter after the colon
- No period at the end of the subject line

Examples:
- feat(auth): add JWT token validation
- fix(api): handle null response in user endpoint
- docs: update installation instructions
- refactor: simplify error handling logic

]]
  end

  -- Add custom instructions if provided
  if custom_instructions then
    prompt = prompt .. custom_instructions .. "\n\n"
  end

  -- Add the diff
  prompt = prompt .. "Staged changes:\n```\n" .. diff .. "\n```\n\n"

  -- Request the output
  prompt = prompt .. [[Generate ONLY the commit message. Do not include any explanations, markdown formatting, or additional text.
Just output the raw commit message that can be used directly.]]

  return prompt
end

return M
