require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--BULLET CLASS--
--[[Bullet projectile]]

local bullet = {}
--_dx and _dy are normalized
Bullet = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy,_c)

        self.r = 5 --Radius of bullet
        self.color = _c or Color.blue()--Color of bullet

        self.speedv = 450 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        CIRC.init(self, _x, _y, self.r, self.color, "fill") --Set atributes

        self.tp = "bullet" --Type of this class
    end
}

--CLASS FUNCTIONS--

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

--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function bullet.create(x, y, dir, c, st)
    local bullet, subtype

    subtype = st or "player_bullet"

    bullet = Bullet(x, y, dir.x, dir.y, c)
    bullet:addElement(DRAW_TABLE.L3, subtype)

    return bullet
end

--Return functions
return bullet
