require "classes.primitive"
local Color = require "classes.color.color"
local FreeRes = require "FreeRes"
local Particle = require "classes.particle"
local Util = require "util"
--BUTTON CLASS --

local button = {}

---------------
--CIRCLE BUTTON
---------------


--[[
Circle button with centralized text
When mouse is over, a circle ring increses size until it reaches button radius
]]
Circle_Button = Class{
    __includes = {CIRC, WTXT},
    init = function(self, _x, _y, _r, _func, _text, _font, _overtext, _overfont)
        CIRC.init(self, _x, _y, _r, nil, "fill") --Set atributes

        self.func  = _func  --Function to call when pressed

        WTXT.init(self, _text, _font, nil) --Set text

        self.ring_r = 0 --Circle ring radius
        self.ring_growth_speed = 700 --Speed to increase or decrease radius
        self.line_width = 6 --Line width for circle ring

        self.lock = false --If this button can't be activated

        self.alpha_mod_v = 1 --Determines how fast alpha value will reach the peak
        self.alpha_modifier = 1 --Modifier applied on alpha value of button

        self.selected_by_joystick = false

        self.overtext = _overtext --Text to display above button when highlighted, if any
        self.overfont = _overfont or GUI_DEFAULT_OVERFONT --Font of overtext, if any

        self.sfx = nil --Sfx to play when button is pressed

        self.tp = "circlebutton" --Type of this class
    end
}



--Draws a given circle button with centralized text
function Circle_Button:draw()
    local tx, ty, b, color

    b = self

    --Draws button circle ring

    color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.h = (color.h + 125)%255
    local alfa = math.min((b.ring_r/(b.r/b.alpha_mod_v))^4, 1)*256*b.alpha_modifier
    color.a = alfa
    Color.set(color)
    love.graphics.setLineWidth(b.line_width)
    love.graphics.circle("line", b.pos.x, b.pos.y, b.ring_r)


    --Draws button text
    tx = b.font:getWidth(b.text)/2  --Relative x position of font on textbox
    ty = b.font:getHeight(b.text)/2 --Relative y position of font on textbox
    Color.copy(color, UI_COLOR.color)
    color.a = 256*b.alpha_modifier
    Color.set(color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.pos.x - tx , b.pos.y - ty)

    --Draws button overtext, if any
    if b.overtext then
        tx = b.overfont:getWidth(b.overtext)/2   --Relative x position of font on textbox
        ty = b.overfont:getHeight(b.overtext)  --Relative y position of font on textbox
        Color.copy(color, UI_COLOR.color)
        color.a = alfa
        Color.set(color)
        love.graphics.setFont(b.overfont)
        love.graphics.print(b.overtext, b.pos.x - tx , b.pos.y - b.r - ty - 6)
    end
end

function Circle_Button:update(dt)
    local b, x, y, mousepos

    if GETTING_INPUT then return end

    b = self

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    mousepos = Vector(x, y)


    --If mouse is colliding with button total radius, or joystick is selecting ths button (and button is visible), increase ring radius
    local speed_mod = math.max((b.r-b.ring_r)/b.r,.4)
    if ((not USING_JOYSTICK and b.pos:dist(mousepos) <= b.r) or (USING_JOYSTICK and self.selected_by_joystick)) and
    b.alpha_modifier >= .3 then
        --Update selected button on menu
        local cur_selec_but = Gamestate.getCurrentSelectedButton()
        if cur_selec_but then
            Util.findId(cur_selec_but.."_button").selected_by_joystick = false
        end
        Gamestate.setCurrentSelectedButton(string.sub(self.id, 1, -8))
        self.selected_by_joystick = true

        --Increase ring size until max
        if b.ring_r < b.r then
            b.ring_r = b.ring_r + b.ring_growth_speed*speed_mod*dt
            if b.ring_r > b.r then b.ring_r = b.r end
        end
    else
        b.selected_by_joystick = false
        if b.ring_r > 0 then
            b.ring_r = b.ring_r - b.ring_growth_speed*speed_mod*dt
            if b.ring_r < 0 then b.ring_r = 0 end
        end
    end

    --If ring is big enough, has a small chance to create a decaying particle
    if b.ring_r > b.r/5 and love.math.random() < .12 then
        local dir, angle, radius, pos, color, speed

        --Randomize position inside the given circle
        angle = 2*math.pi*love.math.random()
        radius = 2*b.r*love.math.random()
        if radius > b.r then
            radius = 2*b.r-radius
        end
        pos = Vector(0,0)
        pos.x = b.pos.x + radius*math.cos(angle)
        pos.y = b.pos.y + radius*math.sin(angle)

        --Make direction outwards from circle
        dir = Vector(pos.x - b.pos.x, pos.y - b.pos.y)

        --Get color the same as ring
        color = Color.black()
        Color.copy(color, UI_COLOR.color)
        color.h = (color.h + 125)%255
        color.a = color.a * b.alpha_modifier
        speed = 150

        Particle.create_decaying(pos, dir, color, speed, 200, 2, DRAW_TABLE.GUIl, "button_particles")
    end
