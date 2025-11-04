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
		prompt = prompt
			.. [[Follow the Conventional Commits format:
- Use a type prefix: feat, fix, docs, style, refactor, test, chore
- Format: <type>(<optional scope>): <description>
- Keep the first line under 72 characters
- Use present tense ("add feature" not "added feature")
- Don't capitalize the first letter after the colon
- No period at the end of the subject line

IMPORTANT - Commit Body Guidelines:
- For SMALL, self-explanatory changes: provide ONLY the subject line (one line)
- For COMPLEX changes that need explanation: add a blank line, then a detailed body

Include a body ONLY when:
- Multiple files/areas are affected and need context
- The "why" behind the change is not obvious
- There are important implementation details or caveats
- Breaking changes or migration steps are needed

DO NOT include a body when:
- The change is simple and the subject line is self-explanatory
- It's a small fix, typo correction, or minor refactor
- The diff clearly shows what changed

Examples with subject only (no body needed):
- feat(auth): add JWT token validation
- fix(api): handle null response in user endpoint
- docs: update installation instructions
- refactor: simplify error handling logic

Example with body (complex change):
- feat(auth): implement OAuth2 authentication flow

Add OAuth2 support with GitHub and Google providers. Includes
token refresh logic, session management, and fallback to local
auth for development environments.

]]
	end

	-- Add custom instructions if provided
	if custom_instructions then
		prompt = prompt .. custom_instructions .. "\n\n"
	end

	-- Add the diff
	prompt = prompt .. "Staged changes:\n```\n" .. diff .. "\n```\n\n"

	-- Request the output
	prompt = prompt
		.. [[Generate ONLY the commit message. Do not include any explanations, markdown formatting, or additional text.
Just output the raw commit message that can be used directly.]]

	return prompt
end

return M
