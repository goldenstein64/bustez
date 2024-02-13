local bustez = {
	register = require("bustez.register"),
	expect = require("bustez.expect"),
}

local bustez_mt = {}

function bustez_mt:__call()
	self.register()
	return self.expect
end

setmetatable(bustez, bustez_mt)

return bustez
