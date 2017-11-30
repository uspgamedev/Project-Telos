require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local LM = require "level_manager"
local FX = require "fx"

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
        self.pos = Vector(_x, _y) --Center position of first ultrablast icon

        self.alpha = 255

        self.ultra_cont = 0 --Number of ultrablasts

        --Ultrablast icon graphic constants
        self.ultra_first_radius = 12
        self.ultra_gap_width = 4
        self.ultra_ring_width = 4
        self.gap_between_ultras = 10

        self.charge_bar_value = 0  --Current value of bar
        self.charge_bar_max = 120  --Max value a bar can have before giving a utlrablast to player
        self.charge_bar_min_speed = 25 --Starting speed of charge bar
        self.charge_bar_max_speed = 80 --Max speed of charge bar
        self.charge_bar_accel_speed = 15 --How fast the speed increases per second
        self.charge_bar_speed = self.charge_bar_min_speed --Speed to increase bar per second

        self.charge_bar_w = 10 --Charge bar width
        self.charge_bar_h = 20 --Charge bar max height
        self.charge_bar_gap = 2 --Space between charge bar and outline
        self.charge_bar_line_width = 2 --Line width
        self.charge_bar_offset = Vector(0,0) --Offset when drawing the charge bar for animation effect
        self.charge_bar_movement_x_offset = 0 --Offset for when an ultrablast is spent

        --Variables for penalty when psycho is shooting
        self.charge_cooldown_max = .6 --Time added when player is shooting
        self.charge_cooldown = 0
        self.charge_penalty = 5 --Penalty deducted from charge value when psycho is shooting repeatedly

        self.overall_scale = 1 --Scale applied in everything being drawn


    end
}

--CLASS FUNCTIONS--

function UltrablastCounter:draw()
  local s = self

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = s.alpha
  Color.set(color)

  --Apply overall offset
  love.graphics.push()
  love.graphics.scale(s.overall_scale)

  for i = 0, s.ultra_cont-1 do
    local x = s.pos.x + i*(2*s.ultra_first_radius + 2*s.ultra_gap_width + 2*s.ultra_ring_width + s.gap_between_ultras)
    local y = s.pos.y

    --Draw ultrablast icon
    Draw_Smooth_Circle(x, y, s.ultra_first_radius)
    love.graphics.setLineWidth(s.ultra_ring_width)
    love.graphics.circle("line", x, y, s.ultra_first_radius+s.ultra_gap_width+s.ultra_ring_width)

  end

  local p = Util.findId("psycho")

  --Draw charge bar
  if s.ultra_cont < MAX_ULTRABLAST then

    if s.charge_cooldown > 0 or (p and not p.can_charge) then
      color.h = (color.h + 127)%255
      Color.set(color)
    end

    local x = s.pos.x + s.ultra_cont*(2*s.ultra_first_radius + 2*s.ultra_gap_width + 2*s.ultra_ring_width + s.gap_between_ultras) - 5 + s.charge_bar_offset.x + s.charge_bar_movement_x_offset
    local y = s.pos.y - s.charge_bar_h/2 + s.charge_bar_offset.y
    local w = s.charge_bar_w
    local h = s.charge_bar_h * (s.charge_bar_value/s.charge_bar_max)
    love.graphics.rectangle("fill", x, y + s.charge_bar_h - h, w, h)
    x = x - s.charge_bar_gap - s.charge_bar_line_width
    y = y - s.charge_bar_gap - s.charge_bar_line_width
    love.graphics.setLineWidth(s.charge_bar_line_width)
    w = w + 2*s.charge_bar_gap  + 2*s.charge_bar_line_width
    h = s.charge_bar_h + 2*s.charge_bar_gap  + 2*s.charge_bar_line_width
    love.graphics.rectangle("line", x, y, w, h)

  end

  --Remove overall offset
  love.graphics.pop()

end

function UltrablastCounter:getStartXPosition()
  return self.pos.x - self.ultra_first_radius - self.ultra_gap_width - self.ultra_ring_width
end

function UltrablastCounter:getStartYPosition()
  return self.pos.y - self.ultra_first_radius - self.ultra_gap_width - self.ultra_ring_width
end


function UltrablastCounter:getIconWidth()
    return 2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width + self.gap_between_ultras
end

