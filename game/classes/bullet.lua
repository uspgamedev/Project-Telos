require "classes.primitive"
local Hsl = require "classes.hsl"
local Color = require "classes.color"
local Util = require "util"
--BULLET CLASS--
--[[Bullet projectile]]

local bullet = {}
--_dx and _dy are normalized
Bullet = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy,_c)

        self.r = 5 --Radius of bullet
        self.color = _c or Hsl.blue()--Color of bullet

        self.speedv = 450 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        CIRC.init(self, _x, _y, self.r, self.color, "fill") --Set atributes

        self.tp = "bullet" --Type of this class
    end
}

function Bullet:draw()
    local b

    b = self

    --Draws the circle
    Color.set(b.color)
    love.graphics.circle("fill", b.pos.x, b.pos.y, b.r)
end

function Bullet:update(dt)
    local b

    b = self

    b.pos = b.pos + dt*b.speed

    if not b.death and
       (b.pos.x > WINDOW_WIDTH or
       b.pos.x < 0 or
       b.pos.y > WINDOW_HEIGHT or
       b.pos.y < 0) then
           b.death = true
    end
end

--Return functions
return bullet
