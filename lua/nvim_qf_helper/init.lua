local NvimQfHelper = require("nvim_qf_helper.main")
local nqfh = NvimQfHelper.new()


return setmetatable({},{
  __index = function (_, method)
    return function (...)
      local args = { ... }
      local f = nqfh[method]
      if f then
        f(nqfh, unpack(args))

      else
        nqfh:warn("Unknown method: " .. method)
      end
    end
  end,
})
