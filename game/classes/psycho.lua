require "classes.primitive"
local Hsl = require "classes.hsl"
local Color = require "classes.color"
local Util = require "util"
--PSYCHO CLASS--
--[[Our hero... or is it VILLAIN??!!]]

local psycho = {}

Psy = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        self.tp = "psycho" --Type of this class
        ELEMENT.setSubTp(self, "player")
        ELEMENT.setId(self, "PSY")

        self.r = 20 --Radius of psycho
        self.color = Hsl.orange() --Color of psycho
        self.speedv = 100 --Speed value
        self.speed = Vector(0,0) --Speed vector

        CIRC.init(self, _x, _y, self.r, self.color, "fill") --Set atributes
    end
}

--LOCAL FUNCTIONS--

function psycho.updateSpeed(self)

    p = self --Psycho
    sp = p.speedv --Speed Value

    p.speed = Vector(0,0)
    --Movement
    if love.keyboard.isDown 'w' or love.keyboard.isDown 'up' then --move up
      p.speed = p.speed + Vector(0,-1)
    end
    if love.keyboard.isDown 'a' or love.keyboard.isDown 'left' then --move left
      p.speed = p.speed + Vector(-1,0)
    end
    if love.keyboard.isDown 's' or love.keyboard.isDown 'down' then --move down
      p.speed = p.speed + Vector(0,1)
    end
    if love.keyboard.isDown'd' or love.keyboard.isDown 'right' then --move right
      p.speed = p.speed + Vector(1,0)
    end

    p.speed = p.speed:normalized() * sp

end

--CLASS FUNCTIONS--

function Psy:shoot(x,y)
    local p, bullet, dir, c
    p = self
    c = Hsl.pink()
    dir = Vector(x-p.pos.x, y-p.pos.y)
    dir = dir:normalized()
    bullet = Bullet(p.pos.x, p.pos.y, dir.x, dir.y, c)
    bullet:addElement(DRAW_TABLE.L2, "player_bullet")

end

function Psy:draw()
    local p

    p = self

    --Draws the circle
    Color.set(p.color)
    love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
end

function Psy:update(dt)
    local p

    p = self

    p.pos = p.pos + dt*p.speed

end

function Psy:keypressed(key)
    local p, sp

    p = self --Psycho
    sp = p.speedv --Speed Value

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
        psycho.updateSpeed(self)
    end

end

function Psy:keyreleased(key)

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
      psycho.updateSpeed(self)
  end

end

function psycho.get()
  return Util.findId("PSY")
end

--return function
return psycho