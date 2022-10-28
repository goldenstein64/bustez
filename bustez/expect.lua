---This is a near-exact copy of the `luassert.assert` module with just some key changes

local astate = require("luassert.state")
local luassert = require("luassert.assert")
local util = require 'luassert.util'

-- list of namespaces
local namespace = require("luassert.namespaces")

local expect -- the returned module table

local swappedArgs = {
	same = true,
	matches = true,
	match = true,
	near = true,
	equals = true,
	equal = true,
}

local __state_meta = {

	__call = function(self, ...)
		local keys = util.extract_keys("assertion", self.tokens)

		local assertion
    for _, key in ipairs(keys) do
      assertion = namespace.assertion[key] or assertion
    end
		
		if assertion then
			local value = rawget(self, "value")
			local state = luassert.state()
			state.tokens = self.tokens
			if swappedArgs[assertion.name] then
				return self, state(..., value, select(2, ...))
			else
				return self, state(value, ...)
			end
		end
		
		local state = luassert.state()
		state.tokens = self.tokens
		return self, state(...)
	end,

	__index = function(self, key)
		for token in key:lower():gmatch("[^_]+") do
			table.insert(self.tokens, token)
		end

		return self
	end
}

expect = {
	last_value = nil,

	state = function(value) 
		return setmetatable({ mod = true, tokens = {}, value = value }, __state_meta)
	end,
}

local __meta = {

	-- unlike assert(), expect() does not perform an assertion when called
	__call = function(self, value, ...)
		self.last_value = value
		return self, value, ...
	end,

	__index = function(self, key)
		return rawget(self, key) or rawget(luassert, key) or self.state(rawget(self, "last_value"))[key]
	end,

}

return setmetatable(expect, __meta)
