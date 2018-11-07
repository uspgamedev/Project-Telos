require "classes.primitive"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"

--CURRENT SELECTED OPTIONS CIRCLE CLASS--
--[[A circle to indicate which option is selected in the config screen]]

local funcs = {}

--------------
--CIRCLE CLASS--
--------------

local CurrentCircle = Class{
    __includes = {CIRC},
    init = function(self, x, y, r)
        CIRC.init(self, x, y, r)

        self.line_width = 4
    end
}

--CLASS FUNCTIONS--

function CurrentCircle:draw()
    local c = self

    local color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.h = (color.h + 127)%256
    Color.set(color)

    Draw_Smooth_Ring(c.pos.x, c.pos.y, c.r, c.r-c.line_width)
end

--UTILITY FUNCTIONS--

function funcs.create(x, y, r)
    local circ = CurrentCircle(x, y, r)
    circ:addElement(DRAW_TABLE.GAME_GUI, nil, "current_selected_option_circle")
    return circ
end

--Return functions
return funcs
