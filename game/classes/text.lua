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
    init = function(self, _x, _y, _text, _font, _var, _mode, _var_font)
        WTXT.init(self, _text, _font) --Set text
        POS.init(self, _x, _y)

        self.var = _var --Optional variable that the text can print
        self.mode = _mode --How to print the var
        self.var_font = _var_font or _var
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
    Color.set(UI_COLOR.color)
    love.graphics.setFont(t.font)
    --Case of variable
    if t.var then
        if not t.mode or t.mode == "right" then
            love.graphics.print(t.text .. t.var, t.pos.x, t.pos.y)
        elseif t.mode == "left" then
            love.graphics.print(t.var .. t.text, t.pos.x, t.pos.y)
        elseif t.mode == "down" then
            love.graphics.print(t.text, t.pos.x, t.pos.y)
            love.graphics.setFont(t.var_font)
            love.graphics.print(t.var, t.pos.x, t.pos.y + t.font:getHeight(t.text) + 2)
        end
    --Not having a variable
    else
        love.graphics.print(t.text, t.pos.x, t.pos.y)
    end
end

--UTILITY FUNCTIONS--

--Create a text
function text.create_gui(x, y, text, font, var, mode, var_font, id)
    local txt

    txt = Text(x, y, text, font, var, mode, var_font)
    txt:addElement(DRAW_TABLE.GUI, "gui", id)

    return txt
end


--Return functions
return text
