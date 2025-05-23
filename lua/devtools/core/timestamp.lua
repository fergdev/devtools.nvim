local M = {}

function M.decode(input)
  local ts = tonumber(input:match("%d+"))
  if not ts or ts < 1000000000 or ts > 99999999999 then
    return nil, "Not a valid UNIX timestamp"
  end
  return os.date("%Y-%m-%d %H:%M:%S", ts)
end

return M
