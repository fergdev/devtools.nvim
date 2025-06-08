local M = {}

M.decode = function(input)
	return (input:gsub("..", function(cc)
		return string.char(tonumber(cc, 16))
	end))
end

M.encode = function(str)
	return (str:gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end))
end

return M
