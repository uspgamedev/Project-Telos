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
    init = function(self, _x, _y, _text, _font, _var, _mode, _var_font, _align, _limit)
        WTXT.init(self, _text, _font) --Set text
        POS.init(self, _x, _y)

        self.var = _var --Optional variable that the text can print
        self.mode = _mode or "right" --How to print the var
        self.var_font = _var_font or _var
        self.tp = "text" --Type of this class
        self.format = _format or false
        self.align = _align or "center"
        self.limit = _limit or ORIGINAL_WINDOW_WIDTH/2

        self.alpha = 255 --This object alpha
    end
}



--Draws a text that can have a var, with an optional argument for mode:
--mode == "right": Prints the text, followed by the variable. [DEFAULT]
--mode == "left": Prints the variable, followed by the text.
--mode == "down": Prints the text, and under it, the variable.
--mode == "format": Prints the text formated (with print).
function Text:draw()
    local t, text, color

    t = self
    color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.a = t.alpha
    --Draws button text
    Color.set(color)
    love.graphics.setFont(t.font)
    --Case of variable
    if t.var then
        if     t.mode == "right" then
            love.graphics.print(t.text .. t.var, t.pos.x, t.pos.y)
        elseif t.mode == "left" then
            love.graphics.print(t.var .. t.text, t.pos.x, t.pos.y)
        elseif t.mode == "down" then
            love.graphics.print(t.text, t.pos.x, t.pos.y)
            love.graphics.setFont(t.var_font)
            love.graphics.print(t.var, t.pos.x, t.pos.y + t.font:getHeight(t.text) + 2)
        end
    --Format text without variable
    elseif t.mode == "format" then
        love.graphics.printf(t.text, t.pos.x, t.pos.y, t.limit, t.align)
    --Not having a variable, simple text
    else
        love.graphics.print(t.text, t.pos.x, t.pos.y)
    end
end

--UTILITY FUNCTIONS--

--Create a text in the gui draw table
function text.create_gui(x, y, text, font, var, mode, var_font, id, align, limit)
    local txt

    txt = Text(x, y, text, font, var, mode, var_font, align, limit)
    txt:addElement(DRAW_TABLE.GUI, "gui", id)
    return txt
end

--Create a text in the game_gui draw table
function text.create_game_gui(x, y, text, font, var, mode, var_font, id, align, limit)
    local txt

    txt = Text(x, y, text, font, var, mode, var_font, align, limit)
    txt:addElement(DRAW_TABLE.GAME_GUI, "gui", id)

    return txt
end


--Return functions
return text
