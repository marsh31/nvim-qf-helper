local signature = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- @param msg string
-- @return nil
function info(msg)
  vim.notify("[nvim_qf_helper.selector:INFO] " .. msg, vim.log.levels.INFO)
end

-- @param msg string
-- @return nil
function warn(msg)
  vim.notify("[nvim_qf_helper.selector:WARN] " .. msg, vim.log.levels.WARN)
end

-- @param  num integer
-- @return boolean
local function isAlph(num)
  if (65 <= num and num <= 90) or (97 <= num and num <= 122) then
    return true
  else
    return false
  end
end

-- @return char
local function get_alphabet_keepress()
  local key = vim.fn.getchar()
  while not isAlph(key) do
    warn "Input a key from a to z or A to Z"
    key = vim.fn.getchar()
  end

  return key
end

-- @param  ignore_list [string]
-- @return [integer]
local function get_list_window_ids_filtered_by(ignore_list)
  return vim.tbl_filter(function(winnr)
    local bufno = vim.fn.winbufnr(winnr)
    local buftype = vim.fn.getbufvar(bufno, "&filetype")
    local isOk = true

    for _, ignore in ipairs(ignore_list) do
      isOk = isOk and not (ignore == buftype)
    end
    return isOk
  end, vim.api.nvim_list_wins())
end

-- @class nvim_qf_helper.selector.Selector
-- @field default_option
-- @field opts
local Selector = {}

Selector.new = function()
  return setmetatable({
    window_opts = {
      anchor = "NW",
      border = "rounded",

      col = 1,
      row = 1,
      height = 3,
      width = 3,
      style = "minimal",

      relative = "win",
      win = 0,
    },

    ignore_list = {
      "qf",
      "notify",
    },

    _window_configs = {},
  }, { __index = Selector })
end

-- @return nil
function Selector:clear()
  for _, window in pairs(self._window_configs) do
    if vim.api.nvim_win_is_valid(window.float_id) then
      vim.api.nvim_win_close(window.float_id, true)
    end
  end

  for _ = 1, #self._window_configs do
    table.remove(self._window_configs)
  end
end

-- @return nil
function Selector:select(callback)
  self:clear()

  local window_ids = get_list_window_ids_filtered_by(self.ignore_list)
  if #window_ids == 1 then
    warn "Window is 1. Can not select window"
    return
  end

  for idx, winid in ipairs(window_ids) do
    local new_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, true, {
      "",
      string.format(" %s", string.sub(signature, idx, idx)),
      "",
    })

    local opts = vim.deepcopy(self.window_opts)
    opts.win = winid

    local float_win_id = vim.api.nvim_open_win(new_buf, false, opts)
    self._window_configs[string.sub(signature, idx, idx)] = {
      window_id = winid,
      float_id = float_win_id,
    }
  end

  vim.defer_fn(function()
    local key = get_alphabet_keepress()
    local sig = string.upper(string.char(key))
    while self._window_configs[sig] == nil do
      warn "Please press A to Z"

      key = get_alphabet_keepress()
      sig = string.upper(string.char(key))
    end

    vim.api.nvim_set_current_win(self._window_configs[sig].window_id)
    self:clear()

    callback()
  end, 500)
end

return Selector
