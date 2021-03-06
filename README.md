# Lua / LÖVE2D Util

A collection of useful helper functions for Lua game development, particularly targeted at [LÖVE2D](https://love2d.org/). This library is in its infancy and will continue to grow and evolve as I write or stumble upon other useful functions to speed up development.

The library is split into a series of submodules isolated to their domain:

- **love (l)** - Functions specific to [LÖVE2D](https://love2d.org/).
- **generic (g)** - Useful generic functions
- **maths (m)** - Collection of useful functions for manipulating numbers and geometry. 'math' also works if you're an animal.
- **table (t)** - Functions used to perform assorted common and useful operations on tables.
- **file (f)** - File handling functions.
- **string (s)** - String manipulation/generation functions.
- **debug (d)** - Some useful functions for debugging programs at run-time (blame Lua). Typically depend on a global 'debug' toggle variable.

Each module can either be accessed by full name or by the first letter of its name.
For example, `util.t.print(table)` is the same as `util.table.print(table)`

---

## Examples

```lua
util = require("util")

local rounded = util.m.round_to_nth(0.1234, 2)
print(rounded) -- 0.12
```

```lua
util = require("util")

local table1 = { a: true, b: true }
local table2 = { c: true }
local newTable = util.t.concat(table1, table2)

util.t.print(newTable) -- { a: true, b: true, c: true }
```

```lua
local choice = choose("cat", "dog", "bird")
print(choice) -- who knows?????
```

---

## **Love** - `util.love` or `util.l`

### reset_colour() or reset_color() 🙊

Short-hand for `love.graphics.setColor(1,1,1,1)`

### render_stats(x, y)

Displays graphical stats from `love.graphics.getStats()` at the specified coordinates (defaults to 0,0). Must be called in `love.draw()`.

---

## **Generic** - `util.generic` or `util.g`

### choose(...args)

Randomly return one of the given arguments. This function can take variable length arguments. Remember to seed the random by second with `math.randomseed(os.time())`.

### choose_weighted(...args)

Randomly return one of the given arguments with a weighted random (defaults to 1). This function can take variable length arguments. Remember to seed the random by second with `math.randomseed(os.time())`. If non-table options are provided, they are treated as a weighting of 1. To specify table arguments, they must be wrapped in an additional table, optionally with a weighting.

```lua

local choice = _util.g.choose_weighted({"foo", 2}, "bar", {"foobar"}) -- all valid

local some_table_choice = {}
local choice = _util.g.choose_weighted({"foo", 2}, {some_table_choice}) -- valid
local choice = _util.g.choose_weighted({"foo", 2}, some_table_choice) -- not valid
```

---

## **Maths** - `util.maths` or `util.math` 🤢 or `util.m`

### round_to_nth(num, n)

Takes a number `num` and returns it rounded to `n` decimal places.

### within_variance(val1, val2, variance)

Checks whether two values, `val1` and `val2` are within a certain range, specified by `variance`. Useful for checking whether information is within a certain acceptable threshold.

### clamp(val, min, max)

Clamps a value `val` between a range defined by `min` and `max`. If the value is below the minimum, it returns the minimum. If the value is greater than the maximum, the maximum is returned. If the value is within the range, it is returned unaltered.

### midpoint(x1, y1, x2, y2)

Calculates the midpoint between two given points. `m = ((x2+x1)/2) , ((y2+y1)/2)`. Returns mX, mY

### jitter_by(value, spread)

Returns a value updated by a random amount within -spread and spread

### hsv_to_rgb_255(hue, sat, value)

Takes a value in the [HSV Colour Space](https://en.wikipedia.org/wiki/HSL_and_HSV) and returns the corresponding RGB values. All input (`hue`, `sat`, `val`) and output (`r`,`g`,`b`) are values in the range 0-255.

### hsv_to_rgb(hue, sat, value)

Takes a value in the [HSV Colour Space](https://en.wikipedia.org/wiki/HSL_and_HSV) and returns the corresponding RGB values. Input values (`hue`, `sat`, `val`) are all values from 0-255. Output values (`r`,`g`,`b`) are returned in the range 0-1.

### distance_between(x1, y1, x2, y2)

Calculates and returns the distance between two points.

### rotate_point_around_origin(x, y, rotation)

Calculates and returns a point rotated around 0,0. Rotation is in radians.

---

## **Table** - `util.table` or `util.t`

### print(table, depth, name)

Recursively prints a table `table` to the console. A maximum `depth` can be specified, by default it is 10. The output can optionally be named with `name`.

### print_keys(table, name)

Print the keys for a table. The output can optionally be named with `name`.

### concat(t1, t2)

Concatenates two tables, adding all the key-value pairs from `t2` to `t1`.

### copy(orig)

Recursively copies an existing table. Code is taken from this [excellent tutorial](https://www.youtube.com/watch?v=dZ_X0r-49cw#t=9m30s).

### sum(t1, t2)

Takes two tables and combines their key/value pairs. Any number values with the same key will be added together.

---

## **File** - `util.file` or `util.f`

### exists(path)

Checks to see if a file exists at the path specified by `path`. Intended for use in non-LOVE games. LOVE users should use the intended `love.filesystem.getInfo()` instead.

### get_lua_filename(filename)

Returns the name of a .lua file without the `.lua` extension. Can be useful for listing directories of .lua files without extensions.

---

## **String** - `util.string` or `util.s`

### random_letter()

Returns a random lowercase letter (a-z).

### random_string(l)

Returns a string of length `l` consisting of random lowercase letters.

---

## **Debug** - `util.debug` or `util.d`

### log(text)

Checks to see if a global `_debug` variable is set to true and if so, prints `text`. Can be useful for debug clutter.
