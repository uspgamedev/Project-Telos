require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local FreeRes = require "FreeRes"
--PSYCHO AIM CLASS--
--[[Line and circle representing psycho's aim]]

local aim_functions = {}

---------------
--REGULAR AIM--
---------------

--Line that aims in a direction
Aim = Class{
    __includes = {ELEMENT},
    init = function(self)

        ELEMENT.init(self) --Set atributes

        self.pos = Vector(0,0)
        self.dir = Vector(0,0)
        self.distance = math.sqrt(ORIGINAL_WINDOW_WIDTH^2 + ORIGINAL_WINDOW_HEIGHT^2)
        self.line_width = 2 --Thickness of aim line
        self.circle_size = 6 --Radius of aim circle
        self.mouse_pos = Vector(0,0) --Position the mouse is

        self.show = true --If should show the aim or not (for joystick mode)

        self.alpha = 0 --Alpha of aim

        self.tp = "aim" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Aim:draw()
    local aim, color, p, size

    p = Util.findId("psycho")

    if not p then return end

    aim = self
    color = Color.black()
    if not p.ui_color then
        Color.copy(color, p.color)
    else
        Color.copy(color, UI_COLOR.color)
    end
    color.a = (not p.invisible) and aim.alpha or 0 --Make aim line invisible when psycho is blinking


    --Draw the line

    --Draw line only if psycho can shoot
    if p.can_shoot and self.show then
        Color.set(color)
        love.graphics.setLineWidth(aim.line_width)
        love.graphics.line(aim.pos.x, aim.pos.y, aim.pos.x + aim.distance*aim.dir.x, aim.pos.y + aim.distance*aim.dir.y)
    end

    --Draw the circle
    if not USING_JOYSTICK then
      color.h = (color.h + 127)%255
      color.a = 255

      Color.set(color)
      size = aim.circle_size
      --Shrink size of aim when psycho can't shoot
      if not p.can_shoot then size = 3 end
      Draw_Smooth_Circle(aim.mouse_pos.x, aim.mouse_pos.y, size)
    end

end

function Aim:update(dt)
    local aim, p, w, h, scale

    aim = self
    p = Util.findId("psycho")
    if not p then return end

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --Update circle position
    aim.mouse_pos.x, aim.mouse_pos.y = x, y

    --Update line position
    aim.pos.x, aim.pos.y = p.pos.x, p.pos.y
    aim.show = true
    if not USING_JOYSTICK then
      aim.dir.x, aim.dir.y = aim.mouse_pos.x - aim.pos.x, aim.mouse_pos.y - aim.pos.y
  elseif CURRENT_JOYSTICK and (CURRENT_JOYSTICK:getAxis(DEFAULT_GAMEPAD_MAPPING.raxis_horizontal) ~= 0 or CURRENT_JOYSTICK:getAxis(DEFAULT_GAMEPAD_MAPPING.raxis_vertical) ~= 0) then
      local v = Vector(Util.getJoystickAxisValues(CURRENT_JOYSTICK, DEFAULT_GAMEPAD_MAPPING.raxis_horizontal, DEFAULT_GAMEPAD_MAPPING.raxis_vertical))
      v = v:normalized()
      aim.dir.x, aim.dir.y = (aim.pos.x + v.x)-aim.pos.x, (aim.pos.y + v.y)-aim.pos.y
    else
      aim.show = false
    end
    aim.dir = aim.dir:normalized()

end

--UTILITY FUNCTIONS--

--Create a regular aim with and id
function aim_functions.create(id, remain_invisible)
    local aim

    id = id or "aim" --subtype

    aim = Aim()

    aim:addElement(DRAW_TABLE.L5, nil, id)

    if not remain_invisible then
      --Fade in the aim
      LEVEL_TIMER:after(2.2,
          function()
              LEVEL_TIMER:tween(.3, aim, {alpha = 90}, 'in-linear')
          end
      )
    end

    return aim
end

--Line that aims in a direction
Indicator_Aim = Class{
    __includes = {ELEMENT, CLR},
    init = function(self, _x, _y, _c)

        ELEMENT.init(self) --Set atributes
        CLR.init(self, _c)

        self.pos = Vector(_x, _y) --Center of aim
        self.line_width = 3 --Thickness of aim line
        self.alpha = 0 --Alpha of aim

        self.tp = "indicator_aim" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Indicator_Aim:draw()
    local aim, color

    aim = self
    color = aim.color
    color.a = aim.alpha
    p = Util.findId("psycho")

    --Draw the line
    Color.set(color)
    love.graphics.setLineWidth(aim.line_width)
    love.graphics.line(aim.pos.x, aim.pos.y, p.pos.x, p.pos.y)

end

--UTILITY FUNCTIONS--

--Create a regular aim with and st
function aim_functions.create_indicator(x, y, c, st)
    local aim, h1, h2

    st = st or "indicator_aim" --subtype

    aim = Indicator_Aim(x, y, c)

    aim:addElement(DRAW_TABLE.L2, st)

    --Fade in the aim
    h1 = LEVEL_TIMER:after(2,
        function()
            LEVEL_TIMER:tween(1, aim, {alpha = 30}, 'in-linear')
        end
    )
    --Fade out the aim
    h2 = LEVEL_TIMER:after(7,
        function()
            LEVEL_TIMER:tween(1, aim, {alpha = 0}, 'in-linear',
                function()
                    aim.death = true
                end
            )
        end
    )

    return aim, h1, h2
end

--Return functions
return aim_functions
