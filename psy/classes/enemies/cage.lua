require "classes.primitive"
local Util = require "util"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"

--LOCAL FUNCTIONS--
local function sign(n)
	return n < 0 and -1 or n > 0 and 1 or 0
end

--CAGE CLASS--
--[[Cage enemy that imprisons psycho]]

local enemy = {}

Cage = Class{
    __includes = {ELEMENT, CLR, POS},
    init = function(self, _x, _y, _radius, _growth_speed)
        ELEMENT.init(self)

        self.target_pos = nil --Target pos this cage will go to
        self.target_radius = _radius --Target radius this cage will resize to

        self.radius_speed = _growth_speed --Speed to change radius size
        self.pos_speed = 100 --Speed to change position

        POS.init(self,_x, _y)
        self.r = math.sqrt(WINDOW_WIDTH*WINDOW_WIDTH/4 + WINDOW_HEIGHT*WINDOW_HEIGHT/4) + 10

        self.cage_width = 10

        self.leaving = false --If cage is leaving the screen

        self.color = HSL(Hsl.stdv(278,89,39))

        local color_table = {
            HSL(Hsl.stdv(201,100,50)),
            HSL(Hsl.stdv(239,100,26)),
            HSL(Hsl.stdv(220,78,30)),
            HSL(Hsl.stdv(213,100,54))
        }
        CLR.init(self, self.color, color_table)
        CLR.startColorLoop(self)

        self.tp = "cage" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Cage:kill()
    if self.death then return end
    self.death = true
end

function Cage:draw()
    local p = self

    Color.set(p.color)
    Draw_Smooth_Ring(p.pos.x, p.pos.y, p.r, p.r - p.cage_width)

end

--Update this enemy
function Cage:update(dt)

    c = self

    --Update radius
    if self.target_radius and math.abs(self.r - self.target_radius) > 2 then
        self.r = self.r + self.radius_speed*dt*sign(self.target_radius-self.r)
    elseif self.target_radius then
        self.r = self.target_radius
        self.target_radius = nil
    end

    --Push psycho position if its beyond the ring
    local p = Util.findId("psycho")
    if p and p.pos:dist(c.pos) > c.r - c.cage_width - p.r then
        local diff = p.pos:dist(c.pos) - (c.r - c.cage_width - p.r)
        p.pos = p.pos - (p.pos - c.pos):normalized()*diff
    end

end

function Cage:resize(desired_radius, radius_speed)
	self.target_radius = desired_radius
	if radius_speed then
		self.radius_speed = radius_speed
	end
end

--UTILITY FUNCTIONS--

function enemy.create(x, y, radius, growth_speed)
    local e

    e = Cage(x, y, radius, growth_speed)
    e:addElement(DRAW_TABLE.L4u, "cages")

    return e
end

--return functions
return enemy