end

--UTILITY FUNCTIONS--

function button.create_circle_gui(x, y, r, func, text, font, st, id, overtext, overfont)
    local b

    st = st or "gui"
    b = Circle_Button(x, y, r, func, text, font, overtext, overfont)
    b:addElement(DRAW_TABLE.GUI, st, id)

    return b
end

--------------
--INV BUTTON--
--------------

--[[Text button with an invisible box behind (for collision)]]
Inv_Button = Class{
    __includes = {RECT, WTXT},
    init = function(self, _x, _y, _func, _text, _font, _overtext, _overfont)
        local w, h

        w = _font:getWidth(_text)
        h = _font:getHeight(_text)

        RECT.init(self, _x, _y, w, h, Color.transp(), "fill") --Set atributes

        self.func  = _func  --Function to call when pressed

        WTXT.init(self, _text, _font, nil) --Set text

        self.overtext = _overtext --Text to appear below button if mouse is over
        self.overfont = _overfont --Font of overtext
        self.isOver = false --If mouse is over the button

        self.sfx = nil --Sfx to play when button is pressed

        self.lock = false --If this button can't be activated

        self.tp = "invbutton" --Type of this class
    end
}

function Inv_Button:update(dt)
    local b, x, y, mousepos

    b = self

    if not b.overtext then return end

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --If mouse is colliding with button, then show message below
    if not USING_JOYSTICK and
       x >= b.pos.x and
       x <= b.pos.x + b.w and
       y >= b.pos.y and
       y <= b.pos.y + b.h then
           b.isOver = true
   else
       b.isOver = false
   end

end

--Draws a given square button with text aligned to the left
function Inv_Button:draw()
    local b, x, w, y

    b = self

    --Draws button text
    Color.set(UI_COLOR.color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.pos.x , b.pos.y)

    --Print overtext, aligned with center of the normal text
    if b.overtext and b.isOver then
        love.graphics.setFont(b.overfont)
        x = b.pos.x + b.w/2 - b.overfont:getWidth(b.overtext)/2 --Centralize overtext with text
        y = b.pos.y + b.overfont:getHeight(b.text) + 6 --Get position below text
        love.graphics.print(b.overtext, x, y)
    end

end

--UTILITY FUNCTIONS--

function button.create_inv_gui(x, y, func, text, font, overtext, overfont, st)
    local b

    st = st or "gui"
    b = Inv_Button(x, y, func, text, font, overtext, overfont)
    b:addElement(DRAW_TABLE.GUI, st)

    return b
end

----------------------
--KEY BINDING BUTTON--
----------------------

--[[Text button with an invisible box behind (for collision)]]
KeyBinding_Button = Class{
    __includes = {RECT, WTXT},
    init = function(self, _x, _y, _command_id, _current_key)
        local w, h = 170, 45

        RECT.init(self, _x, _y, w, h, Color.transp(), "line") --Set atributes

        self.command_id = _command_id --Command it can change
        self.current_key = _current_key --Current key associated with that command

        self.key_font = GUI_MED
        self.command_font = GUI_MEDMED

        self.alpha_modifier = 1

        self.getting_input = false
        self.input_type = (string.sub(_command_id, 2, 5) == "axis") and "axis" or  "button"

        self.selected_by_joystick = false

        self.isOver = false --If mouse is over the button
        self.lock = false --If this button can't be activated

        self.tp = "keybindingbutton" --Type of this class
    end
}

function KeyBinding_Button:update(dt)
    local b, x, y, mousepos

    b = self

    if GETTING_INPUT then
        if self.getting_input and INPUT_GOT then
            self.current_key = INPUT_GOT
            GAMEPAD_MAPPING[self.command_id] = INPUT_GOT
            self.getting_input = false
            INPUT_GOT = nil
            GETTING_INPUT = false
            return
        else
            return
        end
    end

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --If mouse is colliding with button, then create over_effect
    if not USING_JOYSTICK and
       x >= b.pos.x and
       x <= b.pos.x + b.w and
       y >= b.pos.y and
       y <= b.pos.y + b.h then
           b.isOver = true
   else
       b.isOver = false
   end

