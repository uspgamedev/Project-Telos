require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
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
        self.distance = math.sqrt(WINDOW_WIDTH^2 + WINDOW_HEIGHT^2)
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


    --Draw the aim

    --Draw line only if psycho can shoot, for each game window
    if p.can_shoot and self.show then
        Color.set(color)
        love.graphics.setLineWidth(aim.line_width)
        for i, win in ipairs(GAME_WINDOWS) do
            --Use stencil to not draw line outside respective game window
            local func = function()
                love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)
            end
            love.graphics.stencil(func, "replace", 1)
            love.graphics.setStencilTest("equal", 1)
            if win.active then
                love.graphics.line(aim.pos.x+win.x, aim.pos.y+win.y, aim.pos.x+win.x + aim.distance*aim.dir.x, aim.pos.y+win.y + aim.distance*aim.dir.y)
            end
            love.graphics.setStencilTest()
        end
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

    --Update circle position
    aim.mouse_pos.x, aim.mouse_pos.y = love.mouse.getPosition()

    local mouse_pos

    --Update line position
    aim.pos.x, aim.pos.y = p.pos.x, p.pos.y
    aim.show = true
    if not USING_JOYSTICK then
      --Find out which window the position is, to get correct direction
      local game_win = WINM.winAtPoint(aim.mouse_pos.x,aim.mouse_pos.y)
      if game_win then
          aim.dir.x = aim.mouse_pos.x - (aim.pos.x+game_win.x)
          aim.dir.y = aim.mouse_pos.y - (aim.pos.y+game_win.y)
      else
          aim.dir.x, aim.dir.y = aim.mouse_pos.x - aim.pos.x, aim.mouse_pos.y - aim.pos.y
      end
    elseif CURRENT_JOYSTICK and (Controls.isActive(CURRENT_JOYSTICK, "raxis_horizontal") or Controls.isActive(CURRENT_JOYSTICK, "raxis_vertical")) then
      local v = Vector(Controls.getJoystickAxisValues(CURRENT_JOYSTICK, "raxis_horizontal", "raxis_vertical"))
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
    init = function(self, _x, _y, _c, _game_win_idx)

        ELEMENT.init(self) --Set atributes
        CLR.init(self, _c)

        self.pos = Vector(_x, _y) --Center of aim
        self.line_width = 3 --Thickness of aim line
        self.alpha = 0 --Alpha of aim
        self.game_win_idx = _game_win_idx or 1 --Which game window this indicator is from

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
    local win = WINM.getWin(self.game_win_idx)
    love.graphics.setLineWidth(aim.line_width)
    love.graphics.line(aim.pos.x + win.x, aim.pos.y + win.y, p.pos.x + win.x, p.pos.y + win.y)

end

--UTILITY FUNCTIONS--

--Create a regular aim with and st
function aim_functions.create_indicator(x, y, c, game_win_idx, st)
    local aim, h1, h2

    st = st or "indicator_aim" --subtype

    aim = Indicator_Aim(x, y, c, game_win_idx)

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
