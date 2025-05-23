local M = {}

local function base64url_decode(input)
  input = input:gsub("-", "+"):gsub("_", "/")
  local pad = #input % 4
  if pad == 2 then input = input .. "=="
  elseif pad == 3 then input = input .. "="
  elseif pad ~= 0 then return nil, "Invalid base64url string"
  end
  local decoded = vim.fn.system("base64 --decode", input)
  if vim.v.shell_error ~= 0 then return nil, "base64 decode failed" end
  return vim.fn.json_decode(decoded)
end

function M.decode(line)
  local header_b64, payload_b64 = line:match("([^%.]+)%.([^%.]+)%.")
  if not header_b64 or not payload_b64 then return nil, "Invalid JWT format" end

  local header, err1 = base64url_decode(header_b64)
  local payload, err2 = base64url_decode(payload_b64)

  if not header then return nil, err1 end
  if not payload then return nil, err2 end

  return {
    header = header,
    payload = payload,
  }
end

return M
