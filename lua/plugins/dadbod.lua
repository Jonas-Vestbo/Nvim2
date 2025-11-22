return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },

    -- Initialization (global vars)
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,

    -- Runtime configuration
    config = function()
      -- Simple toggle: open DBUI, and on next press close DBUI + its buffers
      vim.keymap.set("n", "<leader>db", function()
        local api = vim.api
        local dbui_open = false

        -- Check if any DBUI window is open
        for _, win in ipairs(api.nvim_list_wins()) do
          local buf = api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype

          if ft == "dbui" then
            dbui_open = true
            -- Close the DBUI window
            api.nvim_win_close(win, true)
            break
          end
        end

        -- If no DBUI window was open, just open it and return
        if not dbui_open then
          vim.cmd("DBUI")
          return
        end

        ----------------------------------------------------------------------
        -- After closing DBUI, clean ALL DBUI-related buffers
        for _, buf in ipairs(api.nvim_list_bufs()) do
          local ft = vim.bo[buf].filetype
          local name = api.nvim_buf_get_name(buf)

          -- UI buffers
          if ft == "dbui" then
            pcall(api.nvim_buf_delete, buf, { force = true })
          end

          -- Query/result buffers (*.dbout in /tmp/)
          if ft == "sql" and name:match("/tmp/nvim%.%w+/db") then
            pcall(api.nvim_buf_delete, buf, { force = true })
          end
        end
      end, { desc = "Toggle DBUI (open/cleanup)" })
    end,
  },
}
