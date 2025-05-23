local M = {}

function M.decode(line)
  local base64url_decode = require("devtools.core.base64").base64url_decode

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
