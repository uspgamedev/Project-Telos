require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--CIRCLE EFFECT CLASS--
--[[Rings-growing-from-psycho effect]]

local fx = {}

-----------------
--Circle Effect--
-----------------

--Particle that has an alpha decaying over-time
Circle_FX = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        local radius, color

        radius = 5

        CIRC.init(self, _x, _y, radius, nil, nil, "line") --Set atributes

        self.speed = 150 --Growing speed value
        self.line_width = 3

        self.tp = "circle_fx" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Circle_FX:draw()
    local circle, color

    circle = self
    color = Color.black()
    Color.copy(color, Util.findId("background").color)
    color.l = 40
    color.a = 50


    --Draw the circle effect
    Color.set(color)
    love.graphics.setLineWidth(circle.line_width)
    love.graphics.circle("line", circle.pos.x, circle.pos.y, circle.r)
end

function Circle_FX:update(dt)
    local c

    c = self
    --Update position
    c.r = c.r + dt*c.speed

    --If all the four corners are inside the circle, it can be removed
    if (0 - c.pos.x)^2 + (0 - c.pos.y)^2 < (c.r-c.line_width)^2 and
       (WINDOW_WIDTH - c.pos.x)^2 + (0 - c.pos.y)^2 < (c.r-c.line_width)^2 and
       (0 - c.pos.x)^2 + (WINDOW_HEIGHT - c.pos.y)^2 < (c.r-c.line_width)^2 and
       (WINDOW_WIDTH - c.pos.x)^2 + (WINDOW_HEIGHT - c.pos.y)^2 < (c.r-c.line_width)^2 then
           c.death = true
    end

end

--UTILITY FUNCTIONS--

--Create a particle in the (x,y) position, direction dir, color c, radius r and subtype st
function fx.create(pos, st)
    local circle

    st = st or "growing_circle" --subtype

    circle = Circle_FX(pos.x, pos.y)

    circle:addElement(DRAW_TABLE.L1, st)

    return circle
end

--Return functions
return fx
