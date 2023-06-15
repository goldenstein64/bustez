# BustEZ

[TestEZ's](https://github.com/Roblox/testez) `expect()` pattern embedded into the [luassert](https://github.com/lunarmodules/luassert) library.

This is done by registering expectations and modifiers not found in `luassert` and adding an `expect` implementation, which is just a wrapper for `luassert's` `assert()`.

Type definitions for [LuaLS/lua-language-server](https://github.com/LuaLS/lua-language-server) are available at [goldenstein64/bustez-definitions](https://github.com/goldenstein64/bustez-definitions)

## Usage

Write a Lua script that sets `expect` to the `bustez` module.

```lua
-- helper.lua
expect = require("bustez")()
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