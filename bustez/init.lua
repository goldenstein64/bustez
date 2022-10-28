require("luassert")

local applyAssertions = require("bustez.assertions")
local applyModifiers = require("bustez.modifiers")

---@overload fun(value: any): Expectation
local expect = require("bustez.expect")

applyAssertions()
applyModifiers()

return expect