require "classes.primitive"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"

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
        self.pos = Vector(25, 285)

        self.alpha = 255

        --Circle of logo balls params
        self.number_of_stacks = 50 --How many rows the circle has
        self.center_offset = Vector(503, 55) --Center of circle (offset based on logo position)
        self.circle_min_radius = 105 --Minimum distance from center the stacks begin
        self.circle_radius = self.circle_min_radius --Distance from center the stacks begin
        self.circle_gap = 15 --Gap between "new game" button ring and stack circle
        self.rotation_angle = 2*math.pi/self.number_of_stacks --Angle to rotate between each stack
        self.stacks = {} --Stacks of stack of logo balls
        for i = 1, self.number_of_stacks do
            self.stacks[i] = {} --Stack of logo balls
            for j = 1, love.math.random(1,10) do
              table.insert(self.stacks[i], true)
            end
        end
        self.stack_initial_rotation = 0 --Stack initial rotation
        self.stack_rotation_speed = -math.pi/18 --Stack rotation speed

        self.logo_balls_radius = 6 --Logo balls radius
        self.logo_balls_gap = 4 --Space between logo balls in the same stack

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

  --Draw logo stack of balls
  love.graphics.push()
  love.graphics.translate(self.center_offset.x + self.pos.x, self.center_offset.y + self.pos.y)
  love.graphics.rotate(self.stack_initial_rotation)
  for i = 1, self.number_of_stacks do
    local x = 0
    local y = self.circle_radius
    for j = 1, #self.stacks[i] do
      if self.stacks[i][j] == true then
        Draw_Smooth_Circle(x, y, self.logo_balls_radius)
      end
      y = y + 2*self.logo_balls_radius + self.logo_balls_gap
    end
    love.graphics.rotate(self.rotation_angle)
  end
  love.graphics.pop()


  --Draw logo text
  color.h = (color.h+127)%255
  Color.set(color)
  love.graphics.setFont(self.logo_font)
  love.graphics.print("PSYCH", self.pos.x, self.pos.y)
  love.graphics.print("THE", self.pos.x + 650, self.pos.y - 50)
  love.graphics.print("BALL", self.pos.x + 650, self.pos.y + 50)



end


function Logo:update(dt)

  --Update circle radius based on "new game" button ring radius
  local b = Util.findId("menu_play_button")
  if b then
    self.circle_radius = math.max(self.circle_min_radius, b.ring_r + self.circle_gap)
  end

  --Rotate stack
  self.stack_initial_rotation = self.stack_initial_rotation + dt*self.stack_rotation_speed

end

--UTILITY FUNCTIONS--

function funcs.create()
    local logo = Logo()

    logo:addElement(DRAW_TABLE.GAME_GUI, nil, "logo")

    return logo
end

--Return functions
return funcs
