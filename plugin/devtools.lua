-- Check if devtools is already loaded
if vim.g.loaded_devtools then
	return
end
vim.g.loaded_devtools = true

vim.keymap.set("n", "<leader>tdj", function()
	local line = vim.api.nvim_get_current_line()
	local jwt = require("devtools.core.jwt")
	local result, err = jwt.decode(line)
	if not result then
		return vim.notify(err, vim.log.levels.ERROR)
	end
	vim.notify("Header:\n" .. vim.inspect(result.header))
	vim.notify("Payload:\n" .. vim.inspect(result.payload))
end, { desc = "Decode JWT on line" })

vim.keymap.set("n", "<leader>tdb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_decode(line)
	if not result then
		return vim.notify("Could not decode " .. line, vim.log.levels.ERROR)
	end
	vim.notify("Base64 decoded :\n" .. result)
end, { desc = "Decode base64 on line" })

vim.keymap.set("n", "<leader>teb", function()
	local line = vim.api.nvim_get_current_line()
	local base64 = require("devtools.core.base64")
	local result = base64.base64_encode(line)
	if not result then
		return vim.notify("Could not encode " .. result, vim.log.levels.ERROR)
	end
	vim.notify("Base64 encode :\n" .. result)
end, { desc = "Encode base64 on line" })

vim.keymap.set("v", "<leader>tdt", function()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
	lines[1] = string.sub(lines[1], start_pos[3])
	if #lines > 1 then
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end
	local input = table.concat(lines, "\n"):gsub("^%s*(.-)%s*$", "%1")

	local ts = require("devtools.core.timestamp")
	local result, err = ts.decode(input)
	if not result then
		return vim.notify(err, vim.log.levels.ERROR)
	end
	vim.notify("⏱ " .. input .. " → " .. result)
end, { desc = "Decode UNIX timestamp from selection" })
