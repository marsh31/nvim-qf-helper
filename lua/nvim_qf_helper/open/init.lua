local M = {}

local opner = {
  "vnew",
  "new",
  "split",
  "vsplit",
  "tabnew",
  "botright",
  "topleft",
  "rightbelow",
  "leftabove",
  "vertical",
}

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

M.open = function(opener)
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
    warn "Quickfix window is not exist"
    return
  end


  local info = list[vim.fn.line(".")]
  vim.cmd(("%s %s"):format(opener, vim.fn.bufname(info.bufnr)))
  vim.fn.cursor(info.lnum, info.col)
end

-- @param msg string
-- @return nil
function warn(msg)
  vim.notify("[nvim_qf_helper.open] " .. msg, vim.log.levels.WARN)
end

return M
