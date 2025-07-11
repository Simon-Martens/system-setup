-- Ensure you have telescope.nvim installed and configured.

-- Function to get the visually selected text
local function get_visual_selection()
  -- Temporarily yank the visual selection into the unnamed register
  -- We save and restore the previous content of the register to avoid clobbering it.
  local old_reg = vim.fn.getreg '"'
  local old_reg_type = vim.fn.getregtype '"'

  -- The 'gv' reselects the last visual selection, 'y' yanks it.
  -- Using 'noau' to prevent autocommands from firing during this temporary yank.
  vim.cmd 'noau normal! gvy'
  local selection = vim.fn.getreg '"'

  -- Restore the original unnamed register contents
  vim.fn.setreg('"', old_reg, old_reg_type)

  -- Trim leading/trailing whitespace (often useful)
  return vim.fn.trim(selection)
end

-- Function to trigger Telescope live_grep with the visual selection
local function live_grep_visual_selection()
  local selection = get_visual_selection()

  if selection == '' then
    -- If selection is empty, you could either do nothing,
    -- or open live_grep with the word under the cursor, or just open live_grep without a query.
    print 'No visual selection to grep. Grepping word under cursor instead.'
    selection = vim.fn.expand '<cword>' -- Get word under cursor
    if selection == '' then
      print 'No word under cursor either. Opening live_grep without a default query.'
    end
  end

  -- Ensure Telescope is available
  local telescope_ok, telescope = pcall(require, 'telescope.builtin')
  if not telescope_ok then
    vim.notify('Telescope plugin not found or error loading it.', vim.log.levels.ERROR)
    return
  end

  telescope.live_grep {
    -- `default_text` prefills the search prompt with your selection.
    default_text = selection,
    -- You can add any other Telescope options here, for example:
    -- results_title = "Live Grep: " .. selection,
    -- layout_strategy = "vertical",
    -- layout_config = { height = 0.9, width = 0.9 },
    -- You can also pass `additional_args` to `rg` if needed:
    -- additional_args = function(opts)
    --   return {"--hidden", "--glob", "!**/.git/*"}
    -- end,
  }
end

-- Create the keymap for visual mode
-- <leader>vg ("Visual Grep") is a common choice, but you can choose what you like.
-- For example, if your leader key is space, this would be "space v g".
vim.keymap.set('v', '<leader>vg', live_grep_visual_selection, {
  noremap = true, -- Non-recursive mapping
  silent = true, -- Don't echo the command
  desc = 'Live grep visual selection (Telescope)',
})

-- Optional: A similar mapping for normal mode to grep the word under the cursor
vim.keymap.set('n', '<leader>lg', function() -- "Leader Live Grep"
  local word = vim.fn.expand '<cword>'
  if word == '' then
    print 'No word under cursor to grep.'
    return
  end

  local telescope_ok, telescope = pcall(require, 'telescope.builtin')
  if not telescope_ok then
    vim.notify('Telescope plugin not found or error loading it.', vim.log.levels.ERROR)
    return
  end

  telescope.live_grep {
    default_text = word,
  }
end, {
  noremap = true,
  silent = true,
  desc = 'Live grep word under cursor (Telescope)',
})
