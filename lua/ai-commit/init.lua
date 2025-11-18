local M = {}

local git = require("ai-commit.git")
local prompts = require("ai-commit.prompts")
local providers = require("ai-commit.providers")

-- Default configuration
local config = {
  provider = "copilot",
  commit_format = "conventional",
  custom_instructions = nil,
}

-- Setup function called by lazy.nvim
function M.setup(opts)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts or {})

  -- Register the command
  vim.api.nvim_create_user_command("GenerateCommitMessage", function()
    M.generate_commit_message()
  end, {
    desc = "Generate a commit message using AI",
  })
end

-- Main function to generate commit message
function M.generate_commit_message()
  -- Step 1: Validate we're in a git repo with staged changes
  if not git.is_git_repo() then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  if not git.has_staged_changes() then
    vim.notify("No staged changes found. Stage some changes first.", vim.log.levels.WARN)
    return
  end

  -- Step 2: Get the staged diff
  local diff, diff_err = git.get_staged_diff()
  if not diff then
    vim.notify("Failed to get staged diff: " .. (diff_err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  -- Step 3: Build the prompt
  local prompt = prompts.build_commit_prompt(diff, config)

  -- Step 4: Show loading notification
  vim.notify("Generating commit message with " .. config.provider .. "...", vim.log.levels.INFO)

  -- Step 5: Call the AI provider
  providers.ask(config.provider, prompt, function(response, err)
    -- This callback is called asynchronously when the AI responds
    vim.schedule(function()
      if not response then
        vim.notify("Failed to generate commit message: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
      end

      -- Step 6: Insert the commit message at cursor position
      M.insert_at_cursor(response)

      vim.notify("Commit message generated!", vim.log.levels.INFO)
    end)
  end)
end

-- Insert text at current cursor position
function M.insert_at_cursor(text)
  -- Get current cursor position
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Split text into lines
  local lines = vim.split(text, "\n", { plain = true })

  -- Get current buffer
  local buf = vim.api.nvim_get_current_buf()

  -- Check if buffer is modifiable, and make it modifiable if needed
  local was_modifiable = vim.api.nvim_buf_get_option(buf, 'modifiable')
  if not was_modifiable then
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  end

  -- Insert the first line at cursor position
  local current_line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  local before = current_line:sub(1, col)
  local after = current_line:sub(col + 1)

  if #lines == 1 then
    -- Single line: insert inline
    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { before .. text .. after })
    -- Move cursor to end of inserted text
    vim.api.nvim_win_set_cursor(0, { row, col + #text })
  else
    -- Multiple lines: insert as separate lines
    lines[1] = before .. lines[1]
    lines[#lines] = lines[#lines] .. after

    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
    -- Move cursor to end of inserted text
    vim.api.nvim_win_set_cursor(0, { row + #lines - 1, #lines[#lines] - #after })
  end

  -- Keep buffer modifiable (we want to edit commit messages)
  -- Don't restore the original state as commit buffers should be editable
end

return M
