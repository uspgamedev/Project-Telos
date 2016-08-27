require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--SIMPLE BALL CLASS--
--[[Simple circle blue enemy that just moves around]]

local enemy = {}

Simple_Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        local dx, dy
        CIRC.init(self, _x, _y, self.r, self.color, "fill") --Set atributes

        ELEMENT.setSubTp(self, "enemies")
        self.tp = "simple_ball" --Type of this class

        self.r = 20 --Radius of enemy
        self.color = Color.blue() --Color of psycho

        self.speedv = 100 --Speed value
        dx = love.math.random()*2 - 1 --Rand value between [-1,1]
        dy = love.math.random()*2 - 1 --Rand value between [-1,1]
        self.speed = Vector(dx, dy) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.enter = false --If this enemy has already entered the game screen
    end
}

--CLASS FUNCTIONS--

function Simple_Ball:draw()
    local p

    p = self

    --Draws the circle
    Color.set(p.color)
    love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
end

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

function enemy.create(x, y)
    local e

    e = Simple_Ball(x, y)
    e:addElement(DRAW_TABLE.L4)

    return e
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
