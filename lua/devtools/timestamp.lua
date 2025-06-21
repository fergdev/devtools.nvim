local M = {}

function M.decode(input)
	local ts = tonumber(input:match("%d+"))
	if not ts or ts < 1000000000 or ts > 99999999999 then
		return nil, "Not a valid UNIX timestamp"
	end
	return os.date("%Y-%m-%d %H:%M:%S", ts)
end

function M.decode_nanos(input)
	local ts = tonumber(input:match("%d+"))
	if not ts then
		return nil, "Not a number"
	end

	-- Normalize to seconds based on length
	local len = #tostring(ts)
	if len > 10 then
		ts = ts / 10 ^ (len - 10)
	end

	if ts < 1000000000 or ts > 99999999999 then
		return nil, "Not a valid UNIX timestamp"
	end

	return os.date("%Y-%m-%d %H:%M:%S", ts)
end

return M
