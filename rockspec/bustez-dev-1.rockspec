package = "bustez"
version = "dev-1"
source = {
	url = "git+https://github.com/goldenstein64/bustez.git",
}
description = {
	detailed = "This is done by registering expectations and modifiers not found in `luassert` and adding an `expect` implementation, which is just a wrapper for `luassert's` `assert()`.",
	homepage = "https://github.com/goldenstein64/bustez",
	license = "MIT",
}
dependencies = {
	"lua >= 5.1",
	"luassert >= 1.9.0-1",
	"say >= 1.4.1",
}
build = {
	type = "builtin",
	modules = {
		["bustez.expect"] = "bustez/expect.lua",
		["bustez.init"] = "bustez/init.lua",
		["bustez.register"] = "bustez/register.lua",
	},
}
