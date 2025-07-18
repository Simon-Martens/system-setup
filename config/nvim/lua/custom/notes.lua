-- Autocmd for Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt.relativenumber = false
    vim.opt_local.wrap = true -- Enable wrap for Markdown files
    vim.opt_local.linebreak = true -- Ensure whole words wrap
    vim.opt_local.breakindent = true -- Make wrapped lines indent correctly
    vim.opt_local.textwidth = 0 -- Ensure no hard wrapping from textwidth
    vim.opt_local.wrapmargin = 0 -- Ensure no hard wrapping from wrapmargin
    vim.opt_local.conceallevel = 2
    -- Optional: Set a string to indicate wrapped lines
    -- vim.opt_local.showbreak = "↳ "
  end,
  desc = 'Set word wrap for Markdown files',
})

local TARGET_DIR = vim.fn.expand '~' .. '/source/texte'
local AUTO_COMMIT_NOTES_GROUP = vim.api.nvim_create_augroup('AutoCommitNotesGroup', { clear = true })

-- --- Check the environment variable for notes mode ---
local is_notes_mode = vim.env.NVIM_NOTES_MODE == 'true'
-- ----------------------------------------------------

-- Function to check for changes and prompt for commit
local function prompt_and_commit_notes()
  if not is_notes_mode then
    return
  end

  -- Force write all modified buffers before proceeding:
  -- vim.cmd('wa')

  local current_cwd = vim.fn.getcwd()

  if current_cwd == TARGET_DIR then
    local status_output = vim.fn.systemlist('git -C ' .. TARGET_DIR .. ' status --porcelain')

    if #status_output > 0 then
      local status_string = table.concat(status_output, '\n')
      local confirmation_prompt = 'Commit the following changes?\n\n' .. status_string .. '\n'
      local confirm = vim.fn.confirm(confirmation_prompt, '&Yes\n&No', 2)

      if confirm == 1 then
        print 'Stageing changes...'
        vim.fn.system('git -C ' .. TARGET_DIR .. ' add .')

        -- Construct a sensible commit message
        local get_files_cmd = 'git -C ' .. vim.fn.shellescape(TARGET_DIR) .. ' diff --staged --name-only | sed "s/\\.md$//" | paste -sd ", " -'
        local file_list_str = vim.fn.trim(vim.fn.system(get_files_cmd))
        local default_commit_msg = 'Updated ' .. file_list_str
        local commit_msg = vim.fn.input('Enter commit message: ', default_commit_msg)

        -- BUG: What happens if the user enters an empty commit message?
        if commit_msg and #commit_msg > 0 then
          print '\nCommitting changes...'

          local commit_result = vim.fn.system('git -C ' .. TARGET_DIR .. " commit -m '" .. commit_msg .. "'")

          if vim.v.shell_error == 0 then
            print 'Successfully committed changes.'
            print 'Attempting to push changes...'

            -- WARNING: All errors for pushing get ignored. We can't handle upstream changes or conflicts here.
            local push_result = vim.fn.system('git -C ' .. TARGET_DIR .. ' push')
            if vim.v.shell_error == 0 then
              print 'Successfully pushed changes.'
            else
              print 'Git push failed. You may need to push manually.'
              print('Push output: \n' .. push_result)
              vim.fn.input 'Push failed. Press ENTER to exit Neovim.'
            end
          else
            print 'Git commit failed. Output:'
            print(commit_result)
            vim.fn.input 'Commit failed. Press ENTER to exit Neovim.'
          end
        else
          print 'Commit cancelled: No message provided.'
          vim.fn.input 'Commit failed. Press ENTER to exit Neovim.'
        end
      end
    end
  end
end

-- Create an autocommand to run the function before Neovim quits
-- This autocommand is always set, but the callback function itself
-- will conditionally execute based on the environment variable.
vim.api.nvim_create_autocmd('VimLeave', {
  group = AUTO_COMMIT_NOTES_GROUP,
  callback = prompt_and_commit_notes,
  desc = 'Prompt to commit and push notes on Neovim exit if in target directory (only if notes mode)',
})
