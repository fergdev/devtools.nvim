-- Check if devtools is already loaded
if vim.g.loaded_devtools then
	return
end
vim.g.loaded_devtools = true

vim.keymap.set("n", "<leader>jd", function()
  local line = vim.api.nvim_get_current_line()
  local jwt = require("devtools.core.jwt")
  local result, err = jwt.decode(line)
  if not result then return vim.notify(err, vim.log.levels.ERROR) end
  vim.notify("Header:\n" .. vim.inspect(result.header))
  vim.notify("Payload:\n" .. vim.inspect(result.payload))
end, { desc = "Decode JWT on line" })

vim.keymap.set("v", "<leader>dt", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  lines[1] = string.sub(lines[1], start_pos[3])
  if #lines > 1 then lines[#lines] = string.sub(lines[#lines], 1, end_pos[3]) end
  local input = table.concat(lines, "\n"):gsub("^%s*(.-)%s*$", "%1")

  local ts = require("devtools.core.timestamp")
  local result, err = ts.decode(input)
  if not result then return vim.notify(err, vim.log.levels.ERROR) end
  vim.notify("⏱ " .. input .. " → " .. result)
end, { desc = "Decode UNIX timestamp from selection" })
