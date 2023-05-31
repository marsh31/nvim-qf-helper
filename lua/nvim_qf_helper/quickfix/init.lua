-- NAME:
-- AUTHOR: marsh
-- NOTE:
--

M = {}

local function get_type(winid)
  local info = vim.fn.getwininfo(winid)

  if not info or not info[1].loclist or not info[1].quickfix then
    return "n"
  end

  if info[1].loclist == 1 then
    return "l"
  elseif info[1].quickfix == 1 then
    return "c"
  else
    return "n"
  end
end

M.get_qf_info_by_current_window = function()
  local winid = vim.fn.win_getid()
  local type = get_type(winid)

  local list
  if type == "n" then
    list = nil
  elseif type == "c" then
    list = vim.fn.getqflist()
  elseif type == "l" then
    list = vim.fn.getloclist(winid)
  end

  if not list then
    warn "quickfix window is not exist"
    return nil
  end

  return list
end

M.get_qf_info_by_current_line = function()
  local list = M.get_qf_info_by_current_window()

  if list ~= nil then
    return list[vim.fn.line "."]
  else
    return nil
  end
end

return M
