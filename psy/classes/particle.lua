require "classes.primitive"
local Color = require "classes.color.color"
--PARTICLE CLASS--
--[[Particle generally for effects]]

local particle = {}

------------------
--PARTICLE BATCH--
------------------

--Particle batch that holds a group of particles, and deletes them after a while
Particle_Batch = Class{
    __includes = {ELEMENT},
    init = function(self, _endtime)
        ELEMENT.init(self)

        self.batch = {}
        self.endtime = _endtime
        self.time = 0
        self.tp = "particle_batch"
    end
}

--CLASS FUNCTIONS--

function Particle_Batch:update(dt)

    if self.death then return end

    self.time = self.time + dt
    if (self.time >= self.endtime) then
        self.death = true
    end

end

function Particle_Batch:destroy()

    if self.batch then
        for _, part in pairs(self.batch) do
            part.death = true
        end
    end
    ELEMENT.destroy(self)

end


function Particle_Batch:put(particle)
    table.insert(self.batch, particle)
end

--UTILITY FUNCTIONS--

function particle.create_batch(endtime)
    local batch

    batch = Particle_Batch(endtime)
    batch:setSubTp("particle_batch")

    return batch
end

------------------
--REGULAR PARTICLE
------------------

--Particle that has an alpha decaying over-time
Regular_Particle = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy, _c, _speed, _radius, _game_win_idx)
        CIRC.init(self, _x, _y, _radius, _c, nil, "fill") --Set atributes

        self.speedv = _speed --Speed value
        self.speed = Vector(_dx, _dy) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.game_win_idx = _game_win_idx or 1

        self.tp = "regular_particle" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Regular_Particle:draw()
    local p

    p = self

    --Draws the particle, bounded by its game window
    local win = WINM.getWin(self.game_win_idx)
    if p.pos.x - p.r > win.x and p.pos.x + p.r < win.x + win.w and
       p.pos.y - p.r > win.y and p.pos.y + p.r < win.y + win.h then
        Color.set(p.color)
        love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
    end
end

function Regular_Particle:update(dt)
    local p

    p = self
    --Update position
    p.pos = p.pos + dt*p.speed

end

--UTILITY FUNCTIONS--

--Create a particle in the (x,y) position, direction dir, color c, radius r and subtype st
function particle.create_regular(pos, dir, color, speed, r, game_win_idx, st)
    local part

    st = st or "regular_particle" --subtype

    part = Regular_Particle(pos.x, pos.y, dir.x, dir.y, color, speed, r, game_win_idx)

    part:addElement(DRAW_TABLE.L2, st)

    return part
end

-------------------
--DECAYING PARTICLE
-------------------

--Particle that has an alpha decaying over-time
Decaying_Particle = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy, _c, _speed, _decaying_speed, _size)
        CIRC.init(self, _x, _y, _size, _c, nil, "fill") --Set atributes

        self.speedv = _speed --Speed value
        self.speed = Vector(_dx, _dy) --Speed vector
        self.speed = self.speed:normalized()*self.speedv
        self.decaying_speed = _decaying_speed --Decaying alpha speed (object is deleted when alpha reaches it reaches 0)

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
    if p.death then return end

    --Update position
    p.pos = p.pos + dt*p.speed
    --Decays the alpha value
    if SLOWMO then
        p.color.a = p.color.a - p.decaying_speed*SLOWMO_M*dt
    else
        p.color.a = p.color.a - p.decaying_speed*dt
    end

    if p.color.a < 0 then
        p.color.a = 0
    end

    if not p.death and p.color.a <=0 then
           p.death = true
    end
end

--UTILITY FUNCTIONS--

--Create a particle in the (x,y) position, direction dir, color c, radius size and subtype st
function particle.create_decaying(pos, dir, color, speed, decaying, size, draw_table, st)
    local part

    st = st or "decaying_particle" --subtype

    part = Decaying_Particle(pos.x, pos.y, dir.x, dir.y, color, speed, decaying, size)

    part:addElement(draw_table or DRAW_TABLE.L2, st)

    return part
end

--Return functions
return particle
