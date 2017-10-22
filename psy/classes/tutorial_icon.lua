require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"

--TUTORIAL ICON CLASS--
--[[Displays an icon on the screen that fades after some time or when psycho collides with it]]

local funcs = {}

---------------------------
--TUTORIAL ICON CLASS--
---------------------------

--Draws a tutorial icon on given position.
--Types accepted:
  --"space": Creates a spacebar
  --"shift": Creates a shift key
  --"left_mouse_button": Creates a mouse icon with left button highlighted
  --"right_mouse_button": Creates a mouse icon with right button highlighted
  --Other text: Creates a keyboard key with given type as text
TutorialIcon = Class{
    __includes = {ELEMENT},
    init = function(self, _x, _y, _type, _duration, _colliding_with_psycho_kills_me_flag)

        local w, h = funcs.dimensions(_type)

        RECT.init(self, _x, _y, w, h)

        self.alpha = 0

        self.type = _type

        self.deactivating = false

        self.colliding_with_psycho_kills_me = _colliding_with_psycho_kills_me_flag

        self:activate(_duration)

    end
}

--CLASS FUNCTIONS--

function TutorialIcon:activate(duration)
  local d = .5

  self.level_handles["activate"] = LEVEL_TIMER:tween(d, self, {alpha = 180}, 'in-linear')

  if duration then
    self.level_handles["deactivate"] = LEVEL_TIMER:after(d+duration,
      function()
        self:deactivate()
      end)
  end

end

function TutorialIcon:deactivate()
  local d = 1
  if self.deactivating then return end

  self.deactivating = true

  self.level_handles["deactivating"] = LEVEL_TIMER:tween(d, self, {alpha = 0}, 'in-linear',
    function()
      self.death = true
    end
  )

end


function TutorialIcon:draw()
  local s = self


  --Set icon color to be UI's
  local color = Color.black()
  Color.copy(color, UI_COLOR.color)
  color.a = s.alpha
  Color.set(color)

  local roundness_of_corners = 8
  local inside_line_ratio = .7
  local inside_line_y_offset = -3
  love.graphics.setLineWidth(2)

  if     self.type == "space" then
    --Draw keyboard-key outer outline
    local x, y, w, h = s.pos.x, s.pos.y, s.w, s.h
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)
    --Draw keyboard-key inner outline
    x = x + (w-w*inside_line_ratio)/2
    y = y + (h-h*inside_line_ratio)/2 + inside_line_y_offset
    w = w*inside_line_ratio
    h = h*inside_line_ratio
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)

    --Draw space key text
    color.a = color.a + 20
    Color.set(color)
    local font = GUI_TUTORIAL_ICON
    love.graphics.setFont(font)
    x = x + w/2 - font:getWidth("space")/2
    y = y + h/2 - font:getHeight("space")/2
    love.graphics.print("space", x, y)
    --
  elseif self.type == "shift" then
    local inside_line_x_ratio = .8
    --Draw keyboard-key outer outline
    local x, y, w, h = s.pos.x, s.pos.y, s.w, s.h
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)
    --Draw keyboard-key inner outline
    x = x + (w-w*inside_line_x_ratio)/2
    y = y + (h-h*inside_line_ratio)/2 + inside_line_y_offset
    w = w*inside_line_x_ratio
    h = h*inside_line_ratio
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)

    --Draw shift-key image and text
    color.a = color.a + 20
    Color.set(color)
    local font = GUI_TUTORIAL_ICON
    local sx, sy = .4, .4
    x = x + 2
    y = y + h/2 - IMG.shift_icon:getHeight()*sy/2
    love.graphics.draw(IMG.shift_icon, x, y, 0, sx, sy)
    local font = GUI_TUTORIAL_SHIFT_ICON
    love.graphics.setFont(font)
    x =  x + IMG.shift_icon:getWidth()*sx + 2
    y = s.pos.y + s.h/2 - font:getHeight("shift")/2
    love.graphics.print("shift", x, y)

  elseif self.type == "left_mouse_button" then
    --Draw mouse outline
    love.graphics.draw(IMG.mouse_icon, s.pos.x, s.pos.y)

    --Draw left mouse button icon
    color.a = color.a + 20
    Color.set(color)
    love.graphics.draw(IMG.left_mouse_button_icon, s.pos.x, s.pos.y)
  elseif self.type == "right_mouse_button" then
    --Draw mouse outline
    love.graphics.draw(IMG.mouse_icon, s.pos.x, s.pos.y)

    --Draw right mouse button icon
    color.a = color.a + 20
    Color.set(color)
    love.graphics.draw(IMG.right_mouse_button_icon, s.pos.x, s.pos.y)
  else
    --Draw keyboard-key outer outline
    local x, y, w, h = s.pos.x, s.pos.y, s.w, s.h
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)
    --Draw keyboard-key inner outline
    x = x + (w-w*inside_line_ratio)/2
    y = y + (h-h*inside_line_ratio)/2 + inside_line_y_offset
    w = w*inside_line_ratio
    h = h*inside_line_ratio
    love.graphics.rectangle("line", x, y, w, h, roundness_of_corners)

    --Draw keyboard-key text
    color.a = color.a + 20
    Color.set(color)
    local font = GUI_TUTORIAL_ICON
    love.graphics.setFont(font)
    x = x + w/2 - font:getWidth(s.type)/2
    y = y + h/2 - font:getHeight(s.type)/2
    love.graphics.print(s.type, x, y)
  end

end




function TutorialIcon:update(dt)

    local s = self
    local p = Util.findId("psycho")

    --If icon collides with psycho, deactivates
    if not s.deactivating and s.colliding_with_psycho_kills_me and p then

      --Check collision of icon with psycho
      local closest_point_x = math.max(s.pos.x, math.min(p.pos.x, s.pos.x + s.w))
      local closest_point_y = math.max(s.pos.y, math.min(p.pos.y, s.pos.y + s.h))
      local dx = p.pos.x - closest_point_x
      local dy = p.pos.y - closest_point_y

      if (dx*dx + dy*dy) < (p.r*p.r) then
        s:deactivate()
      end

    end

end

--UTILITY FUNCTIONS--

function funcs.create(x, y, type, duration, colliding_with_psycho_kills_me_flag)

    local icon = TutorialIcon(x, y, type, duration, colliding_with_psycho_kills_me_flag)

    icon:addElement(DRAW_TABLE.L2, "tutorial_icon")

    return icon
end

--Return dimensions of icon based on type
function funcs.dimensions(type)

  if     type == "space" then
    return 200, 50
  elseif type == "shift" then
    return 160, 80
  elseif type == "left_mouse_button" then
    return IMG.mouse_icon:getDimensions()
  elseif type == "right_mouse_button" then
    return IMG.mouse_icon:getDimensions()
  else
    return 50, 50
  end

end

--Return functions
return funcs
