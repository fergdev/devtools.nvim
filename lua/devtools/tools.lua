local M = {}

local selection = function()
	if vim.fn.mode() == "v" then
		return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	else
		-- TODO: select till non base64 encoded character, well for jwt
		local a = vim.fn.expand("<cWORD>")
		vim.notify("Selected word: " .. a)
		return a
	end
end

M.decode_jwt = function()
	local txt = selection()
	local jwt = require("devtools.jwt")

	local result, err = jwt.decode(txt)
	if not result then
		return vim.notify("Error decoding jwt " .. err, vim.log.levels.ERROR)
	end

	local json = vim.fn.json_encode(result)
	local lines = vim.split(json, "\n")
	return lines
end

M.decode_base64 = function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.base64")
	local result = base64.base64_decode(line)
	if not result then
		return vim.notify("Could not decode " .. line, vim.log.levels.ERROR)
	end
	return result
end

M.encode_base64 = function()
	local txt = selection()
	local base64 = require("devtools.base64")
	local result = base64.base64_encode(txt)
	if not result then
		return vim.notify("Could not encode " .. selection, vim.log.levels.ERROR)
	end
	return result
end

M.decode_unix_timestamp = function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.timestamp")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	return result
end

M.decode_unix_timestamp_nanos = function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.timestamp")
	local result, err = ts.decode_nanos(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	return result
end

M.encode_unix_timestamp = function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.timestamp")
	local result, err = ts.encode(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	return result
end

M.encode_unix_timestamp_nanos = function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.timestamp")
	local result, err = ts.encode_unix_timestamp_nanos(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	return result
end

M.encode_hex = function()
	local txt = selection()
	local ts = require("devtools.hex")
	local result, err = ts.encode(txt)
	if not result then
		return vim.notify(err or "Encode error", vim.log.levels.ERROR)
	end
	return result
end

M.dencode_hex = function()
	local txt = selection()
	local ts = require("devtools.hex")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end
	return result
end

M.encode_md5 = function()
	local txt = selection()
	local ts = require("devtools.md5")
	local result, err = ts.encode(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end
	return result
end

M.decode_md5 = function()
	local txt = selection()
	local ts = require("devtools.md5")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end
	return result
end

return M
