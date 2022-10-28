local expect = require("bustez")

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

-- It would make more sense for these arguments to be swapped, I think...
expect("some").to.match("some string")
expect("string").to.match("some string")
expect("^%s+$").to.match("\t \t   \n")
expect("[a-z]*").to.match("abcd")