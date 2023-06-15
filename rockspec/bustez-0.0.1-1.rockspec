package = "bustez"
version = "0.0.1-1"
source = {
	url = "git+https://github.com/goldenstein64/bustez.git",
	dir = "bustez",
}
description = {
	summary = "TestEZ's expect() framework embedded into Busted",
	detailed = [[
      Roblox TestEZ's `expect()` pattern embedded into the Busted library.
   ]],
	homepage = "https://github.com/goldenstein64/bustez",
	license = "MIT <http://opensource.org/licenses/MIT>",
}
dependencies = {
	"lua >= 5.1",
	"luassert ~> 1.9",
	"say ~> 1.4",
}
build = {
	type = "builtin",
	modules = {
		["bustez.init"] = "bustez/init.lua",
		["bustez.expect"] = "bustez/expect.lua",
		["bustez.register"] = "bustez/register.lua",
	},
}
