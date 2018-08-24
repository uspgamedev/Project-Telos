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
    init = function(self, _x, _y, _text, _font, _var, _mode, _var_font, _align, _limit, _invert)
        WTXT.init(self, _text, _font) --Set text
        POS.init(self, _x, _y)

        self.var = _var --Optional variable that the text can print
        self.mode = _mode or "right" --How to print the var
        self.var_font = _var_font or _var
        self.tp = "text" --Type of this class
        self.format = _format or false
        self.align = _align or "center"
        self.limit = _limit or WINDOW_WIDTH/2
        self.invert = _invert or false

        self.alpha = 255 --This object alpha

        ELEMENT.init(self)

        self.tp = "text"
    end
}



--Draws a text that can have a var, with an optional argument for mode:
--mode == "right": Prints the text, followed by the variable. [DEFAULT]
--mode == "left": Prints the variable, followed by the text.
--mode == "down": Prints the text, and under it, the variable.
--mode == "format": Prints the text formated (with print).
--Obs: Variable will be drawn centered to text if mode is "right" or "left"
function Text:draw()
    local t, text, color

    t = self
    color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.a = math.max(t.alpha,0)
    if t.invert then
        color.h = (color.h + 127)%255
    end

    --Draws button text
    Color.set(color)
    love.graphics.setFont(t.font)
    --Case of variable
    if t.var then
        if     t.mode == "right" then
            if t.var_font and t.var_font ~= t.font then
              love.graphics.print(t.text, t.pos.x, t.pos.y)
              love.graphics.setFont(t.var_font)
              love.graphics.print(t.var, t.pos.x + t.font:getWidth(t.text), t.pos.y + t.font:getHeight(t.text)/2 - t.var_font:getHeight(t.var)/2)
            else
              love.graphics.print(t.text .. t.var, t.pos.x, t.pos.y)
            end
        elseif t.mode == "left" then
          if t.var_font and t.var_font ~= t.font then
            love.graphics.setFont(t.var_font)
            love.graphics.print(t.var, t.pos.x, t.pos.y + t.font:getHeight(t.text)/2 - t.var_font:getHeight(t.var)/2)
            love.graphics.setFont(t.font)
            love.graphics.print(t.text, t.pos.x  + t.var_font:getWidth(t.var), t.pos.y)
          else
            love.graphics.print(t.text .. t.var, t.pos.x, t.pos.y)
          end
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

--Create a regular text in the L2 layer, with an optional subtype st and id
function text.create_text(x, y, text, font, st, id)
    local txt

    txt = Text(x, y, text, font)
    txt:addElement(DRAW_TABLE.L2, st, id)
    return txt
end

--Create a text in the gui draw table
function text.create_gui(x, y, text, font, var, mode, var_font, id, align, limit, invert, sbtp)
    local txt
    sbtp = sbtp or "gui"
    txt = Text(x, y, text, font, var, mode, var_font, align, limit, invert)
    txt:addElement(DRAW_TABLE.GUI, sbtp, id)
    return txt
end

--Create a text in the game_gui draw table
function text.create_game_gui(x, y, text, font, var, mode, var_font, id, align, limit, invert, st)
    local txt

    st = st or "game_gui"
    txt = Text(x, y, text, font, var, mode, var_font, align, limit, invert)
    txt:addElement(DRAW_TABLE.GAME_GUI, st, id)

    return txt
end


--Return functions
return text
