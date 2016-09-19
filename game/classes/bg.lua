require "classes.primitive"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
--BACKGROUND CLASS--
--[[Background iamge being drawn behind everything]]

local bg = {}

--Particle that has an alpha decaying over-time
Background = Class{
    __includes = {RECT},
    init = function(self)
        local color_table

        color_table = {
            HSL(Hsl.stdv(259,60,5)),  --Dark purple
            HSL(Hsl.stdv(126,60,5)), --Dark green
            HSL(Hsl.stdv(338,60,5)), --Dark red
            HSL(Hsl.stdv(37,60,5)), --Dark yellow
            HSL(Hsl.stdv(223,60,5)) --Dark blue
        }

        RECT.init(self, 0, 0, ORIGINAL_WINDOW_WIDTH, ORIGINAL_WINDOW_HEIGHT, color_table[love.math.random(#color_table)], color_table) --Set atributes

        self.color_duration = 10 --Duration between color transitions

        self.tp = "background" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Background:draw()
    local bg

    bg = self

    --Draws the particle
    Color.set(bg.color)
    love.graphics.rectangle("fill", bg.pos.x, bg.pos.y, bg.w, bg.h)
end


--UTILITY FUNCTIONS--

--Create the background image (transitioning)
function bg.create()
    local bg, id

    id = "background" --identification

    bg = Background()
    bg:addElement(DRAW_TABLE.BG, nil, id)
    bg:startColorLoop()

    return bg
end

--Return functions
return bg
