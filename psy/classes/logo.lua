require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local LM = require "level_manager"

--LOGO CLASS--
--[[Logo of the game for the main menu]]

local funcs = {}

--------------
--LOGO CLASS--
--------------

--Draws player score on the right side of screen
Logo = Class{
    __includes = {ELEMENT},
    init = function(self)

        ELEMENT.init(self)
        self.pos = Vector(25, 245)

        self.alpha = 255

        --Fonts
        self.logo_font = GUI_LOGO

    end
}

--CLASS FUNCTIONS--

function Logo:draw()

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.h = (color.h+127)%255
  Color.set(color)

  love.graphics.setFont(self.logo_font)
  love.graphics.print("PSYCH", self.pos.x, self.pos.y)
  color.h = (color.h+127)%255
  Color.set(color)
  love.graphics.print("THE", self.pos.x + 650, self.pos.y - 50)
  love.graphics.print("BALL", self.pos.x + 650, self.pos.y + 50)

end


function Logo:update(dt)

end

--UTILITY FUNCTIONS--

function funcs.create()
    local logo = Logo()

    logo:addElement(DRAW_TABLE.GAME_GUI, nil, "logo")

    return logo
end

--Return functions
return funcs
