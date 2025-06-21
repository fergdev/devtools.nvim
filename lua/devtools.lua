local M = {}

local tools = require("devtools.tools")

M.default_encode = {
	{ keymap = "b", method = tools.encode_base64, description = "base64" },
	{ keymap = "t", method = tools.encode_unix_timestamp, description = "timestamp" },
	{ keymap = "n", method = tools.encode_unix_timestamp_nanos, description = "timestamp-nanos" },
	{ keymap = "h", method = tools.encode_hex, description = "hex" },
}
M.default_decode = {
	{ keymap = "j", method = tools.decode_jwt, description = "jwt" },
	{ keymap = "b", method = tools.decode_base64, description = "base64" },
	{ keymap = "t", method = tools.encode_unix_timestamp, description = "timestamp" },
	{ keymap = "n", method = tools.decode_unix_timestamp_nanos, description = "timestamp-nanos" },
	{ keymap = "h", method = tools.dencode_hex, description = "hex" },
}

local ValidOutputs = {
	Window = "window",
	Buffer = "buffer",
}

local ensure_config = function(config)
	for _, v in pairs(ValidOutputs) do
		if config.output == v then
			return true
		end
	end
	return false
end

local config = { output = "window", prefix = "<leader>" }

local display = function(result)
	local lines = type(result) == "string" and vim.split(result, "\n") or result
	if config.output == "buffer" then
		local buf = vim.api.nvim_create_buf(false, true) -- [listed = false], [scratch = true]
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.cmd("vsplit")
		vim.api.nvim_win_set_buf(0, buf)
		vim.bo.filetype = "json"
		vim.bo.bufhidden = "wipe"
		vim.bo.modifiable = true
	elseif config.output == "window" then
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].filetype = "text"

		vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = 40,
			height = 10,
			row = 10,
			col = 10,
			style = "minimal",
			border = "rounded",
		})

		-- Set 'q' to close only this buffer
		vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
	else
		vim.notify("Invalid output " .. config.output, vim.log.levels.ERROR, {
			title = "DevTools",
			timeout = 3000,
		})
	end
end

function M.setup(user_opts)
	config = vim.tbl_deep_extend("force", config, user_opts or config)
	if not ensure_config(config) then
		vim.notify("Invalid configuration for DevTools", vim.log.levels.ERROR, {
			title = "DevTools",
			timeout = 3000,
		})
	end

	for _, enc in ipairs(M.default_encode) do
		vim.keymap.set({ "v", "n" }, config.prefix .. "e" .. enc.keymap, function()
			display(enc.method())
		end, { desc = "Encode " .. enc.description })
	end

	for _, dec in ipairs(M.default_encode) do
		vim.keymap.set({ "v", "n" }, config.prefix .. "d" .. dec.keymap, function()
			display(dec.method())
		end, { desc = "Decode " .. dec.description })
	end
end

return M
