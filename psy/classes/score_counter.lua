require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local LM = require "level_manager"

--SCORE COUNTER CLASS--
--[[Displays player score]]

local funcs = {}

-----------------------
--LIVES COUNTER CLASS--
-----------------------

--Draws player score on the right side of screen
ScoreCounter = Class{
    __includes = {ELEMENT},
    init = function(self, _y)

        ELEMENT.init(self)
        self.pos = Vector(0, _y)

        self.alpha = 255

        self.score_cont = 0 --Number of lives player have

        --Fonts
        self.score_font = GUI_SCORE_COUNTER

        self.gap_width = 10 --Distance from border to draw score

    end
}

--CLASS FUNCTIONS--

function ScoreCounter:draw()
  local s = self

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = s.alpha
  Color.set(color)


  --Draw life number
  local x = s.pos.x
  local y = s.pos.y
  local font = s.score_font
  local text = s.score_cont
  love.graphics.setFont(font)
  love.graphics.print(text, x, y)

end

function ScoreCounter:getStartYPosition()
  return self.pos.y
end

function ScoreCounter:getStartXPosition()
  return self.pos.x
end

function ScoreCounter:getGap()
  return self.gap_width
end

--Return width of the indicator
function ScoreCounter:getHeight()
  local s = self
  return s.score_font:getHeight(s.score_cont)
end

function ScoreCounter:update(dt)

    local p = Util.findId("psycho")

    if p then
      self.score_cont = p.score
    end

    self.pos.x = ORIGINAL_WINDOW_WIDTH - self.gap_width - self.score_font:getWidth(self.score_cont)

end

--UTILITY FUNCTIONS--

function funcs.create(y)
    local counter = ScoreCounter(y)

    counter:addElement(DRAW_TABLE.GAME_GUI, "game_gui", "score_counter")

    return counter
end

--Return functions
return funcs
