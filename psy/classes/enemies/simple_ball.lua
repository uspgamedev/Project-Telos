require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--SIMPLE BALL CLASS--
--[[Simple circle blue enemy that just moves around]]

local enemy = {}

Simple_Ball = Class{
    __includes = {ENEMY},
    init = function(self, _x, _y, _dir, _speed_m, _radius, _score_mul)
        local color_table

        color_table = {
            HSL(Hsl.stdv(201,100,50)),
            HSL(Hsl.stdv(239,100,26)),
            HSL(Hsl.stdv(220,78,30)),
            HSL(Hsl.stdv(213,100,54))
        }

        ENEMY.init(self,  _x, _y, _dir, _speed_m, _radius, _score_mul, color_table, 270, 25)

        self.tp = "simple_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Simple_Ball:kill(gives_score, dont_explode)

    if self.death then return end

    self.death = true

    if gives_score == nil then gives_score = true end --If this enemy should give score

    if not dont_explode then
      FX.explosion(self.pos.x, self.pos.y, self.r, self.color)
    end

    if gives_score then

        if self.score_value*self.score_mul > 0 then
            LM.giveScore(math.ceil(self.score_value*self.score_mul))
        end

        FX.shake(.1,.09)

        Audio.enemyHit()
    end

end

--Update this enemy
function Simple_Ball:update(dt)
    local o

    o = self

    --Update movement
    o.pos = o.pos + dt*o.speed*o.speed_m

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o:kill(false, true) end --Don't give score if enemy is killed by leaving screen
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir, speed_m, radius, score_mul)
    local e

    e = Simple_Ball(x, y, dir, speed_m, radius, score_mul)
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
    return HSL(Hsl.stdv(227,88.8,49.2))
end

--Return the default score this enemy gives when killed
function enemy.score()
    return 25
end

--LOCAL FUNCTION--

--Checks if a circular enemy has entered (even if partially) inside the game screen
function isInside(o)

    if    o.pos.x + o.r >= 0
      and o.pos.x - o.r <= WINDOW_WIDTH
      and o.pos.y + o.r >= 0
      and o.pos.y - o.r <= WINDOW_HEIGHT
      then
          return true
      end

    return false
end

--return function
return enemy
