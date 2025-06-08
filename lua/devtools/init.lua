local M = {}

-- TODO: add register support
local config = { output = "notify" }
function M.setup(user_opts)
	vim.notify("Setting up devtools with user options: " .. vim.inspect(user_opts), vim.log.levels.INFO)
	config = vim.tbl_deep_extend("force", config, user_opts or config)
end

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

local replace = function(txt)
	if vim.fn.mode() == "v" then
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3] - 1, { txt })
	else
		vim.api.nvim_set_current_line(txt)
	end
end

local display = function(result)
	if config.output == "notify" then
		vim.notify("Header:\n" .. vim.inspect(result.header))
		vim.notify("Payload:\n" .. vim.inspect(result.payload))
	elseif config.output == "replace" then
		replace("Header:\n" .. vim.inspect(result.header) .. "\n\nPayload:\n" .. vim.inspect(result.payload))
	elseif config.output == "buffer" then
		local lines = type(result) == "string" and vim.split(result, "\n") or result
		local buf = vim.api.nvim_create_buf(false, true) -- [listed = false], [scratch = true]
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.cmd("vsplit") -- or use `split`, `tabnew`, etc.
		vim.api.nvim_win_set_buf(0, buf)
		vim.bo.filetype = "json" -- or plaintext, log, etc.
		vim.bo.bufhidden = "wipe"
		vim.bo.modifiable = true
	elseif config.output == "register" then
		vim.fn.setreg('"', result)
	end
end

vim.keymap.set({ "v", "n" }, "<leader>tdj", function()
	local txt = selection()
	local jwt = require("devtools.core.jwt")

	local result, err = jwt.decode(txt)
	if not result then
		return vim.notify("Error decoding jwt " .. err, vim.log.levels.ERROR)
	end

	local json = vim.fn.json_encode(result)
	local lines = vim.split(json, "\n")
	display(lines)
end, { desc = "Decode JWT selection" })

vim.keymap.set("n", "<leader>tdb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_decode(line)
	if not result then
		return vim.notify("Could not decode " .. line, vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Decode base64 on line" })

vim.keymap.set({ "v", "n" }, "<leader>teb", function()
	local txt = selection()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(txt)
	if not result then
		return vim.notify("Could not encode " .. selection, vim.log.levels.ERROR)
	end

	display(result)
end, { desc = "Encode base64 on line" })

vim.keymap.set({ "n", "v" }, "<leader>teb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(line)
	if not result then
		return vim.notify("Could not encode " .. result, vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Encode base64 on line" })

vim.keymap.set({ "n", "v" }, "<leader>tdt", function()
	local txt = vim.api.nvim_get_current_line()
	local ts = require("devtools.core.timestamp")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify("Error decoding " .. err, vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Decode UNIX timestamp from line" })

vim.keymap.set({ "v", "n" }, "<leader>tdn", function()
	local txt = selection()
	local ts = require("devtools.core.timestamp")
	local result, err = ts.decode_nanos(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Decode UNIX timestamp nanos from selection" })

vim.keymap.set({ "v", "n" }, "<leader>teh", function()
	local txt = selection()
	local ts = require("devtools.core.hex")
	local result, err = ts.encode(txt)
	if not result then
		return vim.notify(err or "Encode error", vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Encode hex" })

vim.keymap.set({ "v", "n" }, "<leader>tdh", function()
	local txt = selection()
	local ts = require("devtools.core.hex")
	local result, err = ts.decode(txt)
	if not result then
		return vim.notify(err or "Decode error", vim.log.levels.ERROR)
	end
	display(result)
end, { desc = "Decode hex" })

return M
