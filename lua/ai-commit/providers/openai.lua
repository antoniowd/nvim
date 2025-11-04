local M = {}

local curl = require("plenary.curl")

-- Get OpenAI API key from environment variable
local function get_api_key()
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key or api_key == "" then
		return nil, "OPENAI_API_KEY environment variable not set"
	end
	return api_key, nil
end

-- Ask ChatGPT a question
function M.ask(prompt, callback)
	-- Get API key
	local api_key, err = get_api_key()
	if not api_key then
		callback(nil, err)
		return
	end

	-- OpenAI API endpoint
	local url = "https://api.openai.com/v1/chat/completions"

	local body = vim.json.encode({
		model = "gpt-5-mini", -- Cost-effective model, can be changed to "gpt-4o" or "gpt-4"
		messages = {
			{
				role = "system",
				content = "You are a helpful assistant that generates concise git commit messages.",
			},
			{
				role = "user",
				content = prompt,
			},
		},
		max_completion_tokens = 1000,
	})

	-- Make the request asynchronously
	curl.post(url, {
		headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. api_key,
		},
		body = body,
		callback = function(response)
			if response.status ~= 200 then
				local error_msg = string.format(
					"OpenAI API error (status %d): %s",
					response.status,
					response.body or "No response body"
				)
				callback(nil, error_msg)
				return
			end

			-- Parse the response using vim.json.decode (safe in async context)
			local ok, parsed = pcall(vim.json.decode, response.body)
			if not ok then
				callback(nil, "Failed to parse OpenAI response: " .. tostring(parsed))
				return
			end

			-- Extract the message from the response
			if parsed.choices and parsed.choices[1] and parsed.choices[1].message then
				local choice = parsed.choices[1]
				local message = choice.message.content

				-- Check if message is empty
				if not message or message == "" then
					callback(
						nil,
						"OpenAI returned empty content. Finish reason: "
							.. tostring(choice.finish_reason)
							.. ". Try increasing max_completion_tokens or simplifying the diff."
					)
					return
				end

				-- Clean up the message (remove any markdown formatting, quotes, etc.)
				message = message:gsub("^%s*[`\"']+", ""):gsub("[`\"']+%s*$", "")
				message = vim.trim(message)
				callback(message, nil)
			else
				callback(nil, "Invalid response format from OpenAI API")
			end
		end,
	})
end

return M
