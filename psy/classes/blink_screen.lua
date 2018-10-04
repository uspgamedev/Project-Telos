require "classes.primitive"
--BLINK SCREEN CLASS--
--[[Makes the window white for a short period of time]]


local Blink = Class{
    __includes = {RECT},
    init = function(self)
        RECT.init(self,0,0,WINDOW_WIDTH,WINDOW_HEIGHT)

        self.alpha = 0

        self.tp = "blink_screen"
    end,
    draw = function(self)
        love.graphics.setColor(255, 255, 255, self.alpha)

        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
    end
}

--Return functions
return Blink
