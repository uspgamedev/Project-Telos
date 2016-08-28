require "classes.primitive"
local Color = require "classes.color.color"
--TEXT CLASS --

local text = {}

-------------
--SIMPLE TEXT
-------------


--[[Simple Text that can print a variable]]
Text = Class{
    __includes = {ELEMENT, WTXT, POS},
    init = function(self, _x, _y, _text, _font, _t_color, _var, _mode)
        WTXT.init(self, _text, _font, _t_color) --Set text
        POS.init(self, _x, _y)

        self.var = var --Optional variable that the text can print
        self.mode = _mode --How to print the var
        self.tp = "text" --Type of this class
    end
}



--Draws a text that can have a var, with an optional argument for mode:
--mode == "right": Prints the text, followed by the variable. [DEFAULT]
--mode == "left": Prints the variable, followed by the text.
function Text:draw()
    local t

    t = self

    --Draws button text
    Color.set(t.t_color)
    love.graphics.setFont(t.font)
    --Case of variable
    if t.var then
        if not mode or mode == "right" then
            love.graphics.print(t.text .. t.var, t.pos.x, t.pos.y)
        elseif mode == "left" then
            love.graphics.print(t.var .. t.text, t.pos.x, t.pos.y)
        end
    --Not having a variable
    else
        love.graphics.print(t.text, t.pos.x, t.pos.y)
    end
end

--Return functions
return text
