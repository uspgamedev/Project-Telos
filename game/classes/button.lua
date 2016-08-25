require "classes.primitive"
local Color = require "classes.color"
--BUTTON CLASS --

local button = {}

--[[Square button with centralized text]]

But = Class{
    __includes = {CIRC, WTXT},
    init = function(self, _x, _y, _r, _b_color, _func, _text, _font, _t_color)
        self.tp = "button" --Type of this class

        CIRC.init(self, _x, _y, _r, _b_color, "fill") --Set atributes

        self.func  = _func  --Function to call when pressed

        WTXT.init(self, _text, _font, _t_color) --Set text
    end
}



--Draws a given square button with centralized text
function But:draw()
    local fwidth, fheight, tx, ty, b

    b = self

    --Draws button box

    Color.set(b.color)
    love.graphics.circle("fill", b.x, b.y, b.r)

    fwidth  = b.font:getWidth(b.text)  --Width of font
    fheight = b.font:getHeight(b.text) --Height of font
    tx = fwidth/2      --Relative x position of font on textbox
    ty = fheight/2     --Relative y position of font on textbox

    --Draws button text
    Color.set(b.t_color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.x - tx , b.y - ty)

end

--Check if a mouse click collides with any button
function button.checkCollision(x,y)

    if BUTTON_LOCK then return end --If buttons are locked, does nothing

    --Iterate on drawable buttons table
    for _,t in pairs(DRAW_TABLE) do
        for b in pairs(t) do
            if  b.tp == "button"
                and
                b.x - b.r <= x
                and
                x <= b.x + b.r
                and
                b.y - b.r <= y
                and
                y <= b.y + b.r then
                b:func()
                return
            end
        end
    end

end

--Return functions
return button
