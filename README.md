# BustEZ

[TestEZ's](https://github.com/Roblox/testez) `expect()` pattern embedded into the [luassert](https://github.com/lunarmodules/luassert) library.

This is done by registering expectations and modifiers not found in `luassert` and adding an `expect` implementation, which is just a wrapper for `luassert's` `assert()`.

Type definitions for [LuaLS/lua-language-server](https://github.com/LuaLS/lua-language-server) are available at [goldenstein64/bustez-definitions](https://github.com/goldenstein64/bustez-definitions)

## Busted Usage

Write a Lua script like this.

```lua
-- helper.lua
local bustez = require("bustez")
bustez.register()
_G.expect = bustez.expect

--[[ alternatively, you can call the bustez module
_G.expect = require("bustez")()
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
local bustez = require 'bustez'

-- the expect() function, used in tests
bustez.expect(value) --> Expectation

-- registers all custom modifiers and assertions
bustez.register()
```

In most cases, `expect(value)[CHAIN HERE](...)` is an alias for `assert[CHAIN HERE](value, ...)`. The built-in assertions may have their arguments swapped to provide a better error message.

Expectations can be added sort of like TestEZ using `expect:extend(...)`.

```lua
---If you're using bustez-definitions, add the @class annotation.
---@class bustez.Expectation
expect:extend({
  exist = function(value)
    local pass = value ~= nil
    return {
      pass = pass,
      message = pass 
        and string.format("expected %s to not exist", value)
         or string.format("expected %s to exist", value),
    }
  end,
})

expect(false).to.exist() --> passes
```

## Assertions

Here is the list of assertions that `expect` accepts.

| Key                               | Source          |
|-----------------------------------|-----------------|
| `.ok()`                           | TestEZ          |
| `.like(value)`                    | `assert.same()` |
| `.throw(msg?)`                    | TestEZ          |
| `.a(type)`                        | TestEZ          |
| `.an(type)`                       | TestEZ          |
| `._true()`                        | Luassert        |
| `._false()`                       | Luassert        |
| `.boolean()`                      | Luassert        |
| `.number()`                       | Luassert        |
| `.string()`                       | Luassert        |
| `.table()`                        | Luassert        |
| `._nil()`                         | Luassert        |
| `.userdata()`                     | Luassert        |
| `._function()`                    | Luassert        |
| `.thread()`                       | Luassert        |
| `.returned_arguments(...)`        | Luassert        |
| `.same(value)`                    | Luassert        |
| `.matches(str)`                   | Luassert        |
| `.match(str)`                     | Luassert        |
| `.near(num, eps?)`                | Luassert        |
| `.equals(value)`                  | Luassert        |
| `.equal(value)`                   | Luassert        |
| `.unique(deep?)`                  | Luassert        |
| `.error(msg?)`                    | Luassert        |
| `.errors(msg?)`                   | Luassert        |
| `.error_matches(str)`             | Luassert        |
| `.error_match(str)`               | Luassert        |
| `.matches_error(str)`             | Luassert        |
| `.match_error(str)`               | Luassert        |
| `.truthy()`                       | Luassert        |
| `.falsy()`                        | Luassert        |
| `.array()...holes(len?)`          | Luassert        |
| `.spy()...returned_with(...)`     | Luassert        |
| `.spy()...called_with(...)`       | Luassert        |
| `.spy()...called(times)`          | Luassert        |
| `.spy()...called_at_least(times)` | Luassert        |
| `.spy()...called_at_most(times)`  | Luassert        |

## Modifiers

BustEZ also adds some modifiers to make constructs with `expect` more English-y.

| Key      | Source   |
|----------|----------|
| `.to`    | TestEZ   |
| `.be`    | TestEZ   |
| `.been`  | TestEZ   |
| `.have`  | TestEZ   |
| `.was`   | TestEZ   |
| `.at`    | TestEZ   |
| `.never` | TestEZ   |
| `.is`    | Luassert |
| `.are`   | Luassert |
| `.has`   | Luassert |
| `.does`  | Luassert |
| `._not`  | Luassert |
| `.no`    | Luassert |

## Extensions

`expect` accepts any assertions and modifiers created using `luassert`.

```lua
---@class luassert.internal
---@field exist fun(value): luassert.internal

---@class bustez.Expectation
---@field exist fun(): bustez.Expectation

say:set("assertion.exist.positive", "expected to exist, got:\n%s")
say:set("assertion.exist.negative", "expected to exist, got:\n%s")

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

This can be done for extended assertions using `expect.map_args()`. The first argument

```lua
-- swap args 1 and 2, continue as normal for args 3 and beyond
expect.map_args("match", { 2, 1, 3 })
expect.map_args("matches", { 2, 1, 3 })
```