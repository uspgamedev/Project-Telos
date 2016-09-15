require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local SB = require "classes.enemies.simple_ball"

--DOUBLE BALL CLASS--
--[[Simple red circle enemy that spawns simple balls when it dies]]

local enemy = {}

Double_Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dir, _speed_m)
        local dx, dy, r, color, color_table

        r = 20 --Radius of enemy
        color = HSL(Hsl.stdv(0,100,44.9)) --Color of enemy
        color_table = {
            HSL(Hsl.stdv(0,100,44.9)), --Ku Crimson
            HSL(Hsl.stdv(14,100,46)), --Coquelicot
            HSL(Hsl.stdv(1,84,55)), --Deep Carmine Red
            HSL(Hsl.stdv(12,100,38.8)) --Candy Apple Red
        }
        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes
        ELEMENT.setSubTp(self, "enemies")

        self.color_duration = 6 --Duration between color transitions

        --Normalize direction and set speed
        self.speedv = 200 --Speed value
        self.speed_m = _speed_m or 1 --Speed multiplier
        self.speed = Vector(_dir.x, _dir.y) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.enter = false --If this enemy has already entered the game screen
        self.tp = "double_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Double_Ball:kill()
    local e

    if self.death then return end
    self.death = true
    FX.explosion(self.pos.x, self.pos.y, self.r, self.color)

    --Create two Simple Balls in a V shape
    e = SB.create(self.pos.x, self.pos.y, self.speed:rotated(math.pi/6))
    e.enter = true
    e = SB.create(self.pos.x, self.pos.y, self.speed:rotated(-math.pi/6))
    e.enter = true
    
end

--Update this enemy
function Double_Ball:update(dt)
    local o

    o = self

    --Update movement
    o.pos = o.pos + dt*o.speed*o.speed_m

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o:kill() end
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir, speed_m)
    local e, direction

    if not dir then --Get random direction
        direction = Vector()
        direction.x = love.math.random()*2 - 1 --Rand value between [-1,1]
        direction.y = love.math.random()*2 - 1 --Rand value between [-1,1]
    end

    e = Double_Ball(x, y, dir or direction, speed_m)
    e:addElement(DRAW_TABLE.L4)
    e:startColorLoop()

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