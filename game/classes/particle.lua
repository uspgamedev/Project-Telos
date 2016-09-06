require "classes.primitive"
local Color = require "classes.color.color"
--PARTICLE CLASS--
--[[Particle generally for effects]]

local particle = {}

--Particle that has an alpha decaying over-time
Decaying_Particle = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy, _c, _speed, _decaying_speed, _size)
        CIRC.init(self, _x, _y, _size, _c, nil, "fill") --Set atributes

        self.speedv = _speed --Speed value
        self.speed = Vector(_dx, _dy) --Speed vector
        self.speed = self.speed:normalized()*self.speedv
        self.decaying_speed = _decaying_speed --Decaying alpha speed (object is deleted when it reaches 0)

        self.tp = "decaying_particle" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Decaying_Particle:draw()
    local p

    p = self

    --Draws the particle
    Color.set(p.color)
    love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
end

function Decaying_Particle:update(dt)
    local p

    p = self
    --Update position
    p.pos = p.pos + dt*p.speed
    --Decays the alpha value
    p.color.a = p.color.a*p.decaying_speed

    if not p.death and p.color.a <=5 then
           p.death = true
    end
end

--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function particle.create_decaying(pos, dir, color, speed, decaying, size)
    local part, st

    st = "decaying_particle" --subtype

    part = Decaying_Particle(pos.x, pos.y, dir.x, dir.y, color, speed, decaying, size)

    part:addElement(DRAW_TABLE.L2, st)

    return part
end

--Return functions
return particle
