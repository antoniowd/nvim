local M = {}

local curl = require("plenary.curl")

-- Get GitHub Copilot token from running LSP client
local function get_copilot_token()
	-- Try to get token from copilot client state
	local ok, client = pcall(require, "copilot.client")
	if ok and client then
		-- Try to get the running client instance
		local copilot_client = vim.lsp.get_clients and vim.lsp.get_clients({ name = "copilot" })[1]
			or vim.lsp.get_active_clients({ name = "copilot" })[1]

		if copilot_client then
			-- Try to access the token from the client's  config
			if copilot_client.config and copilot_client.config.init_options then
				local init_opts = copilot_client.config.init_options
				if init_opts and init_opts.authProvider and init_opts.authProvider.token then
					return init_opts.authProvider.token, nil
				end
			end
		end
	end

	-- Try the auth module directly
	ok, client = pcall(require, "copilot.auth")
	if ok and client and type(client.get_token) == "function" then
		local token = client.get_token()
		if token and token ~= "" then
			return token, nil
		end
	end

	return nil,
		"Failed to get Copilot token. Make sure Copilot is running and authenticated. Try using 'claude' provider instead by setting provider='claude' in the plugin config."
end

-- Ask GitHub Copilot a question
function M.ask(prompt, callback)
	-- Get authentication token
	local token, token_err = get_copilot_token()
	if not token then
		callback(nil, token_err)
		return
	end

	-- Make request to GitHub Copilot API
	-- Using the chat completions endpoint
	local url = "https://api.githubcopilot.com/chat/completions"

	local body = vim.json.encode({
		messages = {
			{
				role = "system",
				content = "You are a helpful assistant that generates git commit messages.",
			},
			{
				role = "user",
				content = prompt,
			},
		},
		model = "gpt-5-mini",
		temperature = 0.3,
		max_tokens = 200,
	})

	-- Make the request asynchronously
	curl.post(url, {
		headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. token,
		},
		body = body,
		callback = function(response)
			if response.status ~= 200 then
				local error_msg = string.format(
					"Copilot API error (status %d): %s",
					response.status,
					response.body or "No response body"
				)
				callback(nil, error_msg)
				return
			end

			-- Parse the response using vim.json.decode (safe in async context)
			local ok, parsed = pcall(vim.json.decode, response.body)
			if not ok then
				callback(nil, "Failed to parse Copilot response: " .. tostring(parsed))
				return
			end

			-- Extract the message from the response
			if parsed.choices and parsed.choices[1] and parsed.choices[1].message then
				local message = parsed.choices[1].message.content
				-- Clean up the message (remove any markdown formatting, quotes, etc.)
				message = message:gsub("^%s*[`\"']+", ""):gsub("[`\"']+%s*$", "")
				message = vim.trim(message)
				callback(message, nil)
			else
				callback(nil, "Invalid response format from Copilot API")
			end
		end,
	})
end

return M
