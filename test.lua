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

local function fail()
	error("oh no")
end
expect(fail).to.throw("oh no")
expect(fail).to.never.throw("o")
expect(fail).to.never.throw("Oh no!")

expect(function()
	expect(false).to.be.ok("totally not okay!")
end).to.match_error("totally not okay!")

local function assertFalse()
	assert(false)
end
expect(assertFalse).to.throw("assertion failed!")

expect("some string").to.match("some")
expect("some string").to.match("string")
expect("\t \t   \n").to.match("^%s+$")
expect("abcd").to.match("[a-z]*")

expect.array({ 1, 2, 3 }).to.have.no.holes()
expect.array({ 1, 2, 3 }).to.have.holes(4)
expect.array({ 1, 2, nil, 4 }).to.have.holes()

do
	local funSpy = spy.new(function(...)
		return 1, 2, 3
	end)
	funSpy(8, 10, 12)

	expect.spy(funSpy).to.be.called_with(8, 10, 12)
	expect.spy(funSpy).to.have.returned_with(1, 2, 3)

	funSpy()
	funSpy()

	expect.spy(funSpy).to.be.called(3)
	expect.spy(funSpy).to.be.called.at.least(1)
	expect.spy(funSpy).to.be.called.at.most(5)
end

do
	local obj = { some = function(...) end }
	local funStub = stub(obj, "some")
	obj.some(2, 3, 5)
	expect.stub(funStub).to.be.called_with(2, 3, 5)
end

do
	---@class bustez.Expectation
	---asserts that our expectation is not `nil`
	---@field exist fun(): bustez.Expectation

	say:set("assertion.exist.positive", "Expected to exist, but value was:\n%s")
	say:set("assertion.exist.negative", "Expected to not exist, but value was:\n%s")

	expect.extend({
		exist = function(state, arguments, level)
			return arguments[1] ~= nil
		end,
	})

	expect(false).to.exist()
	expect(nil).to.never.exist()
end

do
	---@class bustez.Expectation
	---asserts that our expectation contains the given field
	---@field field fun(key: string): bustez.Expectation

	say:set("assertion.field.positive", "Expected to have property.\nObject:\n%s\nProperty:\n%s")
	say:set("assertion.field.negative", "Expected not to have property.\nObject:\n%s\nProperty:\n%s")

	---@type bustez.Matcher
	local function field(state, arguments, level)
		if type(arguments[1]) ~= "table" then
			error("expectation must be a table in have_property assertion")
		end

		return arguments[1][arguments[2]] ~= nil
	end

	expect.extend({ field = field })

	expect({ a = 1 }).to.have.field("a")
	expect({}).to.never.have.field("a")
end
