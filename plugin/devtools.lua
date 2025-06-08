-- Check if devtools is already loaded
-- if vim.g.loaded_devtools then
-- 	return
-- end
-- vim.g.loaded_devtools = true

local config = { output = "notify" }

local M = {}

function M.setup(user_opts)
	config = vim.tbl_deep_extend("force", config, user_opts or {})
end

local selection = function()
	if vim.fn.mode() == "v" then
		return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	else
		local a = vim.fn.expand("<cWORD>")
		vim.notify("Selected word: " .. a)
		return a
	end
end

local replace = function(txt)
	if vim.fn.mode() == "v" then
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3] - 1, { txt })
	else
		vim.api.nvim_set_current_line(txt)
	end
end

-- vim.keymap.set("n", "<leader>tdj", function()
-- 	local line = vim.api.nvim_get_current_line()
-- 	local jwt = require("devtools.core.jwt")
-- 	local result, err = jwt.decode(line)
-- 	if not result then
-- 		return vim.notify("Error decoding jwt " .. err, vim.log.levels.ERROR)
-- 	end
-- 	vim.notify("Header:\n" .. vim.inspect(result.header))
-- 	vim.notify("Payload:\n" .. vim.inspect(result.payload))
-- end, { desc = "Decode JWT on line" })

vim.keymap.set({ "v", "n" }, "<leader>tdj", function()
	local txt = selection()
	local jwt = require("devtools.core.jwt")

	local result, err = jwt.decode(txt)
	if not result then
		return vim.notify("Error decoding jwt " .. err, vim.log.levels.ERROR)
	end

	if M.config.output == "notify" then
		vim.notify("Header:\n" .. vim.inspect(result.header))
		vim.notify("Payload:\n" .. vim.inspect(result.payload))
	elseif M.config.output == "replace" then
		replace("Header:\n" .. vim.inspect(result.header) .. "\n\nPayload:\n" .. vim.inspect(result.payload))
	-- local header = vim.inspect(result.header)
	-- local payload = vim.inspect(result.payload)
	-- local output = "Header:\n" .. header .. "\n\nPayload:\n" .. payload
	-- vim.api.nvim_set_current_line(output)
	else
		vim.api.notify("Invalid output configuration: " .. M.config.output, vim.log.levels.ERROR)
	end
end, { desc = "Decode JWT selection" })

vim.keymap.set("n", "<leader>tdb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_decode(line)
	if not result then
		return vim.notify("Could not decode " .. line, vim.log.levels.ERROR)
	end
	vim.notify("Base64 decoded :\n" .. result)
end, { desc = "Decode base64 on line" })

vim.keymap.set("v", "<leader>teb", function()
	local txt = selection()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(txt)
	if not result then
		return vim.notify("Could not encode " .. selection, vim.log.levels.ERROR)
	end

	vim.notify("Base64 encode :\n" .. result)
end, { desc = "Encode base64 on line" })

vim.keymap.set("n", "<leader>teb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(line)
	if not result then
		return vim.notify("Could not encode " .. result, vim.log.levels.ERROR)
	end
	vim.notify("Base64 encode :\n" .. result)
end, { desc = "Encode base64 on line" })

vim.keymap.set("v", "<leader>teb", function()
	local line = selection()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(line)
	if not result then
		return vim.notify("Could not encode " .. line, vim.log.levels.ERROR)
	end
	return vim.notify("Base64 encode :\n" .. result)
end, { desc = "Encode base64 on line" })

vim.keymap.set("n", "<leader>tdt", function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.core.timestamp")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	vim.notify("⏱ " .. txt .. " → " .. result)
end, { desc = "Decode UNIX timestamp from line" })

vim.keymap.set("v", "<leader>tdt", function()
	local txt = selection()
	local ts = require("devtools.core.timestamp")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end

	vim.notify("⏱ " .. txt .. " → " .. result)
end, { desc = "Decode UNIX timestamp from selection" })

return M
