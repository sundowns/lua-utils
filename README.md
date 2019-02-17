# Lua / LÖVE2D Util

A collection of useful helper functions for Lua game development, particularly targeted at [LÖVE2D](https://love2d.org/). This library is in its infancy and will continue to grow and evolve as I write or stumble up on other useful functions to speed up development.

The library is split into a series of submodules isolated to their domain:

* **love (l)** - Functions specific to [LÖVE2D](https://love2d.org/).
* **maths (m)** - Collection of useful functions for manipulating numbers and geometry. Yes its 'maths' and not 'math'.
* **table (t)** - Functions used to perform assorted common and useful operations on tables.
* **file (f)** - File handling functions.
* **string (s)** - String manipulation/generation functions.
* **debug (d)** - Some useful functions for debugging programs at run-time (blame Lua). Typically depend on a global 'debug' toggle variable.

Each module can either be accessed by full name or by the first letter of its name.
For example, `util.t.print(table)` is the same as `util.table.print(table)`

------------------------------

## Examples

```lua
util = require("util")

local rounded = util.m.roundToNthDecimal(0.1234, 2)
print(rounded) -- 0.12
```

```lua
util = require("util")

local table1 = { a: true, b: true }
local table2 = { c: true }
local newTable = util.t.concat(table1, table2)

util.t.print(newTable) -- { a: true, b: true, c: true }
```

------------------------------

## **Love** - `util.love` or `util.l`

### resetColour()

Short-hand for `love.graphics.setColor(1,1,1,1)`

### renderStats(x, y)

Displays graphical stats from `love.graphics.getStats()` at the specified coordinates (defaults to 0,0).

------------------------------

## **Maths** - `util.maths` or `util.m`

### roundToNthDecimal(num, n)

Takes a number `num` and returns it rounded to `n` decimal places.

### withinVariance(val1, val2, variance)

Checks whether two values, `val1` and `val2` are within a certain range, specified by `variance`. Useful for checking whether information is within a certain acceptable threshold.

### clamp(val, min, max)

Clamps a value `val` between a range defined by `min` and `max`. If the value is below the minimum, it returns the minimum. If the value is greater than the maximum, the maximum is returned. If the value is within the range, it is returned unaltered.

### midpoint(x1, y1, x2, y2)

Calculates the midpoint between two given points. `m = ((x2+x1)/2) , ((y2+y1)/2)`. Returns mX, mY

### jitterBy(value, spread)

Returns a value updated by a random amount within -spread and spread

### HSVtoRGB255(hue, sat, value)

Takes a value in the [HSV Colour Space](https://en.wikipedia.org/wiki/HSL_and_HSV) and returns the corresponding RGB values. All input (`hue`, `sat`, `val`) and output (`r`,`g`,`b`) are values in the range 0-255.

### HSVtoRGB(hue, sat, value)

Takes a value in the [HSV Colour Space](https://en.wikipedia.org/wiki/HSL_and_HSV) and returns the corresponding RGB values. Input values (`hue`, `sat`, `val`) are all values from 0-255. Output values (`r`,`g`,`b`) are returned in the range 0-1.

### distanceBetween(x1, y1, x2, y2)

Calculates and returns the distance between two points.

------------------------------

## **Table** - `util.table` or `util.t`

### print(table, name)

Recursively prints a table `table` to the console. The output can optionally be named with `name`.
Probably the most useful function in the whole library.

### printKeys(table, name)

Print the keys for a table. The output can optionally be named with `name`.

### concat(t1, t2)

Concatenates two tables, adding all the key-value pairs from `t2` to `t1`.

### copy(orig)

Recursively copies an existing table. Code is taken from this [excellent tutorial](https://www.youtube.com/watch?v=dZ_X0r-49cw#t=9m30s).

### sum(t1, t2)

Takes two tables and combines their key/value pairs. Any number values with the same key will be added together.

------------------------------

## **File** - `util.file` or `util.f`

### exists(path)

Checks to see if a file exists at the path specified by `path`. Intended for use in non-LOVE games. LOVE users should use the intended `love.filesystem.getInfo()` instead.

### getLuaFileName(fileName)

Returns the name of a .lua file without the `.lua` extension. Can be useful for listing directories of .lua files without extensions.

------------------------------

## **String** - `util.string` or `util.s`

### randomLetter()

Returns a random lowercase letter (a-z).

### randomString(l)

Returns a string of length `l` consisting of random lowercase letters.

------------------------------

## **Debug** - `util.debug` or `util.d`

### log(text)

Checks to see if a global `debug` variable is set to true and if so, prints `text`. Can be useful for debug clutter.
