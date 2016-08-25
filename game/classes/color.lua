local Rgb = require "classes.rgb"
local Hsl = require "classes.hsl"
--COLOR CLASS--

--Wrapper to properly handle HSV or RGB colors

local COLOR = {}

--Return color values
function COLOR.clr(c)
  if c.type == "RGB" then
    Rgb.rgb(c)
  elseif c.type == "HSL" then
    Hsl.hsl(c)
  end
end

--Return color values + alpha
function COLOR.clra(c)
  if c.type == "RGB" then
    Rgb.rgba(c)
  elseif c.type == "HSL" then
    Hsl.hsla(c)
  end
end

--Return color values + alpha
function COLOR.a(c)
  if c.type == "RGB" then
    Rgb.a(c)
  elseif c.type == "HSL" then
    Hsl.a(c)
  end
end

--Copy colors from a color c2 to a color c1 (both have to be the same type)
function COLOR.copy(c1, c2)
  if c1.type == "RGB" then
    Rgb.copy(c1, c2)
  elseif c1.type == "HSL" then
    Hsl.copy(c1, c2)
  end
end

--Set color c as love drawing color
function COLOR.set(c)
  if c.type == "RGB" then
    Rgb.set(c)
  elseif c.type == "HSL" then
    Hsl.set(c)
  end
end

--Set the color used for drawing using 255 as alpha amount
function COLOR.setOpaque(c)
  if c.type == "RGB" then
    Rgb.setOpaque(c)
  elseif c.type == "HSL" then
    Hsl.setOpaque(c)
  end
end

--Set the color used for drawing using 0 as alpha amount
function COLOR.setOpaque(c)
  if c.type == "RGB" then
    Rgb.setTransp(c)
  elseif c.type == "HSL" then
    Hsl.setTransp(c)
  end
end

--Return functions
return COLOR
