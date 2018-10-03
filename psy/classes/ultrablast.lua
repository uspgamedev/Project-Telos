require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"

--ULTRABLAST CLASS--
--[[Powerfull attack psycho can unleash killing nearby enemies]]

local ultrablast = {}

---------------
--REGULAR AIM--
---------------

--Line that aims in a direction
Ultrablast = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _c, _power, _game_win)

        CIRC.init(self, _x, _y, 12, _c, nil, "line")

        self.line_width = _power/4 + 1 --Thickness of blast

        self.power = _power --How many enemies this blast can destroy
        self.speedv = 700 --How fast to grow

        self.game_win = _game_win or 1

        self.alpha = 200

        self.tp = "ultrablast" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Ultrablast:draw()
    local ultra, color

    ultra = self

    --Set ultrablast alpha value
    color = Color.white()
    Color.copy(color, ultra.color)
    color.a = ultra.alpha

    --Draw the circle, bounded by its game window
    local win = WINM.getWin(self.game_win)
    local func = function()
        love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)
    end
    love.graphics.stencil(func, "replace", 1)
    love.graphics.setStencilTest("equal", 1)
    Color.set(color)
    love.graphics.setLineWidth(ultra.line_width)
    love.graphics.circle(ultra.mode, ultra.pos.x, ultra.pos.y, ultra.r)
    love.graphics.setStencilTest()
end

function Ultrablast:takeHit()

    if self.power <= 0 then return end

    self.power = self.power - 1 --Decrease this ultrablast

    if self.power <= 0 then
        self.death = true
    end

end

function Ultrablast:update(dt)
    local ultra

    ultra = self

    if ultra.death then return end

    ultra.line_width = ultra.power/4 + 1 --Thickness of blast

    ultra.r = ultra.r + ultra.speedv*dt

    local win = WINM.getWin(self.game_win)

    --If all the four corners are inside the circle, it can be removed
    if (win.x - ultra.pos.x)^2 + (win.y - ultra.pos.y)^2 < (ultra.r-ultra.line_width)^2 and
       (win.x + win.w - ultra.pos.x)^2 + (win.y - ultra.pos.y)^2 < (ultra.r-ultra.line_width)^2 and
       (win.x - ultra.pos.x)^2 + (win.y + win.h - ultra.pos.y)^2 < (ultra.r-ultra.line_width)^2 and
       (win.x + win.w - ultra.pos.x)^2 + (win.y + win.h - ultra.pos.y)^2 < (ultra.r-ultra.line_width)^2 then
           ultra.death = true
    end


end

--Checks if an circular object o collides with this ultrablast
function Ultrablast:collides(o)
    local ultra, object_dist, min_dist, max_dist

    ultra = self

    object_dist = ultra.pos:dist(o.pos) --Obejct distance from ultrablast center

    min_dist = ultra.r - ultra.line_width - o.r --Minimum distance the object can be to collide
    max_dist = ultra.r + o.r --Maximum distance the object can be to collide
    return ((object_dist >  min_dist) and (object_dist < max_dist))

end

--UTILITY FUNCTIONS--

--Create a regular aim with and id
function ultrablast.create(x, y, c, power, game_win)
    local ultra

    st = "ultrablast" --subtype

    ultra = Ultrablast(x, y, c, power, game_win)

    ultra:addElement(DRAW_TABLE.L4, st)
    SFX.ultrablast:play()

    return ultra
end

--Return functions
return ultrablast
