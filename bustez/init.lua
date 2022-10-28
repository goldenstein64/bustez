local bustez = {
	register = require("bustez.register"),
	expect = require("bustez.expect"),
}

local bustezMt = {}

function bustezMt:__call()
	self.register()
	return self.expect
end

setmetatable(bustez, bustezMt)

return bustez
