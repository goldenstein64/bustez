local luassert = require("luassert.assert")
local say = require("say")
local namespace = require("luassert.namespaces")

local function set_failure_message(state, message)
	if message ~= nil then
		state.failure_message = message
	end
end

local function is_type(state, arguments, level)
  arguments.nofmt = arguments.nofmt or {}
  arguments.nofmt[2] = true
  set_failure_message(state, arguments[3])
  return arguments.n > 1 and type(arguments[1]) == arguments[2]
end

return function()
  say:set("assertion.ok.positive", "Expected %s \nto be ok")
  say:set("assertion.ok.negative", "Expected %s \nto never be ok")
  say:set("assertion.a.positive", "Expected %s \nto be a %s")
  say:set("assertion.a.negative", "Expected %s \nto never be a %s")
  say:set("assertion.like.positive", "Expected %s \nto be like %s")
  say:set("assertion.like.negative", "Expected %s \nto never be like %s")
  say:set("assertion.throw.positive", "Expected a different error.\nCaught:\n%s\nExpected:\n%s")
  say:set("assertion.throw.negative", "Expected no error, but caught:\n%s")

  local truthy = namespace.assertion.truthy.callback
  local same = namespace.assertion.same.callback
  local has_error = namespace.assertion.error.callback
  luassert:register("assertion", "ok", truthy, "assertion.ok.positive", "assertion.ok.negative")
  luassert:register("assertion", "like", same, "assertion.like.positive", "assertion.like.negative")
  luassert:register("assertion", "throw", has_error, "assertion.throw.positive", "assertion.throw.negative")
  luassert:register("assertion", "a", is_type, "assertion.a.positive", "assertion.a.negative")
  luassert:register("assertion", "an", is_type, "assertion.a.positive", "assertion.a.negative")
end