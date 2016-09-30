require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--SIMPLE BALL CLASS--
--[[Simple circle blue enemy that just moves around]]

local enemy = {}

Simple_Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dir, _speed_m, _radius, _score_mul)
        local dx, dy, r, color, color_table

        r = _radius or 20 --Radius of enemy
        color_table = {
            HSL(Hsl.stdv(201,100,50)),
            HSL(Hsl.stdv(239,100,26)),
            HSL(Hsl.stdv(220,78,30)),
            HSL(Hsl.stdv(213,100,54))
        }
        color = color_table[love.math.random(#color_table)] --Color of enemy
        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes
        ELEMENT.setSubTp(self, "enemies")

        self.color_duration = 6 --Duration between color transitions

        --Normalize direction and set speed
        self.speedv = 270 --Speed value
        self.speed_m = _speed_m or 1 --Speed multiplier
        self.speed = Vector(_dir.x, _dir.y) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.score_value = 25 --Score this enemy gives when killed without multiplier
        self.score_mul = _score_mul or 1 --Score multiplier

        self.enter = false --If this enemy has already entered the game screen
        self.tp = "simple_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Simple_Ball:kill(gives_score)

    if self.death then return end

    self.death = true

    if gives_score == nil then gives_score = true end --If this enemy should give score

    FX.explosion(self.pos.x, self.pos.y, self.r, self.color)

    if gives_score then
        LM.giveScore(math.ceil(self.score_value*self.score_mul))
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
        if not isInside(o) then o:kill(false) end --Don't give score if enemy is killed by leaving screen
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir, speed_m, radius, score_mul)
    local e, direction

    if not dir then --Get random direction
        direction = Vector()
        direction.x = love.math.random()*2 - 1 --Rand value between [-1,1]
        direction.y = love.math.random()*2 - 1 --Rand value between [-1,1]
    end

    e = Simple_Ball(x, y, dir or direction, speed_m, radius, score_mul)
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
