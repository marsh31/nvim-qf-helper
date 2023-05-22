-- @class nvim_qf_helper.main.NvimQfHelper
-- @field default_option
-- @field opts
-- @field augroup
local NvimQfHelper = {}

-- @return nvim_qf_helper.main.NvimQfHelper
NvimQfHelper.new = function()
  return setmetatable({
    augroup = vim.api.nvim_create_augroup("nvim_qf_helper", {}),
    default_option = {},
    opts = {},
  }, { __index = NvimQfHelper })
end

-- @return nil
function NvimQfHelper:setup(opts)
  self.opts = vim.tbl_extend("force", self.default_option, opts or {})

  -- validation
  self:enable()
end

-- @return nil
function NvimQfHelper:enable()
  self:disable()
end

-- @return nil
function NvimQfHelper:disable()
  vim.api.nvim_clear_autocmds { group = self.augroup }
end

-- @param msg string
-- @return nil
function NvimQfHelper:warn(msg)
  vim.notify("[nvim_qf_helper] " .. msg, vim.log.levels.WARN)
end

return NvimQfHelper
