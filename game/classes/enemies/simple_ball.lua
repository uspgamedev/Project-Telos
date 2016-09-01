require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
--SIMPLE BALL CLASS--
--[[Simple circle blue enemy that just moves around]]

local enemy = {}

Simple_Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dir)
        local dx, dy, r, color, color_table

        r = 20 --Radius of enemy
        color = HSL(Hsl.stdv(213,100,54)) --Color of psycho
        color_table = {
            HSL(Hsl.stdv(201,100,50)),
            HSL(Hsl.stdv(239,100,26)),
            HSL(Hsl.stdv(220,78,30)),
            HSL(Hsl.stdv(213,100,54))
        }
        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes

        ELEMENT.setSubTp(self, "enemies")

        --Normalize direction and set speed
        self.speedv = 100 --Speed value
        self.speed = Vector(_dir.x, _dir.y) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.enter = false --If this enemy has already entered the game screen
        self.tp = "simple_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

--Draw this enemy
function Simple_Ball:draw()
    local p

    p = self

    --Draws the circle
    Color.set(p.color)
    love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
end

--Update this enemy
function Simple_Ball:update(dt)
    local o

    o = self

    --Update movement
    o.pos = o.pos + dt*o.speed

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o.death = true end
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir)
    local e, d, direction

    d = 6 -- Duration of color transition
    if not dir then --Get random direction
        direction = Vector()
        direction.x = love.math.random()*2 - 1 --Rand value between [-1,1]
        direction.y = love.math.random()*2 - 1 --Rand value between [-1,1]
    end

    e = Simple_Ball(x, y, dir or direction)
    e:addElement(DRAW_TABLE.L4)
    e:startColorLoop(d)

    return e
end

--Return this enemy radius
function enemy.radius()
    return 20
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
