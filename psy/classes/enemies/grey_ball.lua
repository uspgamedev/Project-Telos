require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--GREY BALL CLASS--
--[[circle grey enemy that just moves around]]

local enemy = {}

Grey_Ball = Class{
    __includes = {ENEMY},
    init = function(self, _x, _y, _dir, _speed_m, _radius)
        local color_table

        color_table = {
            HSL(Hsl.stdv(0,0,40)),
            HSL(Hsl.stdv(0,0,45)),
            HSL(Hsl.stdv(0,0,50)),
            HSL(Hsl.stdv(0,0,55))
        }

        ENEMY.init(self,  _x, _y, _dir, _speed_m, _radius, _score_mul, color_table, 270, 25)

        self.color_duration = 1 --Time to loop colors

        self.tp = "grey_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Grey_Ball:kill()

    if self.death then return end

    self.death = true

    FX.explosion(self.pos.x, self.pos.y, self.r, self.color)

end

--Update this enemy
function Grey_Ball:update(dt)
    local o

    o = self

    --Update movement
    o.pos = o.pos + dt*o.speed*o.speed_m

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o:kill() end --Don't give score if enemy is killed by leaving screen
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir, speed_m, radius)
    local e

    e = Grey_Ball(x, y, dir, speed_m, radius)
    e:addElement(DRAW_TABLE.L4)
    e:startColorLoop()

    return e
end

--Return this enemy radius
function enemy.radius()
    return 20
end

--Return the color for this enemy indicator
function enemy.indColor()
    return HSL(Hsl.stdv(0,0,45))
end

--Return the default score this enemy gives when killed
function enemy.score()
    return 200
end

--LOCAL FUNCTION--

--Checks if a circular enemy has entered (even if partially) inside the game screen
function isInside(o)

    if    o.pos.x + o.r >= 0
      and o.pos.x - o.r <= ORIGINAL_WINDOW_WIDTH
      and o.pos.y + o.r >= 0
      and o.pos.y - o.r <= ORIGINAL_WINDOW_HEIGHT
      then
          return true
      end

    return false
end

--return function
return enemy
