require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"

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

        self.ultra_first_radius = 12
        self.ultra_gap_width = 4
        self.ultra_ring_width = 4

        self.gap_between_ultras = 10

    end
}

--CLASS FUNCTIONS--

function UltrablastCounter:draw()
  local s = self
  for i = 0, s.ultra_cont-1 do
    local x = s.pos.x + i*(2*s.ultra_first_radius + 2*s.ultra_gap_width + 2*s.ultra_ring_width + s.gap_between_ultras)
    local y = s.pos.y

    local color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.a = self.alpha

    --Draw ultrablast icon
    Draw_Smooth_Circle(x, y, s.ultra_first_radius)
    Draw_Smooth_Ring(x, y, s.ultra_first_radius+s.ultra_gap_width+s.ultra_ring_width,s.ultra_first_radius+s.ultra_gap_width)

  end


end

function UltrablastCounter:getStartPosition()
  return self.pos.x - self.ultra_first_radius - self.ultra_gap_width - self.ultra_ring_width
end

function UltrablastCounter:getIconWidth()

    return 2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width + self.gap_between_ultras

end

function UltrablastCounter:update(dt)

    local p = Util.findId("psycho")

    if p then
      self.ultra_cont = p.ultrablast_counter
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
