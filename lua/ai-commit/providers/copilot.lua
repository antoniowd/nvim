local M = {}

local curl = require("plenary.curl")
local Path = require("plenary.path")

-- Cache directory for GitHub tokens
local cache_dir = vim.fn.stdpath("data") .. "/ai-commit"
local cache_path = cache_dir .. "/copilot-token.json"

-- Step 1: Read OAuth token from GitHub Copilot config files
local function get_oauth_token()
	-- Determine config directory
	local config_dir
	local xdg_config = vim.fn.expand("$XDG_CONFIG_HOME")

	if xdg_config and xdg_config ~= "" and vim.fn.isdirectory(xdg_config) > 0 then
		config_dir = xdg_config
	else
		-- Fallback to default config directory based on OS
		local os_name = vim.loop.os_uname().sysname
		if os_name == "Linux" or os_name == "Darwin" then
			config_dir = vim.fn.expand("~/.config")
		else
			-- Windows
			config_dir = vim.fn.expand("~/AppData/Local")
		end
	end

	-- Try both hosts.json (copilot.lua) and apps.json (copilot.vim)
	local config_files = { "apps.json", "hosts.json" }

	for _, filename in ipairs(config_files) do
		local filepath = config_dir .. "/github-copilot/" .. filename
		if vim.fn.filereadable(filepath) == 1 then
			-- Read and parse the file
			local content = vim.fn.readfile(filepath)
			if content and #content > 0 then
				local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
				if ok and data then
					-- Find the github.com entry
					for key, value in pairs(data) do
						if key:match("github%.com") and value.oauth_token then
							return value.oauth_token, nil
						end
					end
				end
			end
		end
	end

	return nil,
		"No GitHub Copilot OAuth token found. Please authenticate with :Copilot auth (if using copilot.vim) or :Copilot setup (if using copilot.lua)"
end

-- Step 2: Exchange OAuth token for GitHub API token
local function exchange_token(oauth_token, callback)
	local url = "https://api.github.com/copilot_internal/v2/token"

	curl.get(url, {
		headers = {
			["Authorization"] = "token " .. oauth_token, -- Note: "token" not "Bearer"
			["Accept"] = "application/json",
		},
		callback = function(response)
			if response.status == 200 then
				local ok, github_token = pcall(vim.json.decode, response.body)
				if ok and github_token then
					-- Ensure cache directory exists (must be done in vim.schedule)
					vim.schedule(function()
						vim.fn.mkdir(cache_dir, "p")
						-- Cache the token
						local cache_file = Path:new(cache_path)
						cache_file:write(vim.json.encode(github_token), "w")
						callback(github_token, nil)
					end)
				else
					callback(nil, "Failed to parse token exchange response: " .. tostring(github_token))
				end
			else
				local error_msg = string.format(
					"Failed to exchange OAuth token (status %d): %s. Make sure your Copilot subscription is active.",
					response.status,
					response.body or "No response body"
				)
				callback(nil, error_msg)
			end
		end,
	})
end

-- Step 3: Get valid GitHub token (with caching and refresh)
local function get_github_token(callback)
	-- Try to load cached token
	local cache_file = Path:new(cache_path)
	if cache_file:exists() then
		local ok, cached = pcall(function()
			return vim.json.decode(cache_file:read())
		end)
		if ok and cached and cached.expires_at then
			-- Check if token is still valid (with 2 minute buffer)
			local current_time = math.floor(os.time())
			local expires_at = cached.expires_at
			if expires_at > current_time + 120 then
				-- Token still valid
				callback(cached, nil)
				return
			end
		end
	end

	-- Need to refresh token
	local oauth_token, err = get_oauth_token()
	if not oauth_token then
		callback(nil, err)
		return
	end

	exchange_token(oauth_token, callback)
end

-- Step 4: Make API request with proper authentication
function M.ask(prompt, callback)
	get_github_token(function(github_token, err)
		if not github_token then
			callback(nil, err)
			return
		end

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
			model = "gpt-4o",
			temperature = 0.3,
			max_tokens = 200,
		})

		curl.post(url, {
			headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. github_token.token, -- Use Bearer with GitHub token
				["Editor-Version"] = "vscode/1.95.0",
				["Editor-Plugin-Version"] = "copilot-chat/0.22.4",
				["User-Agent"] = "GitHubCopilotChat/0.22.4",
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
	end)
end

return M
