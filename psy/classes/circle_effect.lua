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
    init = function(self, _x, _y, _alpha, _game_win_idx)
        local radius, color

        radius = 5

        CIRC.init(self, _x, _y, radius, nil, nil, "line") --Set atributes

        self.speed = 150 --Growing speed value
        self.line_width = 3
        self.alpha = _alpha or 50
        self.alpha_decaying_speed = 7

        self.game_win_idx = _game_win_idx or 1

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
    color.a = circle.alpha


    --Draw the circle effect, bounded by game window
    local win = WINM.getWin(self.game_win_idx)
    local func = function()
        love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)
    end
    love.graphics.stencil(func, "replace", 1)
    love.graphics.setStencilTest("equal", 1)
    Color.set(color)
    love.graphics.setLineWidth(circle.line_width)
    love.graphics.circle("line", circle.pos.x, circle.pos.y, circle.r)
    love.graphics.setStencilTest()
end

function Circle_FX:update(dt)
    local c

    c = self
    --Update position
    c.r = c.r + dt*c.speed

    --Update alpha
    c.alpha = math.max(c.alpha - c.alpha_decaying_speed*dt,0)

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
function fx.create(pos, alpha, game_win_idx, st)
    local circle

    st = st or "growing_circle" --subtype

    circle = Circle_FX(pos.x, pos.y, alpha, game_win_idx)

    circle:addElement(DRAW_TABLE.L1, st)

    return circle
end

--Return functions
return fx
