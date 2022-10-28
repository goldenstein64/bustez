local luassert = require("luassert.assert")

local function is(state)
	return state
end

local function is_not(state)
	state.mod = not state.mod
	return state
end

return function()
  luassert:register("modifier", "to", is)
  luassert:register("modifier", "be", is)
  luassert:register("modifier", "been", is)
  luassert:register("modifier", "have", is)
  luassert:register("modifier", "was", is)
  luassert:register("modifier", "at", is)
  luassert:register("modifier", "never", is_not)
end

