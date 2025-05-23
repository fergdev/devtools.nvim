local M = {}

M.decode_jwt = require("devtools.core.jwt").decode
M.decode_timestamp = require("devtools.core.timestamp").decode

return M
