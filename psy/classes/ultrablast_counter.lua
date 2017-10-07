require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local LM = require "level_manager"

--ULTRABLAST COUNTER CLASS--
--[[Displays how many ultrablasts the player has]]

local funcs = {}

---------------------------
--ULRABLAST COUNTER CLASS--
---------------------------

--Draws all ultrablast icons
UltrablastCounter = Class{
    __includes = {ELEMENT},
    init = function(self, _x, _y)

        ELEMENT.init(self)
        self.pos = Vector(_x, _y) --Center position of first ultrablat icon

        self.alpha = 255

        self.ultra_cont = 0 --Number of ultrablasts

        --Ultrablast icon graphic constants
        self.ultra_first_radius = 12
        self.ultra_gap_width = 4
        self.ultra_ring_width = 4
        self.gap_between_ultras = 10

        self.charge_bar_value = 0 --Current value of bar
        self.charge_bar_max = 100 --Max value a bar can have before giving a utlrablast to player
        self.charge_bar_speed = 30 --Speed to increase bar per second

        self.charge_bar_w = 10 --Charge bar width
        self.charge_bar_h = 20 --Charge bar max height
        self.charge_bar_gap = 2 --Space between charge bar and outline
        self.charge_bar_line_width = 2 --Line width

    end
}

--CLASS FUNCTIONS--

function UltrablastCounter:draw()
  local s = self

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = s.alpha
  Color.set(color)

  for i = 0, s.ultra_cont-1 do
    local x = s.pos.x + i*(2*s.ultra_first_radius + 2*s.ultra_gap_width + 2*s.ultra_ring_width + s.gap_between_ultras)
    local y = s.pos.y

    --Draw ultrablast icon
    Draw_Smooth_Circle(x, y, s.ultra_first_radius)
    Draw_Smooth_Ring(x, y, s.ultra_first_radius+s.ultra_gap_width+s.ultra_ring_width,s.ultra_first_radius+s.ultra_gap_width)

  end

  --Draw charge bar
  if s.ultra_cont < MAX_ULTRABLAST then
    local x = s.pos.x + s.ultra_cont*(2*s.ultra_first_radius + 2*s.ultra_gap_width + 2*s.ultra_ring_width + s.gap_between_ultras)
    local y = s.pos.y - s.charge_bar_h/2
    local w = s.charge_bar_w
    local h = s.charge_bar_h * (s.charge_bar_value/s.charge_bar_max)
    love.graphics.rectangle("fill", x, y, w, h)
    x = x - s.charge_bar_gap - s.charge_bar_line_width
    y = y - s.charge_bar_gap - s.charge_bar_line_width
    love.graphics.setLineWidth(s.charge_bar_line_width)
    w = w + 2*s.charge_bar_gap  + 2*s.charge_bar_line_width
    h = s.charge_bar_h + 2*s.charge_bar_gap  + 2*s.charge_bar_line_width
    love.graphics.rectangle("line", x, y, w, h)

  end

end

function UltrablastCounter:getStartPosition()
  return self.pos.x - self.ultra_first_radius - self.ultra_gap_width - self.ultra_ring_width
end

function UltrablastCounter:getIconWidth()
    return 2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width + self.gap_between_ultras
end

function UltrablastCounter:getWidth()
  local width = 0
  width = width + self:getStartPosition()
  if self.ultra_cont < MAX_ULTRABLAST then
    for i = 1, self.ultra_cont + 1 do
      width = width + self:getIconWidth()
    end
  else
    for i = 1, self.ultra_cont do
      width = width + self:getIconWidth()
    end
  end

  return width
end

function UltrablastCounter:update(dt)

    local p = Util.findId("psycho")

    if p then
      --Update utlrablast cont
      self.ultra_cont = p.ultrablast_counter

      --Update charge bar
      if self.ultra_cont >= MAX_ULTRABLAST then
        self.charge_bar_value = 0
      else
        self.charge_bar_value = self.charge_bar_value + self.charge_bar_speed*dt
        if self.charge_bar_value >= self.charge_bar_max then
          self.charge_bar_value = self.charge_bar_value - self.charge_bar_max
          LM.giveUltrablast(1)
        end
      end

      --Update change text
      local txt = Util.findId("ultrablast_change")
      if txt then txt.x = self:getWidth() end
    end


end

--UTILITY FUNCTIONS--

--Create a regular aim with and id
function funcs.create(x, y)

    ultra = UltrablastCounter(x, y)

    ultra:addElement(DRAW_TABLE.GAME_GUI, "game_gui", "ultrablast_counter")

    return ultra
end

--Return functions
return funcs
