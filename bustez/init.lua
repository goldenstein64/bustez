require("luassert")

local register = require("bustez.register")

---@overload fun(value: any): Expectation
local expect = require("bustez.expect")

register()

return expect