function UltrablastCounter:getIconHeight()
    return 2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width
end

--Return max width the indicator can have
function UltrablastCounter:getWidth()
  return MAX_ULTRABLAST*self:getIconWidth()
end

--Return height the indicator can have
function UltrablastCounter:getHeight()
  return self:getIconHeight()
end


--Move charge bar when ultra is used
function UltrablastCounter:ultraUsed()

  self:update(0)

  if self.ultra_cont == (MAX_ULTRABLAST - 1) then return end

  if self.level_handles["used_ultra_animation"] then
    LEVEL_TIMER:cancel(self.level_handles["used_ultra_animation"])
  end

  self.charge_bar_movement_x_offset = 2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width + self.gap_between_ultras

  self.level_handles["used_ultra_animation"] = LEVEL_TIMER:tween(.05, self, {charge_bar_movement_x_offset = 0}, 'in-linear')


end

--Create explosion when ultra is gained
function UltrablastCounter:ultraGained()

  self:update(0)

  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = self.alpha

  local x = self.pos.x + (self.ultra_cont-1)*(2*self.ultra_first_radius + 2*self.ultra_gap_width + 2*self.ultra_ring_width + self.gap_between_ultras)
  local y = self.pos.y
  FX.explosion(x, y, self.ultra_first_radius, color, 25, 150, 400, 3, true)
  if self.alpha > 30 then SFX.ultrablast_bar_complete:play() end


end

--Function called when psycho is shooting
function UltrablastCounter:psychoShot()
  if self.charge_cooldown > 0 then
    self.charge_bar_value = math.max(0, self.charge_bar_value - self.charge_penalty)
  end
  self.charge_cooldown = self.charge_cooldown_max
  self.charge_bar_speed = self.charge_bar_min_speed

  --Remove previous animation, if any
  if self.level_handles["shake_animation"] then
    LEVEL_TIMER:cancel(self.level_handles["shake_animation"])
  end

  if self.charge_bar_value <= 0 then return end

  --Start animation
  local d = .05
  self.charge_bar_offset.x, self.charge_bar_offset.y = -love.math.random(1,2), -love.math.random(1,2)
  self.level_handles["shake_animation"] = LEVEL_TIMER:after(d,
      function()
        self.charge_bar_offset.x, self.charge_bar_offset.y = love.math.random(1,2), love.math.random(1,2)
        self.level_handles["shake_animation"] = LEVEL_TIMER:after(d,
            function()
               self.charge_bar_offset.x, self.charge_bar_offset.y = 0,0
            end
        )
      end
  )
end

function UltrablastCounter:reset()

  self:update(0)

  self.charge_bar_value = 0
  self.charge_bar_speed = self.charge_bar_min_speed
  self.charge_cooldown = self.charge_cooldown_max

  --Create reset effect
  self.overall_scale = 1.05
  if self.level_handles["reset_effect"] then
    LEVEL_TIMER:cancel(self.level_handles["reset_effect"])
  end
  self.level_handles["reset_effect"] = LEVEL_TIMER:tween(.03, self, {overall_scale = 1}, 'in-linear')

end

function UltrablastCounter:update(dt)

    local p = Util.findId("psycho")

    if p then
      --Update utlrablast cont
      self.ultra_cont = p.ultrablast_counter

      if not p.can_charge then return end

      --Update charge bar
      if self.ultra_cont >= MAX_ULTRABLAST then
        self.charge_bar_value = 0
      else
        if self.charge_cooldown > 0 then
          self.charge_cooldown = math.max(0, self.charge_cooldown - dt)
        else
          self.charge_bar_speed = math.min(self.charge_bar_max_speed, self.charge_bar_speed + self.charge_bar_accel_speed*dt)
          self.charge_bar_value = self.charge_bar_value + self.charge_bar_speed*dt
          if self.charge_bar_value >= self.charge_bar_max then
            self.charge_bar_value = self.charge_bar_value - self.charge_bar_max
            LM.giveUltrablast(1)
          end
        end
      end

    end


end

--UTILITY FUNCTIONS--

function funcs.create(x, y)

    local ultra = UltrablastCounter(x, y)

    ultra:addElement(DRAW_TABLE.GAME_GUI, "game_gui", "ultrablast_counter")

    return ultra
end

--Return functions
return funcs
