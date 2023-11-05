# BustEZ

[TestEZ's](https://github.com/Roblox/testez) `expect()` pattern embedded into the [luassert](https://github.com/lunarmodules/luassert) library.

This is done by registering expectations and modifiers not found in `luassert` and adding an `expect` implementation, which is just a wrapper for `luassert's` `assert()`.

Type definitions for [LuaLS/lua-language-server](https://github.com/LuaLS/lua-language-server) are available at [goldenstein64/bustez-definitions](https://github.com/goldenstein64/bustez-definitions)

## Installation

```sh
luarocks install bustez
```

## Busted Usage

Write a Lua script like this.

```lua
-- helper.lua
local bustez = require("luassert.bustez")
bustez.register()
_G.expect = bustez.expect

--[[ alternatively, you can call the bustez module
_G.expect = require("luassert.bustez")()
--]]
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
    expect({ 1, 2, 3 }).to.look.like({ 1, 2, 3 })
  end)
end)
```

`bustez` returns an API when not called:

```lua
local bustez = require 'luassert.bustez'

-- the expect() function, used in tests
bustez.expect(value) --> Expectation

-- registers all custom modifiers and assertions
bustez.register()
```

In most cases, `expect(value)[CHAIN HERE](...)` is an alias for `assert[CHAIN HERE](value, ...)`. The built-in assertions may have their arguments swapped to provide a better error message.

## Extensions

`expect` accepts any assertions and modifiers created using `luassert`.

```lua
---@class luassert.internal
---@field exist fun(value): luassert.internal

---@class bustez.Expectation
---@field exist fun(): bustez.Expectation

say:set("assertion.exist.positive", "expected to exist, got:\n%s")
say:set("assertion.exist.negative", "expected not to exist, got:\n%s")

local function exist(state, arguments, level)
  return arguments[1] ~= nil
end

assert:register("assertion", "exist", exist, "assertion.exist.positive", "assertion.exist.negative")

-- examples
assert.does.exist(false)
assert.does_not.exist(nil)
expect(true).to.exist()
```

Sometimes, it may be more natural for `expect` to send arguments in a different order.

```lua
assert.matches("^b", "brunt")
expect("brunt").to.match("^b")
```

This can be done for extended assertions using `expect.map_args()`.

```lua
-- swap args 1 and 2, continue as normal for args 3 and beyond
expect.map_args("match", { 2, 1, 3 })
expect.map_args("matches", { 2, 1, 3 })
```

## Assertions

Here is the list of assertions that `expect` accepts.

| Key                                   | Source          |
|---------------------------------------|-----------------|
| `.to.be.ok()`                         | TestEZ          |
| `.to.look.like(value)`                | `assert.same()` |
| `.to.be.like(value)`                  | `assert.same()` |
| `.to.throw(msg?)`                     | TestEZ          |
| `.to.be.a(type)`                      | TestEZ          |
| `.to.be.an(type)`                     | TestEZ          |
| `.to.be._true()`                      | luassert        |
| `.to.be._false()`                     | luassert        |
| `.to.be._nil()`                       | luassert        |
| `.to.be.a.boolean()`                  | luassert        |
| `.to.be.a.number()`                   | luassert        |
| `.to.be.a.string()`                   | luassert        |
| `.to.be.a.table()`                    | luassert        |
| `.to.be.a.userdata()`                 | luassert        |
| `.to.be.a._function()`                | luassert        |
| `.to.be.a.thread()`                   | luassert        |
| `.returned.arguments(...)`            | luassert        |
| `.same(value)`                        | luassert        |
| `.matches(str)`                       | luassert        |
| `.to.match(str)`                      | luassert        |
| `.to.be.near(num, eps?)`              | luassert        |
| `.equals(value)`                      | luassert        |
| `.to.equal(value)`                    | luassert        |
| `.to.be.unique(deep?)`                | luassert        |
| `.to.error(msg?)`                     | luassert        |
| `.errors(msg?)`                       | luassert        |
| `.error.matches(str)`                 | luassert        |
| `.error.match(str)`                   | luassert        |
| `.matches.error(str)`                 | luassert        |
| `.to.match.error(str)`                | luassert        |
| `.to.be.truthy()`                     | luassert        |
| `.to.be.falsy()`                      | luassert        |
| `.array().to.have.holes(len?)`        | luassert        |
| `.spy().to.have.returned.with(...)`   | luassert        |
| `.spy().to.be.called.with(...)`       | luassert        |
| `.spy().to.be.called(times)`          | luassert        |
| `.spy().to.be.called.at.least(times)` | luassert        |
| `.spy().to.be.called.at.most(times)`  | luassert        |

## Modifiers

BustEZ also adds some modifiers to make constructs with `expect` more English-y.

| Key             | Source   |
|-----------------|----------|
| `.to`           | TestEZ   |
| `.be`           | TestEZ   |
| `.been`         | TestEZ   |
| `.have`         | TestEZ   |
| `.was`          | TestEZ   |
| `.at`           | TestEZ   |
| `.never`        | TestEZ   |
| `.is`           | luassert |
| `.are`          | luassert |
| `.has`          | luassert |
| `.does`         | luassert |
| `._not`         | luassert |
| `.no`           | luassert |
| `.message(str)` | luassert |
