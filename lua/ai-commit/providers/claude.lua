local M = {}

local curl = require("plenary.curl")

-- Get Claude API key from environment variable
local function get_api_key()
	local api_key = os.getenv("ANTHROPIC_API_KEY")
	if not api_key or api_key == "" then
		return nil, "ANTHROPIC_API_KEY environment variable not set"
	end
	return api_key, nil
end

-- Ask Claude a question
function M.ask(prompt, callback)
	-- Get API key
	local api_key, err = get_api_key()
	if not api_key then
		callback(nil, err)
		return
	end

	-- Claude API endpoint
	local url = "https://api.anthropic.com/v1/messages"

	local body = vim.fn.json_encode({
		model = "claude-sonnet-4-20250514",
		max_tokens = 500,
		messages = {
			{
				role = "user",
				content = prompt,
			},
		},
	})

	-- Make the request asynchronously
	curl.post(url, {
		headers = {
			["Content-Type"] = "application/json",
			["x-api-key"] = api_key,
			["anthropic-version"] = "2023-06-01",
		},
		body = body,
		callback = function(response)
			if response.status ~= 200 then
				local error_msg = string.format("Claude API error (status %d): %s", response.status, response.body or "No response body")
				callback(nil, error_msg)
				return
			end

			-- Parse the response
			local ok, parsed = pcall(vim.fn.json_decode, response.body)
			if not ok then
				callback(nil, "Failed to parse Claude response: " .. tostring(parsed))
				return
			end

			-- Extract the message from the response
			if parsed.content and parsed.content[1] and parsed.content[1].text then
				local message = parsed.content[1].text
				-- Clean up the message
				message = message:gsub("^%s*[`\"']+", ""):gsub("[`\"']+%s*$", "")
				message = vim.trim(message)
				callback(message, nil)
			else
				callback(nil, "Invalid response format from Claude API")
			end
		end,
	})
end

return M
