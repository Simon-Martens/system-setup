-- Extra settings for
-- - markdown editing
-- - note mode
-- Autocmd for Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true -- Enable wrap for Markdown files
    vim.opt_local.linebreak = true -- Ensure whole words wrap
    vim.opt_local.breakindent = true -- Make wrapped lines indent correctly
    vim.opt_local.textwidth = 0 -- Ensure no hard wrapping from textwidth
    vim.opt_local.wrapmargin = 0 -- Ensure no hard wrapping from wrapmargin
    -- Optional: Set a string to indicate wrapped lines
    -- vim.opt_local.showbreak = "↳ "
  end,
  desc = 'Set word wrap for Markdown files',
})

local TARGET_DIR = vim.fn.expand '~' .. '/source/texte'
local AUTO_COMMIT_NOTES_GROUP = vim.api.nvim_create_augroup('AutoCommitNotesGroup', { clear = true })

-- --- Check the environment variable for notes mode ---
-- vim.env is a table in Lua that holds environment variables
local is_notes_mode = vim.env.NVIM_NOTES_MODE == 'true'
-- ----------------------------------------------------

-- Function to check for changes and prompt for commit
local function prompt_and_commit_notes()
  -- This entire block only runs if is_notes_mode is true
  if not is_notes_mode then
    return -- Exit early if not in notes mode
  end

  -- OPTION B: Force write all modified buffers before proceeding
  -- Uncomment the line below if you want this behavior.
  -- vim.cmd('wa')

  local current_cwd = vim.fn.getcwd()

  -- Only proceed if the current working directory is the target notes directory
  if current_cwd == TARGET_DIR then
    print('Checking for changes in ' .. TARGET_DIR .. ' before exiting...')

    -- Check if there are any staged or unstaged changes
    local status_output = vim.fn.systemlist('git -C ' .. TARGET_DIR .. ' status --porcelain')

    if #status_output > 0 then
      -- Changes detected, prompt the user
      local confirm = vim.fn.confirm('Changes detected in notes. Commit? (y/n)', '&Yes\n&No', 2) -- Default to No

      if confirm == 1 then -- User chose 'Yes'
        -- Prompt for commit message
        local commit_msg = vim.fn.input('Enter commit message: ', 'Auto-commit: Notes update')

        -- If user provided a message, or default is acceptable
        if commit_msg and #commit_msg > 0 then
          print 'Staging and committing changes...'
          vim.fn.system('git -C ' .. TARGET_DIR .. ' add .')

          -- Execute the commit
          local commit_result = vim.fn.system('git -C ' .. TARGET_DIR .. " commit -m '" .. commit_msg .. "'")

          if vim.v.shell_error == 0 then
            print 'Successfully committed changes.'
            print 'Attempting to push changes...'

            -- Attempt to push, ignore errors for this command
            local push_result = vim.fn.system('git -C ' .. TARGET_DIR .. ' push')
            if vim.v.shell_error == 0 then
              print 'Successfully pushed changes.'
            else
              print 'Git push failed. You may need to push manually.'
              -- print("Push output: \n" .. push_result) -- Uncomment for detailed push errors
            end
          else
            print 'Git commit failed. Output:'
            print(commit_result)
          end
        else
          print 'Commit cancelled: No message provided.'
        end
      else
        print 'Commit cancelled by user.'
      end
    else
      print('No changes to commit in ' .. TARGET_DIR .. '.')
    end
  end
end

-- Create an autocommand to run the function before Neovim quits
-- This autocommand is always set, but the callback function itself
-- will conditionally execute based on the environment variable.
vim.api.nvim_create_autocmd('QuitPre', {
  group = AUTO_COMMIT_NOTES_GROUP,
  callback = prompt_and_commit_notes,
  desc = 'Prompt to commit and push notes on Neovim exit if in target directory (only if notes mode)',
})
