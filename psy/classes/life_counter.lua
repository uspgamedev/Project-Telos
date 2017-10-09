require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local LM = require "level_manager"

--LIFE COUNTER CLASS--
--[[Displays how many lives the player has]]

local funcs = {}

---------------------------
--LIVES COUNTER CLASS--
---------------------------

--Draws all ultrablast icons
LifeCounter = Class{
    __includes = {ELEMENT},
    init = function(self, _x, _y)

        ELEMENT.init(self)
        self.pos = Vector(_x, _y) --Center position of first ultrablat icon

        self.alpha = 255

        self.life_cont = 0 --Number of lives player have

        --Fonts
        self.life_font = GUI_LIFE_COUNTER
        self.x_font = GUI_LIFE_COUNTER_X

        --Psycho icon graphic constants
        self.psycho_icon_radius = 20
        self.gap_width = 6

    end
}

--CLASS FUNCTIONS--

function LifeCounter:draw()
  local s = self

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = s.alpha
  Color.set(color)


  --Draw life number
  local x = s.pos.x
  local y = s.pos.y
  local font = s.life_font
  local text = s.life_cont
  love.graphics.setFont(font)
  love.graphics.print(text, x, y)

  --Draw 'X'
  local y_offset = -0
  x = x + font:getWidth(text) + s.gap_width
  y = y + y_offset
  font = s.x_font
  text = "x"
  love.graphics.setFont(font)
  love.graphics.print(text, x, y)

  --Draw psycho icon
  x = x + font:getWidth(text) + s.gap_width + s.psycho_icon_radius
  y = y + s.psycho_icon_radius - y_offset
  Draw_Smooth_Circle(x, y, s.psycho_icon_radius)



end

function LifeCounter:getStartYPosition()
  return self.pos.y
end

function LifeCounter:getStartXPosition()
  return self.pos.x
end

--Return width of the indicator
function LifeCounter:getWidth()
  local s = self
  return s.life_font:getWidth(s.life_cont) + s.gap_width + s.x_font:getWidth("X") + s.gap_width + 2*s.psycho_icon_radius
end

function LifeCounter:update(dt)

    local p = Util.findId("psycho")

    if p then
      self.life_cont = p.lives
    end

end

--UTILITY FUNCTIONS--

function funcs.create(x, y)

    local counter = LifeCounter(x, y)

    counter:addElement(DRAW_TABLE.GAME_GUI, "game_gui", "life_counter")

    return counter
end

--Return functions
return funcs
