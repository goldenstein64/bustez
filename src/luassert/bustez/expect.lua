---This is a near-exact copy of the `luassert.assert` module with just some key changes

local astate = require("luassert.state")
local luassert = require("luassert")
local util = require("luassert.util")
local say = require("say")

-- This is needed to be used for busted to
-- properly recognize it as fail on reporter(and not as error).
local fail
local success, _ = pcall(function()
	fail = require("busted.core")().fail
end)
-- Falls back to normal error in case busted is not used.
if not success then
	fail = error
end

-- list of namespaces
local namespace = require("luassert.namespaces")

local function geterror(assertion_message, failure_message, args)
	if util.hastostring(failure_message) then
		failure_message = tostring(failure_message)
	elseif failure_message ~= nil then
		failure_message = astate.format_argument(failure_message)
	end
	local message = say(assertion_message, luassert:format(args))
	if message and failure_message then
		message = failure_message .. "\n" .. message
	end
	return message or failure_message
end

local function apply_arg_map(mapping, ...)
	local args = util.pack(...)

	local new_args = { n = 0 }
	for i = 1, #mapping - 1 do
		local index = mapping[i]
		util.tinsert(new_args, args[index])
	end

	local last_index = mapping[#mapping]
	for index = last_index, args.n do
		util.tinsert(new_args, args[index])
	end

	local n = #mapping + args.n - last_index
	return util.unpack(new_args, 1, n)
end

local arg_map
do
	local default = { 1 }
	local swapped = { 2, 1, 3 }
	local no_value = { 2 }

	arg_map = {
		same = swapped,
		matches = swapped,
		match = swapped,
		near = swapped,
		equals = swapped,
		equal = swapped,

		holes = no_value,
		called = no_value,
		called_with = no_value,
		returned_with = no_value,
		called_at_least = no_value,
		called_at_most = no_value,
	}

	setmetatable(arg_map, {
		__index = function()
			return default
		end,
	})
end

local __state_meta = {

	__call = function(self, ...)
		local keys = util.extract_keys("assertion", self.tokens)

		local assertion
		for _, key in ipairs(keys) do
			assertion = namespace.assertion[key] or assertion
		end

		local subject = rawget(self, "subject_value")

		if assertion then
			for _, key in ipairs(keys) do
				if namespace.modifier[key] then
					namespace.modifier[key].callback(self)
				end
			end

			local arguments = util.make_arglist(apply_arg_map(arg_map[assertion.name], subject, ...))
			local val, retargs = assertion.callback(self, arguments, util.errorlevel())

			if (not val) == self.mod then
				local message = assertion.positive_message
				if not self.mod then
					message = assertion.negative_message
				end
				local err = geterror(message, rawget(self, "failure_message"), arguments)
				fail(err or "assertion failed!", util.errorlevel())
			end

			if retargs then
				return util.unpack(retargs)
			end
			return ...
		else
			local arguments = util.make_arglist(...)
			self.tokens = {}

			for _, key in ipairs(keys) do
				if namespace.modifier[key] then
					namespace.modifier[key].callback(self, arguments, util.errorlevel())
				end
			end
		end

		return self
	end,

	__index = function(self, key)
		for token in key:lower():gmatch("[^_]+") do
			table.insert(self.tokens, token)
		end

		return self
	end,
}

local expect = {
	state = function(value)
		return setmetatable({ mod = true, tokens = {}, subject_value = value }, __state_meta)
	end,

	map_args = function(assertion_name, map)
		arg_map[assertion_name] = (not map or #map ~= 0) and map or nil
	end,
}

local __meta = {

	-- unlike assert(), expect() does not perform an assertion when called
	__call = function(self, value, ...)
		return expect.state(value)
	end,

	__index = function(self, key)
		return rawget(luassert, key) or self.state(nil)[key]
	end,
}

return setmetatable(expect, __meta)
