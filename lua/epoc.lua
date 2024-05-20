---@class Config
local config = {
  date_format = "%m/%d/%Y %H:%M %p",
}

---@class Epoc
local M = {}
M.popup_win = nil
M.popup_buf = nil
M.config = {}

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or config)
end

---@return number?
M.get_number_under_cursor = function()
  if M.config.date_format == nil then
    M.setup()
  end
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local start_col = col
  local end_col = col
  while start_col > 0 and line:sub(start_col, start_col):match("%d") do
    start_col = start_col - 1
  end
  start_col = start_col + 1
  while end_col <= #line and line:sub(end_col, end_col):match("%d") do
    end_col = end_col + 1
  end
  local result = line:sub(start_col, end_col - 1)
  if line == "" then
    return nil
  end
  return tonumber(result)
end

---@return string?
M.convert_epoch_time_under_cursor_into_clipboard = function()
  local num = M.get_number_under_cursor()
  if num == nil then
    print("No number found under cursor")
    return nil
  end
  local result = M.convert(num)
  vim.api.nvim_call_function("setreg", { '+"', result })
  return result
end

---@return number
M.current_time_to_epoc_time = function()
  local result = os.time()
  vim.api.nvim_call_function("setreg", { '+"', result })
  return result
end

M.convert_and_popup = function()
  local result = M.convert_epoch_time_under_cursor_into_clipboard()
  if result == nil then
    return
  end
  M.popup(result)
end

---@param content string
M.popup = function(content)
  M.popup_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(M.popup_buf, 0, -1, false, vim.split(content, "\n"))

  local width = vim.fn.strdisplaywidth(content)
  local height = #vim.split(content, "\n")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local opts = {
    relative = "win",
    bufpos = { row - 1, col - 1 },
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  }

  M.popup_win = vim.api.nvim_open_win(M.popup_buf, false, opts)
  vim.api.nvim_command("autocmd CursorMoved,CursorMovedI * ++once lua require('epoc').close_popup()")
end

M.close_popup = function()
  if M.popup_win ~= nil and vim.api.nvim_win_is_valid(M.popup_win) then
    vim.api.nvim_win_close(M.popup_win, true)
  end
  if M.popup_buf ~= nil and vim.api.nvim_buf_is_valid(M.popup_buf) then
    vim.api.nvim_buf_delete(M.popup_buf, { force = true })
  end
end

---@param num number
---@return string
M.convert = function(num)
  if M.config.date_format == nil then
    M.setup()
  end
  return tostring(os.date(M.config.date_format, num))
end

return M
