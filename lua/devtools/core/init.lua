local M = {}

M.decode_jwt = require("devtools.core.jwt").decode
M.decode_timestamp = require("devtools.core.timestamp").decode
M.base64 = require("devtools.core.base64").decode

return M
