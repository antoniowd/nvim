local M = {}

-- Check if current directory is in a git repository
function M.is_git_repo()
  local result = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
  return vim.v.shell_error == 0 and result:match("true") ~= nil
end

-- Check if there are staged changes
function M.has_staged_changes()
  if not M.is_git_repo() then
    return false
  end

  local result = vim.fn.system("git diff --staged --quiet 2>/dev/null")
  -- git diff --quiet returns 0 if no changes, 1 if changes exist
  return vim.v.shell_error == 1
end

-- Get the staged diff
function M.get_staged_diff()
  if not M.is_git_repo() then
    return nil, "Not in a git repository"
  end

  if not M.has_staged_changes() then
    return nil, "No staged changes found"
  end

  local diff = vim.fn.system("git diff --staged")

  if vim.v.shell_error ~= 0 then
    return nil, "Failed to get staged diff"
  end

  return diff, nil
end

-- Get recent commit messages for style matching
function M.get_recent_commits(count)
  count = count or 5

  if not M.is_git_repo() then
    return nil, "Not in a git repository"
  end

  local commits = vim.fn.system(string.format("git log -%d --pretty=format:%%s", count))

  if vim.v.shell_error ~= 0 then
    return nil, "Failed to get recent commits"
  end

  return commits, nil
end

-- Get current branch name
function M.get_branch_name()
  if not M.is_git_repo() then
    return nil, "Not in a git repository"
  end

  local branch = vim.fn.system("git branch --show-current")

  if vim.v.shell_error ~= 0 then
    return nil, "Failed to get branch name"
  end

  return vim.trim(branch), nil
end

return M
