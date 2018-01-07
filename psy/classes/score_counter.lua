require "classes.primitive"
local Color = require "classes.color.color"
local Txt = require "classes.text"
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

        self.score_cont = 0 --Player score counter number
        self.score_to_add = 0 --Score player has received but hasn't yet being added to score counter.

        --Variables to add gradually score to score counter
        self.tick = 0
        self.tick_max = .05 --Time between gradually additions to score

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

  --Draw score number
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

--Move all popups down, making them a little more transparent
function ScoreCounter:rearrangePopups()

  local all_popups = Util.findSbTp("score_popup_text")

  if not all_popups then return end

  for popup in pairs(all_popups) do
    local handle1 = LEVEL_TIMER:tween(.3, popup.pos, {y = popup.pos.y + 27})
    local handle2 = LEVEL_TIMER:tween(.3, popup, {alpha = popup.alpha - 50})
    table.insert(popup.level_handles, handle1)
    table.insert(popup.level_handles, handle2)
  end

end

--Create new popup text--
function ScoreCounter:createPopup(score, text)

  --First rearrange all popups down
  self:rearrangePopups()

  local fade_duration = .3 --Time for popup to appear/disappear
  local popup_duration = 2.1 --Time popup remains visible

  --Create text
  if score > 0 then signal = "+" else signal = "" end --Get correct sign
  local score_text = signal..score
  local extra_text = text and (text .. "  ") or ""
  local score_font = GUI_MED
  local extra_font = GUI_MEDLESS
  local x = ORIGINAL_WINDOW_WIDTH - self.gap_width - extra_font:getWidth(extra_text) - score_font:getWidth(score_text)
  local y = self:getStartYPosition() + self:getHeight()

  --Create popup
  local t = Txt.create_game_gui(x, y, extra_text, extra_font, score_text, "right", score_font, nil, nil, nil, nil, "score_popup_text")

  --Create popup effect
  t.alpha = 0
  t.level_handles["fade-in-alpha"] =
    LEVEL_TIMER:tween(fade_duration,
                      t,
                      {alpha = 255},
                      'in-linear'
   )
   t.level_handles["fade-in-y"] =
   LEVEL_TIMER:tween(fade_duration,
                         t.pos,
                         {y = t.pos.y + 5},
                         'in-linear',
                          function()
                            t.level_handles["popup-duration"] =
                              LEVEL_TIMER:after(popup_duration,
                                                function()
                                                  t.level_handles["fade-out-alpha"] =
                                                    LEVEL_TIMER:tween(fade_duration,
                                                                      t,
                                                                      {alpha = 0},
                                                                      'in-linear',
                                                                      function()
                                                                        t.death = true
                                                                      end
                                                   )
                                                end
                              )
                          end
    )

end


function ScoreCounter:giveScore(score, text)

  --Score will be gradually added
  self.score_to_add = self.score_to_add + score

  self:createPopup(score,text)
end

function ScoreCounter:update(dt)
    local s = self
    local p = Util.findId("psycho")

    --Time to update score counter numer
    s.tick = s.tick + dt
    while s.tick >= s.tick_max do
      s.tick = s.tick - s.tick_max

      --Update score counter gradually
      if s.score_to_add > 0 then
        --Find biggest multiple of 10 smaller or equal to score_to_add
        local i = 1
        while (10*i <= s.score_to_add) do
          i = i*10
        end

        while i >= 1 and s.score_to_add >= i do
          s.score_to_add = s.score_to_add - i
          s.score_cont = s.score_cont + i
          i = i/10
        end
      elseif s.score_to_add < 0 then
        --Find biggest negative multiple of 10 bigger or equal to score_to_add
        local i = -1
        while (10*i >= s.score_to_add) do
          i = i*10
        end

        while i <= -1 and s.score_to_add <= i do
          s.score_to_add = s.score_to_add - i
          s.score_cont = s.score_cont + i
          i = i/10
        end
      end

    end

    --Update score x position
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
