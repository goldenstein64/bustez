# BustEZ

[TestEZ's](https://github.com/Roblox/testez) `expect()` pattern embedded into the [luassert](https://github.com/lunarmodules/luassert) library.

This is done by registering expectations and modifiers not found in `luassert` and adding an `expect` implementation, which is just a wrapper for `luassert's` `assert()`.

## Usage

Write a Lua script that sets `expect` to the `bustez` module.

```lua
-- helper.lua
expect = require 'bustez'
```

And set this script as a helper in your `.busted` config.

```lua
-- .busted
return {
	default = {
		-- ...
		helper = "path/to/helper.lua"
	}
}
```

Now you can write your expectations in Busted like you would in a TestEZ environment.

```lua
describe("some test assertions", function()
	it("can run", function()
		expect(someValue).to.be.ok()
		expect({ 1, 2, 3 }).to.be.like({ 1, 2, 3 })
	end)
end)
```
