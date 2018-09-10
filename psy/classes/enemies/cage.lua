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

        self.color = HSL(Hsl.stdv(344,100,46))

        local color_table = {
            HSL(Hsl.stdv(344,100,46)),
            HSL(Hsl.stdv(9, 92, 47)),
        }
        CLR.init(self, self.color, color_table)
        CLR.startColorLoop(self)

        self.tp = "cage" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Cage:kill(speed)
	speed = speed or 400
	if self.death or self.leaving then return end
    self.leaving = true
	self.target_radius = math.max(WINDOW_WIDTH,WINDOW_HEIGHT) + 100
	self.radius_speed = speed
	self.target_pos = nil
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
		if (self.target_radius-self.r) > 0 then
        	self.r = math.min(self.r + self.radius_speed*dt,self.target_radius)
		else
			self.r = math.max(self.r - self.radius_speed*dt,self.target_radius)
		end
    elseif self.target_radius then
        self.r = self.target_radius
        self.target_radius = nil
		if self.leaving then self.death = true end
    end
	--Update position
	if self.target_pos and self.pos:dist(self.target_pos) >= 3 then
		self.pos.x = self.pos.x + self.pos_speed*dt*sign(self.target_pos.x-self.pos.x)
		self.pos.y = self.pos.y + self.pos_speed*dt*sign(self.target_pos.y-self.pos.y)
	elseif self.target_pos then
		self.pos = self.target_pos
		self.target_pos = nil
	end

    --Push psycho position if its beyond the ring
    local p = Util.findId("psycho")
    if p and p.pos:dist(c.pos) > c.r - c.cage_width - p.r then
        local diff = p.pos:dist(c.pos) - (c.r - c.cage_width - p.r)
        p.pos = p.pos - (p.pos - c.pos):normalized()*diff
    end

end

function Cage:resize(desired_radius, radius_speed)
	if self.leaving or self.death then return end
	self.target_radius = desired_radius
	if radius_speed then
		self.radius_speed = radius_speed
	end
end

--Move directly to target position
function Cage:goTo(x, y, pos_speed)
	if self.leaving or self.death then return end
	self.target_pos = Vector(x, y)
	if pos_speed then
		self.pos_speed = pos_speed
	end
end

--Move a certain quantity from current position
function Cage:move(dx, dy, pos_speed)
	if self.leaving or self.death then return end
	self.target_pos = Vector(self.pos.x+dx, self.pos.y+dy)
	if pos_speed then
		self.pos_speed = pos_speed
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
