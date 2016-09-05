require "classes.primitive"
local Bullet = require "classes.bullet"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local FreeRes = require "FreeRes"
--PSYCHO CLASS--
--[[Our hero... or is it VILLAIN??!!]]

local psycho = {}

Psy = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        local color, color_table, r

        color = HSL(Hsl.stdv(271,75,52)) --Color of psycho
        color_table = {
            HSL(Hsl.stdv(51,100,50)),
            HSL(Hsl.stdv(355,89,48)),
            HSL(Hsl.stdv(95, 89,42)),
            HSL(Hsl.stdv(207,81,49)),
            HSL(Hsl.stdv(271,75,52))
        } --Color table
        r = 22 --Radius of psycho

        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes

        ELEMENT.setSubTp(self, "player")
        ELEMENT.setId(self, "psycho")

        self.speedv = 250 --Speed value
        self.speed = Vector(0,0) --Speed vector

        self.shoot_tick = 0 --Bullet "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = .2 --How fast to shoot bullet

        self.tp = "psycho" --Type of this class

    end
}

--CLASS FUNCTIONS--

function Psy:shoot(x,y)
    local p, bullet, dir, c, color_table, w, h, scale
    p = self

    --Fix mouse position click to respective distance
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    c = HSL(Hsl.hsl(p.color)) --COlor of bullet is current psycho color
    color_table = {
        HSL(Hsl.stdv(51,100,50)),
        HSL(Hsl.stdv(355,89,48)),
        HSL(Hsl.stdv(95, 89,42)),
        HSL(Hsl.stdv(207,81,49)),
        HSL(Hsl.stdv(271,75,52))
    }

    dir = Vector(x-p.pos.x, y-p.pos.y)
    dir = dir:normalized()
    Bullet.create(p.pos.x, p.pos.y, dir, c, color_table, "player_bullet")

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

    --Update movement
    p.pos = p.pos + dt*p.speed
    --Fixes if psycho leaves screen
    p.pos = p.pos + dt*p.speedv*isOutside(p)

    --Update shooting
    p.shoot_tick = p.shoot_tick - dt
    if love.mouse.isDown(1) then
        if p.shoot_tick <= 0 then
            p.shoot_tick = p.shoot_tick + p.shoot_fps
            p:shoot(love.mouse.getPosition())
        end
    end
    if p.shoot_tick < 0 then
        p.shoot_tick = 0
    end

end

function Psy:kill()
    local p

    p = self

    p.death = true

    SWITCH =  "GAMEOVER"
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

--UTILITY FUNCTIONS--

function psycho.create(x, y)
    local p, duration

    duration = 3 --Duration of color transition effect

    p = Psy(x, y)
    p:addElement(DRAW_TABLE.L4)
    p:startColorLoop(duration)

    return p
end

function psycho.get()
  return Util.findId("psycho")
end

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

--Checks if psycho has leaved (even if partially) the game screen and returns correction vector
function isOutside(o)
    local v, r, scale

    scale = FreeRes.scale()

    v = Vector(0,0)

    --X position
    if     o.pos.x - o.r <= 0 then
        v = v + Vector(1,0)
    elseif o.pos.x + o.r >= ORIGINAL_WINDOW_WIDTH then
        v = v + Vector(-1,0)
    end
    --Y position
    if o.pos.y - o.r <= 0 then
        v = v + Vector(0,1)
    elseif o.pos.y + o.r >= ORIGINAL_WINDOW_HEIGHT then
        v = v + Vector(0,-1)
    end

    return v:normalized()
end

--return function
return psycho
