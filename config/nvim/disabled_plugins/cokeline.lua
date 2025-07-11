return {
  'willothy/nvim-cokeline',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for v0.4.0+
    'nvim-tree/nvim-web-devicons', -- If you want devicons
    'stevearc/resession.nvim', -- Optional, for persistent history
  },
  config = function()
    local get_hex = require('cokeline.hlgroups').get_hl_attr
    local is_picking_focus = require('cokeline.mappings').is_picking_focus
    local is_picking_close = require('cokeline.mappings').is_picking_close

    local red = vim.g.terminal_color_1
    local yellow = vim.g.terminal_color_3

    local function get_c_filename(tab)
      if tab.focused ~= nil and tab.focused.buffer ~= nil then
        return tab.focused.buffer.filename
      end

      if #tab.windows == 0 then
        return '[No Windows]'
      end

      -- local win = tab.windows[1]
      -- if win.buffer == nil then
      --   return '[No Buffer]'
      -- else
      --   return win.buffer.filename
      -- end

      return ''
    end

    require('cokeline').setup {
      show_if_buffers_are_at_least = 1,

      pick = {
        use_filename = true,
      },

      default_hl = {
        -- fg = function(buffer)
        --   return buffer.is_focused and get_hex('ColorColumn', 'bg') or get_hex('Normal', 'fg')
        -- end,
        -- bg = function(buffer)
        --   return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('ColorColumn', 'bg')
        -- end,
      },

      components = {
        -- {
        --   text = ' ',
        -- },
        -- {
        --   text = function(buffer)
        --     return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. ' ' or buffer.devicon.icon
        --   end,
        --   fg = function(buffer)
        --     return (is_picking_focus() and yellow) or (is_picking_close() and red) or buffer.devicon.color
        --   end,
        --   italic = function()
        --     return (is_picking_focus() or is_picking_close())
        --   end,
        --   bold = function()
        --     return (is_picking_focus() or is_picking_close())
        --   end,
        -- },
        -- {
        --   text = function(buffer)
        --     return buffer.unique_prefix
        --   end,
        --   fg = get_hex('Comment', 'fg'),
        --   italic = true,
        -- },
        -- {
        --   text = function(buffer)
        --     return buffer.filename .. ' '
        --   end,
        --   bold = function(buffer)
        --     return buffer.is_focused
        --   end,
        --   underline = function(buffer)
        --     return buffer.is_hovered and not buffer.is_focused
        --   end,
        -- },
        -- {
        --   text = ' ',
        -- },
      },

      tabs = {
        --     placement = 'right',
        --     components = {
        --       {
        --         text = function(tab)
        --           return ' ' .. tab.number .. ' '
        --         end,
        --         fg = function(tab)
        --           return tab.is_active and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
        --         end,
        --         bold = function(tab)
        --           return tab.is_active
        --         end,
        --       },
        --     },
      },
    }

    -- Mappings
    local map = vim.api.nvim_set_keymap

    -- Move to previous/next / Buffer / Tabs
    map('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
    map('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true })
    map('n', ',', '<Plug>(cokeline-pick-focus)', { silent = true })
  end,
}
