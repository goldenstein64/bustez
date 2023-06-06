local expect = require("bustez")()

expect(false).to.never.be.ok()
expect(nil).to.never.be.ok()
expect(true).to.be.ok()

expect(true).to.equal(true)
expect(true).to.never.equal(false)
expect(3).to.equal(3)
expect(1).to.never.equal(2)

expect(1.999).to.be.near(2, 0.01)
expect(1).to.never.be.near(2, 0.1)

expect(true).to.be.a("boolean")
expect(4.5).to.be.a("number")
expect({}).to.be.a("table")

expect(true).to.be.like(true)
expect(true).to.never.be.like(false)
expect({ 1, 2, 3 }).to.be.like({ 1, 2, 3 })
expect({ 45, 50 }).to.never.be.like({ 90, 100 })
expect("value").to.never.be.like(nil)

expect(error).to.throw()
expect(function() end).to.never.throw()

local function assertFalse()
	assert(false)
end
expect(assertFalse).to.throw("assertion failed!")

expect("some string").to.match("some")
expect("some string").to.match("string")
expect("\t \t   \n").to.match("^%s+$")
expect("abcd").to.match("[a-z]*")

---@class bustez.Expectation
expect:extend({
	exist = function(value)
		local pass = value ~= nil
		return {
			pass = pass,
			message = pass and string.format("Expected %s to not exist", value)
				or string.format("Expected %s to exist", value),
		}
	end,
})

expect(false).to.exist()
