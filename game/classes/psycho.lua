require "classes.primitive"
local Rgb = require "classes.rgb"
--BUTTON CLASS --

local psycho = {}

--[[Square button with centralized text]]

PSYCHO = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _r, _b_color, _func, _text, _font, _t_color)
        self.tp = "button" --Type of this class

        CIRC.init(self, _x, _y, _r, _b_color, "fill") --Set atributes

        self.func  = _func  --Function to call when pressed

        WTXT.init(self, _text, _font, _t_color) --Set text
    end
}
