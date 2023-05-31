local M = {}

M.open = function(opener, info)
  if info.bufnr ~= nil and info.lnum ~= nil and info.col ~= nil then
    vim.cmd(("%s %s"):format(opener, vim.fn.bufname(info.bufnr)))
    vim.fn.cursor { info.lnum, info.col }

  else
    warn("info is invalid.")
  end
end

-- @param msg string
-- @return nil
function warn(msg)
  vim.notify("[nvim_qf_helper.open] " .. msg, vim.log.levels.WARN)
end

return M
