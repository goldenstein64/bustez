---This is a near-exact copy of the `luassert.assert` module with just some key changes

local astate = require("luassert.state")
local luassert = require("luassert")
local util = require("luassert.util")
local say = require("say")

-- list of namespaces
local namespace = require("luassert.namespaces")

local old_error_level = util.errorlevel

-- overwriting vanilla util.errorlevel so it points to the test file
function util.errorlevel(level)
	local oldlevel = old_error_level(level)
	local info = debug.getinfo(oldlevel + 1, "S")
	if info.short_src:find("bustez[/\\]expect.lua$") then
		return oldlevel + 1
	else
		return oldlevel
	end
end

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

local function applyArgMap(mapping, ...)
	local args = util.pack(...)

	local newArgs = { n = 0 }
	for i = 1, #mapping - 1 do
		local index = mapping[i]
		util.tinsert(newArgs, args[index])
	end

	local lastIndex = mapping[#mapping]
	for index = lastIndex, args.n do
		util.tinsert(newArgs, args[index])
	end

	local n = (#mapping - 1) + (args.n - lastIndex + 1)
	return util.unpack(newArgs, 1, n)
end

local argMap
do
	local default = { 1 }
	local swapped = { 2, 1, 3 }
	local noValue = { 2 }

	argMap = {
		same = swapped,
		matches = swapped,
		match = swapped,
		near = swapped,
		equals = swapped,
		equal = swapped,

		holes = noValue,
		called = noValue,
		called_with = noValue,
		returned_with = noValue,
		called_at_least = noValue,
		called_at_most = noValue,
	}

	setmetatable(argMap, {
		__index = function()
			return default
		end,
	})
end

---the returned module table
local expect

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

			local arguments = util.make_arglist(applyArgMap(argMap[assertion.name], subject, ...))
			local val, retargs = assertion.callback(self, arguments, util.errorlevel())

			if (not val) == self.mod then
				local message = assertion.positive_message
				if not self.mod then
					message = assertion.negative_message
				end
				local err = geterror(message, rawget(self, "failure_message"), arguments)
				error(err or "assertion failed!", util.errorlevel())
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

expect = {
	state = function(value)
		return setmetatable({ mod = true, tokens = {}, subject_value = value }, __state_meta)
	end,

	map_args = function(assertion_name, map)
		argMap[assertion_name] = (not map or #map ~= 0) and map or nil
	end,
}

local __meta = {

	-- unlike assert(), expect() does not perform an assertion when called
	__call = function(self, value, ...)
		return expect.state(value)
	end,

	__index = function(self, key)
		return rawget(self, key) or rawget(luassert, key) or expect.state(nil)[key]
	end,
}

return setmetatable(expect, __meta)
