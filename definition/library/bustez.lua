---@meta

---@class Expectation
local Expectation = {}

Expectation.to = Expectation
Expectation.be = Expectation
Expectation.been = Expectation
Expectation.have = Expectation
Expectation.was = Expectation
Expectation.at = Expectation
Expectation.never = Expectation

---@param message? string
---@return Expectation self
function Expectation.ok(message) end

---@param otherValue any
---@param message? string
---@return Expectation self
function Expectation.equal(otherValue, message) end

---@param otherValue number
---@param epsilon? number
---@param message? string
---@return Expectation self
function Expectation.near(otherValue, epsilon, message) end

---@param expectedType type
---@param message? string
---@return Expectation self
function Expectation.a(expectedType, message) end

Expectation.an = Expectation.a

---@param otherValue any
---@param message? string
---@return Expectation self
function Expectation.like(otherValue, message) end

---@param errorSubstring? string
---@param message? string
---@return Expectation self
function Expectation.throw(errorSubstring, message) end

---@param pattern string
---@param message? string
---@return Expectation self
function Expectation.match(pattern, message) end

---@param value any
---@return Expectation
local function expect(value) end

return expect