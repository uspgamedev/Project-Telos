require "classes.primitive"
local Util = require "util"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"

--LOCAL FUNCTIONS--
local function sign(n)
	return n < 0 and -1 or n > 0 and 1 or 0
end

--CAGE CLASS--
--[[Cage is (not really an) enemy that imprisons psycho]]

local enemy = {}

Cage = Class{
    __includes = {ELEMENT, CLR, POS},
    init = function(self, _x, _y, _radius, _growth_speed, _game_win_idx)
        ELEMENT.init(self)

        self.game_win_idx = _game_win_idx

        self.target_pos = nil --Target pos this cage will go to
        self.target_radius = _radius --Target radius this cage will resize to

        self.radius_speed = _growth_speed --Speed to change radius size
        self.pos_speed = 100 --Speed to change position

        POS.init(self,_x, _y)
        local win = WINM.getWin(self.game_win_idx)
        self.r = math.sqrt(win.w*win.w/4 + win.h*win.h/4) + 10

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
    local win = WINM.getWin(self.game_win_idx)
	self.target_radius = math.sqrt(win.w*win.w/4 + win.h*win.h/4) + 10
	self.radius_speed = speed
	self.target_pos = nil
end

function Cage:draw()
    local p = self

    Color.set(p.color)

    --Stencils enemy to its game window
    local win = WINM.getWin(p.game_win_idx)
    local func = function()
        love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)
    end
    Draw_Smooth_Ring(p.pos.x, p.pos.y, p.r, p.r - p.cage_width, self.target_radius, func)

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
    local win = WINM.getWin(self.game_win_idx)
    if p and (p.pos+Vector(win.x,win.y)):dist(c.pos) > c.r - c.cage_width - p.r then
        local diff = (p.pos+Vector(win.x,win.y)):dist(c.pos) - (c.r - c.cage_width - p.r)
        p.pos = p.pos - ((p.pos+Vector(win.x,win.y)) - c.pos):normalized()*diff
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

function enemy.create(x, y, radius, growth_speed, game_win_idx)
    local e

    e = Cage(x, y, radius, growth_speed, game_win_idx)
    e:addElement(DRAW_TABLE.L4u, "cages")

    return e
end

--return functions
return enemy
