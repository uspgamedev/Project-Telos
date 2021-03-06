require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--BULLET CLASS--
--[[Bullet projectile]]

local bullet = {}
--_dx and _dy are normalized
Bullet = Class{
    __includes = {CIRC},
    init = function(self, _x  , _y, _dx, _dy, _c, _color_table, _game_win_idx)
        local r, color

        r = 5 --Radius of bullet
        color = _c or Color.blue()--Color of bullet

        CIRC.init(self, _x, _y, r, color, _color_table, "fill") --Set atributes

        self.color_duration = 8 --Duration between color transitions

        self.speedv = 600 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        self.game_win_idx = _game_win_idx or 1 --Which game window this bullet is from

        self.tp = "bullet" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Bullet:kill(dont_explode)
    local important

    important = (self.subtp == "player_bullet") and true or false

    if self.death then return end
    self.death = true
    if not dont_explode then
      FX.explosion(self.pos.x, self.pos.y, self.r, self.color, 8, nil, nil, 2, important, self.game_win_idx)
    end

end

function Bullet:update(dt)
    local b

    b = self

    b.pos = b.pos + dt*b.speed

    local win = WINM.getWin(self.game_win_idx)
    if not b.death and
       (b.pos.x - b.r > win.x + win.w or
       b.pos.x + b.r < win.x or
       b.pos.y - b.r > win.y + win.h or
       b.pos.y + b.r < win.y) then
           b:kill(true)
    end
end

--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function bullet.create(x, y, dir, c, color_table, st, game_win_idx)
    local bullet

    st = st or "player_bullet"

    bullet = Bullet(x, y, dir.x, dir.y, c, color_table, game_win_idx)
    bullet:addElement(DRAW_TABLE.L3, st)
    bullet:startColorLoop()

    return bullet
end

--Return functions
return bullet
