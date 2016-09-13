require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--BULLET CLASS--
--[[Bullet projectile]]

local bullet = {}
--_dx and _dy are normalized
Bullet = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy, _c, _color_table)
        local r, color

        r = 5 --Radius of bullet
        color = _c or Color.blue()--Color of bullet

        CIRC.init(self, _x, _y, r, color, _color_table, "fill") --Set atributes

        self.color_duration = 8 --Duration between color transitions

        self.speedv = 500 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        self.tp = "bullet" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Bullet:kill()

    if self.death then return end
    self.death = true
    FX.explosion(self.pos.x, self.pos.y, self.r, self.color, 10, nil, nil, 3)

end

function Bullet:update(dt)
    local b

    b = self

    b.pos = b.pos + dt*b.speed

    if not b.death and
       (b.pos.x - b.r > ORIGINAL_WINDOW_WIDTH or
       b.pos.x + b.r < 0 or
       b.pos.y - b.r > ORIGINAL_WINDOW_HEIGHT or
       b.pos.y + b.r < 0) then
           b:kill()
    end
end

--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function bullet.create(x, y, dir, c, color_table, st)
    local bullet

    st = st or "player_bullet"

    bullet = Bullet(x, y, dir.x, dir.y, c, color_table)
    bullet:addElement(DRAW_TABLE.L3, st)
    bullet:startColorLoop()

    return bullet
end

--Return functions
return bullet
