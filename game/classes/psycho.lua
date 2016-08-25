require "classes.primitive"
local Hsl = require "classes.hsl"
local Color = require "classes.color"
local Util = require "util"
--PSYCHO CLASS--
--[[Our hero... or is it VILLAIN??!!]]

local psycho = {}

--MATH STUFF--
local sqrt2 = math.sqrt(2)

Psy = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        self.tp = "psycho" --Type of this class
        ELEMENT.setSubTp(self, "player")
        ELEMENT.setId(self, "PSY")

        self.r = 20 --Radius of psycho
        self.color = Hsl.orange() --Color of psycho
        self.speedv = 100
        self.speed = Vector(0,0)

        CIRC.init(self, _x, _y, self.r, self.color, "fill") --Set atributes
    end
}

--LOCAL FUNCTIONS--

local function updateSpeed(self)

    p = self --Psycho
    sp = p.speedv --Speed Value

    p.speed = Vector(0,0)
    --Movement
    if love.keyboard.isDown 'w' then --move up
      p.speed = p.speed + Vector(0,-1)
    end
    if love.keyboard.isDown 'a' then --move left
      p.speed = p.speed + Vector(-1,0)
    end
    if love.keyboard.isDown 's' then --move down
      p.speed = p.speed + Vector(0,1)
    end
    if love.keyboard.isDown'd' then --move right
      p.speed = p.speed + Vector(1,0)
    end

    p.speed = p.speed:normalized() * sp

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
  if key == 'w' or key == 'a' or key == 's' or key == 'd' then
      updateSpeed(self)
  end

end

function Psy:keyreleased(key)

  --Movement
  if key == 'w' or key == 'a' or key == 's' or key == 'd' then
      updateSpeed(self)
  end

end

function psycho.get()
  return Util.findId("PSY")
end

--return function
return psycho
