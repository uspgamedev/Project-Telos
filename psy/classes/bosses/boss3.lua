require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local F = require "formation"
local Indicator = require "classes.indicator"
local LM = require "level_manager"

--BOSS #3 CLASS--
--[[coisas]]

local boss = {}

Boss_3 = Class{
    __includes = {ELEMENT},
    init = function(self)
        ELEMENT.init(self)

        self.pos = Vector(WINDOW_WIDTH/2, WINDOW_HEIGHT/2)
        self.r = 30

    end
}

function Boss_3:draw()
    local p = self

    Color.set(Color.red())
    Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r)
end

--Behaviours--

--Collision--
function Boss_3:getHit(arg)
end

function boss.create()

    local b = Boss_3()
    b:addElement(DRAW_TABLE.BOSS, "bosses") --make boss appear

    return b
end

--return function
return boss
