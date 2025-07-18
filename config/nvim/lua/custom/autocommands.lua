-- [[ Basic Autocommands ]]
-----------------------------------------------------------------------------------------------
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- autocommand to see diagnostic message when hovering over error
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float {
      scope = 'cursor',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    }
  end,
})

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

-- Function to check for changes and prompt for commit
local function prompt_and_commit_notes()
  -- OPTION A: Handle unsaved changes
  -- If you have unsaved changes, Neovim will first prompt you to save/discard.
  -- The commit prompt will appear *after* you've handled those unsaved changes.
  -- This is generally the safest approach.

  -- OPTION B: Force write all modified buffers before proceeding
  -- WARNING: This will save any unsaved changes in any buffer across all windows!
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
        -- Prompt for commit message - FIX: Removed 'string' completion argument
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
              -- Optionally print the push output for debugging if needed:
              -- print("Push output: \n" .. push_result)
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
vim.api.nvim_create_autocmd('QuitPre', {
  group = AUTO_COMMIT_NOTES_GROUP,
  callback = prompt_and_commit_notes,
  desc = 'Prompt to commit and push notes on Neovim exit if in target directory',
})
