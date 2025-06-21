local M = {}

function M.base64_decode(input)
	local decoded = vim.fn.system("base64 --decode", input)
	return decoded
end
function M.base64_encode(input)
	local encoded = vim.fn.system("base64", input)
	return encoded
end

function M.base64url_decode(input)
	input = input:gsub("-", "+"):gsub("_", "/")
	local pad = #input % 4
	if pad == 2 then
		input = input .. "=="
	elseif pad == 3 then
		input = input .. "="
	elseif pad ~= 0 then
		return nil, "Invalid base64url string"
	end
	local decoded = vim.fn.system("base64 --decode", input)
	if vim.v.shell_error ~= 0 then
		return nil, "base64 decode failed"
	end
	return vim.fn.json_decode(decoded)
end

return M