end

--Draws a given key binding button
function KeyBinding_Button:draw()
    local b, x, w, y

    b = self

    --Draws button box
    if (not USING_JOYSTICK and b.isOver) or (USING_JOYSTICK and b.selected_by_joystick) or self.getting_input then
        local color = Color.black()
        Color.copy(color, UI_COLOR.color)
        color.h = (color.h + 127)%255
        Color.set(color)
        love.graphics.setLineWidth(4)
    else
        Color.set(UI_COLOR.color)
        love.graphics.setLineWidth(4)
    end
    love.graphics.rectangle("line", b.pos.x , b.pos.y, b.w, b.h, 7)

    --Draw current key associated with command
    love.graphics.setFont(b.key_font)
    local x = b.pos.x + b.w/2 - b.key_font:getWidth(b.current_key)/2
    local y = b.pos.y + b.h/2 - b.key_font:getHeight(b.current_key)/2
    love.graphics.print(b.current_key, x, y)

    --Draw command name
    local command = COMMAND_ID_NAME[b.command_id]
    local limit = 200
    local width, table = b.command_font:getWrap(command, limit)
    love.graphics.setFont(b.command_font)
    local x = b.pos.x - math.min(width, limit) - 15
    local y = b.pos.y + b.h/2 - b.command_font:getHeight(command)*#table/2
    love.graphics.printf(command, x, y, math.min(width, limit), "right")

end

--Activate keybinding button
function KeyBinding_Button:func()
    if not self.getting_key then
        self.getting_input = true
        GETTING_INPUT = self.input_type
        INPUT_GOT = nil
        if self.input_type == "button" then
            self.current_key = "pick button"
        else
            self.current_key = "pick axis"
            PREVIOUS_AXIS = {CURRENT_JOYSTICK:getAxes()}
        end
    end
end

--UTILITY FUNCTIONS--

function button.create_keybinding_gui(x, y, command, current_key, st, id)
    local b

    st = st or "gui"
    b = KeyBinding_Button(x, y, command, current_key)
    b:addElement(DRAW_TABLE.GUI, st, id)

    return b
end

---------------------
--COLLISION FUNCTIONS
---------------------

--Check if a mouse click collides with any button
function button.checkCollision(x,y)
    local w, h, scale

    --Fix mouse position click to respective distance
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    checkCircleButtonCollision(x,y)

    checkInvButtonCollision(x,y)

    checkKeyBindingButtonCollision(x,y)

end

--Check if a mouse click collides with any circle button
function checkCircleButtonCollision(x,y)

    if BUTTON_LOCK then return end --If buttons are locked, does nothing

    --Iterate on drawable buttons table
    for _,t in pairs(DRAW_TABLE) do
        for b in pairs(t) do
            if  b.tp == "circlebutton"
              and
              not b.lock
              and
              b.pos.x - b.r <= x
              and
              x <= b.pos.x + b.r
              and
              b.pos.y - b.r <= y
              and
              y <= b.pos.y + b.r then
                b:func()
                if b.sfx then b.sfx:play() end
                return
            end
        end
    end

end

--Check if a mouse click collides with any inv button
function checkInvButtonCollision(x,y)

    if BUTTON_LOCK then return end --If buttons are locked, does nothing
    --Iterate on drawable buttons table
    for _,t in pairs(DRAW_TABLE) do
        for b in pairs(t) do
            if  b.tp == "invbutton"
              and
              not b.lock
              and
              x  <= b.pos.x + b.w
              and
              x >= b.pos.x
              and
              y  <= b.pos.y + b.h
              and
              y >= b.pos.y then
                b:func()
                if b.sfx then b.sfx:play() end
                return
            end
        end
    end

end

--Check if a mouse click collides with any keybinding button
function checkKeyBindingButtonCollision(x,y)

    if BUTTON_LOCK then return end --If buttons are locked, does nothing
    --Iterate on drawable buttons table
    for _,t in pairs(DRAW_TABLE) do
        for b in pairs(t) do
            if  b.tp == "keybindingbutton"
              and
              not b.lock
              and
              x  <= b.pos.x + b.w
              and
              x >= b.pos.x
              and
              y  <= b.pos.y + b.h
              and
              y >= b.pos.y then
                b:func()
                --play SFX
                return
            end
        end
    end

end


--Return functions
return button
