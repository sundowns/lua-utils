--[[
  - util.lua
  - Handy module containing various functions for game development in lua,
    particularly with Love2D.
  - Authored by Thomas Smallridge (sundowns)
  - https://github.com/sundowns/lua-utils

  MIT LICENSE
  Copyright (c) 2019 Thomas Smallridge
  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:
  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
local meta = {
  __index = function(table, key)
    if key == "l" then
      return rawget(table, "love")
    elseif key == "m" then
      return rawget(table, "maths")
    elseif key == "t" then
      return rawget(table, "table")
    elseif key == "f" then
      return rawget(table, "file")
    elseif key == "d" then
      return rawget(table, "debug")
    elseif key == "s" then
      return rawget(table, "string")
    elseif key == "g" then
      return rawget(table, "generic")
    else
      return rawget(table, key)
    end
  end
}

local util = {}
util.love = {}
util.maths = {}
util.table = {}
util.file = {}
util.debug = {}
util.string = {}
util.generic = {}

setmetatable(util, meta)

---------------------- TABLES

function util.table.print(table, depth, name)
  print("==================")
  if not table then
    print("<EMPTY TABLE>")
    return
  end
  if type(table) ~= "table" then
    assert(false, "Attempted to print NON-TABLE TYPE: " .. type(table))
    return
  end
  if name then
    print("Printing table: " .. name)
  end
  deepprint(table, 0, depth)
end

function deepprint(table, depth, max_depth)
  local d = depth or 0
  local max = max_depth or 10
  local spacer = ""
  for i = 0, d do
    spacer = spacer .. " "
  end
  if d > max then
    print(spacer .. "<exceeded max depth (" .. max .. ")>")
    return
  end
  for k, v in pairs(table) do
    if type(v) == "table" then
      print(spacer .. "[" .. k .. "]:")
      deepprint(v, d + 1, max)
    else
      print(spacer .. "[" .. tostring(k) .. "]: " .. tostring(v))
    end
  end
end

function util.table.printKeys(table, name)
  print("==================")
  if not table then
    print("<EMPTY TABLE>")
    return
  end
  if type(table) ~= "table" then
    assert(false, "Attempted to print keys for NON-TABLE TYPE: " .. type(table))
    return
  end
  for k, v in pairs(table) do
    print(k)
  end
end

function util.table.concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

-- Recursively creates a copy of the given table.
-- Not my code, taken from: https://www.youtube.com/watch?v=dZ_X0r-49cw#t=9m30s
function util.table.copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[util.table.copy(orig_key)] = util.table.copy(orig_value)
    end
  else
    copy = orig
  end
  return copy
end

--sums two tables of numbers together
function util.table.sum(t1, t2)
  local result = {}
  for key, val in pairs(t1) do
    result[key] = (result[key] or 0) + val
  end
  for key, val in pairs(t2) do
    result[key] = (result[key] or 0) + val
  end
  return result
end

---------------------- MATHS

function util.maths.roundToNthDecimal(num, n)
  local mult = 10 ^ (n or 0)
  return math.floor(num * mult + 0.5) / mult
end

function util.maths.withinVariance(val1, val2, variance)
  local diff = math.abs(val1 - val2)
  if diff < variance then
    return true
  else
    return false
  end
end

function util.maths.clamp(val, min, max)
  assert(min < max, "Minimum value must be less than maximum when clamping values.")
  if min - val > 0 then
    return min
  end
  if max - val < 0 then
    return max
  end
  return val
end

function util.maths.midpoint(x1, y1, x2, y2)
  assert(x1 and y1 and x2 and y2, "Received invalid input to util.maths.midpoint")
  return (x2 + x1) / 2, (y2 + y1) / 2
end

function util.maths.jitterBy(value, spread)
  assert(love, "This function uses love.math.random for the time being")
  return value + love.math.random(-1 * spread, spread)
end

--Taken from: https://love2d.org/wiki/HSV_color
function util.maths.HSVtoRGB255(hue, sat, val)
  if sat <= 0 then
    return val, val, val
  end
  local h, s, v = hue / 256 * 6, sat / 255, val / 255
  local c = v * s
  local x = (1 - math.abs((h % 2) - 1)) * c
  local m, r, g, b = (v - c), 0, 0, 0
  if h < 1 then
    r, g, b = c, x, 0
  elseif h < 2 then
    r, g, b = x, c, 0
  elseif h < 3 then
    r, g, b = 0, c, x
  elseif h < 4 then
    r, g, b = 0, x, c
  elseif h < 5 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return (r + m) * 255, (g + m) * 255, (b + m) * 255
end

--Taken from: https://love2d.org/wiki/HSV_color
function util.maths.HSVtoRGB(hue, sat, val)
  if sat <= 0 then
    return val, val, val
  end
  local h, s, v = hue / 256 * 6, sat / 255, val / 255
  local c = v * s
  local x = (1 - math.abs((h % 2) - 1)) * c
  local m, r, g, b = (v - c), 0, 0, 0
  if h < 1 then
    r, g, b = c, x, 0
  elseif h < 2 then
    r, g, b = x, c, 0
  elseif h < 3 then
    r, g, b = 0, c, x
  elseif h < 4 then
    r, g, b = 0, x, c
  elseif h < 5 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return (r + m), (g + m), (b + m)
end

function util.maths.distanceBetween(x1, y1, x2, y2)
  return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end

-- rotation is in radians
function util.maths.rotatePointAroundOrigin(x, y, rotation)
  local s = math.sin(rotation)
  local c = math.cos(rotation)
  return x * c - y * s, x * s + y * c
end

---------------------- DEBUG

function util.debug.log(text)
  if debug then
    print(text)
  end
end

---------------------- FILE

function util.file.exists(name)
  if love then
    assert(false, "Not to be used in love games, use love.filesystem.getInfo")
  end
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function util.file.getLuaFileName(url)
  return string.gsub(url, ".lua", "")
end

---------------------- LOVE2D

function util.love.resetColour()
  love.graphics.setColor(1, 1, 1, 1)
end

function util.love.resetColor()
  love.graphics.setColor(1, 1, 1, 1)
end

function util.love.renderStats(x, y)
  if not x then
    x = 0
  end
  if not y then
    y = 0
  end
  local stats = love.graphics.getStats()
  love.graphics.print("texture memory (MB): " .. stats.texturememory / 1024 / 1024, x, y)
  love.graphics.print("drawcalls: " .. stats.drawcalls, x, y + 20)
  love.graphics.print("canvasswitches: " .. stats.canvasswitches, x, y + 40)
  love.graphics.print("images loaded: " .. stats.images, x, y + 60)
  love.graphics.print("canvases loaded: " .. stats.canvases, x, y + 80)
  love.graphics.print("fonts loaded: " .. stats.fonts, x, y + 100)
end

if not love then
  util.love = nil
end

---------------------- GENERIC

function util.generic.choose(...)
  local args = {...}
  return args[math.random(1, #args)]
end

---------------------- STRING

function util.string.randomString(l)
  if l < 1 then
    return nil
  end
  local stringy = ""
  for i = 1, l do
    stringy = stringy .. util.string.randomLetter()
  end
  return stringy
end

function util.string.randomLetter()
  return string.char(math.random(97, 122))
end

return util
