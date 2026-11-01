-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Remove unused empty buffers after opening a file, without touching drafts or splits.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("clean_empty_buffers", { clear = true }),
  callback = function(event)
    if vim.api.nvim_buf_get_name(event.buf) == "" or vim.bo[event.buf].buftype ~= "" then
      return
    end
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
          and vim.api.nvim_buf_get_name(buf) == "" and not vim.bo[buf].modified
          and #vim.fn.win_findbuf(buf) == 0 and vim.api.nvim_buf_line_count(buf) == 1
          and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
          pcall(vim.api.nvim_buf_delete, buf, {})
        end
      end
    end)
  end,
})
