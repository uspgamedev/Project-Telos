require "classes.primitive"
local Hsl = require "classes.color.hsl"
--UI CLASS--
--[[UI general stuff]]

local ui = {}

--Particle that has an alpha decaying over-time
UI_Color = Class{
    __includes = {CLR},
    init = function(self)
        local color_table, color, color_duration

        color_table = {
            HSL(Hsl.stdv(57,100,54.9)), --Cadmium Yellow
            HSL(Hsl.stdv(12,100,38.8)), --Mahogany
            HSL(Hsl.stdv(307,94.4,35.3)), --Heliotrope Magenta
            HSL(Hsl.stdv(125,88.2,56.9)) --Lime Green
        }

        color = HSL(Hsl.stdv(307,94.4,35.3))

        color_duration = 15

        CLR.init(self, color, color_table, color_duration)

        self.handles = {}
        self.tp = "ui_color" --Type of this class
    end
}

--Create an ui_color and start color looping
function ui.create_color()
    local UI

    UI = UI_Color()
    UI:startColorLoop()

    return UI
end

--Return functions
return ui
