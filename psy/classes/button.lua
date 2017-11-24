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
    init = function(self, _x, _y, _r, _func, _text, _font)
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

        self.sfx = nil --Sfx to play when button is pressed

        self.tp = "circlebutton" --Type of this class
    end
}



--Draws a given circle button with centralized text
function Circle_Button:draw()
    local fwidth, fheight, tx, ty, b, color

    b = self

    --Draws button circle ring

    color = Color.black()
    Color.copy(color, UI_COLOR.color)
    color.h = (color.h + 125)%255
    color.a = math.min((b.ring_r/(b.r/b.alpha_mod_v))^4, 1)*256*b.alpha_modifier
    Color.set(color)
    love.graphics.setLineWidth(b.line_width)
    love.graphics.circle("line", b.pos.x, b.pos.y, b.ring_r)

    fwidth  = b.font:getWidth(b.text)  --Width of font
    fheight = b.font:getHeight(b.text) --Height of font
    tx = fwidth/2      --Relative x position of font on textbox
    ty = fheight/2     --Relative y position of font on textbox

    --Draws button text
    Color.copy(color, UI_COLOR.color)
    color.a = 256*b.alpha_modifier
    Color.set(color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.pos.x - tx , b.pos.y - ty)

end

function Circle_Button:update(dt)
    local b, x, y, mousepos

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
        if not USING_JOYSTICK and not self.selected_by_joystick then
          Util.findId(CURRENT_SELECTED_BUTTON.."_button").selected_by_joystick = false
          self.selected_by_joystick = true
          CURRENT_SELECTED_BUTTON = string.sub(self.id, 1, -8)
        end
        if b.ring_r < b.r then
            b.ring_r = b.ring_r + b.ring_growth_speed*speed_mod*dt
            if b.ring_r > b.r then b.ring_r = b.r end
        end
    else
        if b.ring_r > 0 then
            b.ring_r = b.ring_r - b.ring_growth_speed*speed_mod*dt
            if b.ring_r < 0 then b.ring_r = 0 end
        end
    end

    --If ring is big enough, has a small chance to create a decaying particle
    if b.ring_r > b.r/5 and love.math.random() > .9 then
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

        Particle.create_decaying(pos, dir, color, speed, 200, 2)
    end
end

--UTILITY FUNCTIONS--

function button.create_circle_gui(x, y, r, func, text, font, st, id)
    local b

    st = st or "gui"
    b = Circle_Button(x, y, r, func, text, font)
    b:addElement(DRAW_TABLE.GUI, st, id)

    return b
end

------------
--INV BUTTON
------------

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
    if x >= b.pos.x and
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

--Return functions
return button
