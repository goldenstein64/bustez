local bustez = {
	register = require("luassert.bustez.register"),
	expect = require("luassert.bustez.expect"),
}

local bustezMt = {}

function bustezMt:__call()
	self.register()
	return self.expect
end

setmetatable(bustez, bustezMt)

return bustez
