require "classes.primitive"
local Bullet = require "classes.bullet"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local FreeRes = require "FreeRes"
local C_FX = require "classes.circle_effect"
--PSYCHO CLASS--
--[[Our hero... or is it VILLAIN??!!]]

local psycho = {}

Psy = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)
        local color, color_table, r

        color_table = {
            HSL(Hsl.stdv(51,100,50)),
            HSL(Hsl.stdv(355,89,48)),
            HSL(Hsl.stdv(95,89,42)),
            HSL(Hsl.stdv(207,81,49)),
            HSL(Hsl.stdv(271,75,52)),
            HSL(Hsl.stdv(329,82.1,54.1)), -- Barbie Pink
            HSL(Hsl.stdv(280,90.5,28.8)), -- Indigo
            HSL(Hsl.stdv(16,100,52)) -- Internacional Orange (Aerospace)

        } --Color table
        color = color_table[love.math.random(#color_table)] --Color of enemy
        r = 24 --Radius of psycho
        self.collision_r = 19 --Radius of psycho that detects collision

        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes

        ELEMENT.setSubTp(self, "player")
        ELEMENT.setId(self, "psycho")

        self.color_duration = 3 --Duration between color transitions
        self.ui_color = false --If its color should be the same as the ui

        self.speedv = 265 --Speed value
        self.speed = Vector(0,0) --Speed vector

        self.shoot_tick = 0 --Bullet "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = .14 --How fast to shoot bullet

        self.circle_fx_tick = 0 --Circle Effect "cooldown" timer
        self.circle_fx_fps = .2 --How fast to create the circle effect


        self.lives = 8 --How many lives psycho by default has
        self.invincible = false --If psycho can't collide with enemies
        self.controlsLocked = false --If psycho cant move or shoot

        self.tp = "psycho" --Type of this class

    end
}

--CLASS FUNCTIONS--

function Psy:draw()
    local p

    p = self

    --Draws the circle
    if not p.ui_color then
        Color.set(p.color)
    else
        Color.set(UI_COLOR.color)
    end
    love.graphics.circle("fill", p.pos.x, p.pos.y, p.r)
end

function Psy:shoot(x,y)
    local p, bullet, dir, c, color_table, w, h, scale

    p = self
    if p.controlsLocked then return end

    --Fix mouse position click to respective distance
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    c = HSL(Hsl.hsl(p.color)) --COlor of bullet is current psycho color
    color_table = {
        HSL(Hsl.stdv(51,100,50)),
        HSL(Hsl.stdv(355,89,48)),
        HSL(Hsl.stdv(95, 89,42)),
        HSL(Hsl.stdv(207,81,49)),
        HSL(Hsl.stdv(271,75,52))
    }

    dir = Vector(x-p.pos.x, y-p.pos.y)
    dir = dir:normalized()
    Bullet.create(p.pos.x, p.pos.y, dir, c, color_table, "player_bullet")

end

function Psy:update(dt)
    local p

    p = self

    --Update shooting
    p.shoot_tick = p.shoot_tick - dt
    if love.mouse.isDown(1) then
        if p.shoot_tick <= 0 then
            p.shoot_tick = p.shoot_tick + p.shoot_fps
            p:shoot(love.mouse.getPosition())
        end
    end
    if p.shoot_tick < 0 then
        p.shoot_tick = 0
    end

    --Leave before moving psycho or creating circle effects
    if p.controlsLocked then return end

    --Create circle effect
    p.circle_fx_tick = p.circle_fx_tick - dt
    if p.circle_fx_tick <= 0 then
        p.circle_fx_tick = p.circle_fx_tick + p.circle_fx_fps
        C_FX.create(p.pos)
    end

    --Update movement
    p.pos = p.pos + dt*p.speed
    --Fixes if psycho leaves screen
    p.pos = p.pos + dt*p.speedv*isOutside(p)
end

function Psy:kill()
    local p

    if GODMODE then return end --GODMODE cheat

    p = self

    if p.lives == 0 then return end

    p.lives = p.lives - 1 --Reduces psycho's lives
    Util.findId("lives_counter").var = p.lives

    if not p.death and p.lives == 0 then
        FX.explosion(p.pos.x, p.pos.y, p.r, p.color, 60, 200, .994, 4)
        p.death = true
        SWITCH =  "GAMEOVER"
    else
        FX.psychoExplosion(p)
    end
end

function Psy:keypressed(key)
    local p, sp

    p = self --Psycho
    sp = p.speedv --Speed Value

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
        psycho.updateSpeed(self)
    end

end

function Psy:keyreleased(key)

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
      psycho.updateSpeed(self)
  end

end

--Make psycho temporarily invincible
function Psy:startInvincible()
    local d, count, p

    p = self

    d = 2 --Time psycho is invincible
    c = 8 --Number of times he blinks

    p.invincible = true

    --Blinks psycho for d seconds
    FX_TIMER:every(d/(2*c),
        function()
            --local p = psycho.get()

            p.invisible = not p.invisible

        end,
    2*c)

    --Makes psycho visible and vunerable again
    FX_TIMER:after(d + .2,
        function()
            --local p = psycho.get()

            p.invisible = false
            p.invincible = false

        end)
end

--UTILITY FUNCTIONS--

function psycho.create(x, y)
    local p, handle

    x, y = x or ORIGINAL_WINDOW_WIDTH/2, y or  ORIGINAL_WINDOW_HEIGHT/2

    p = Psy(x, y)
    p:addElement(DRAW_TABLE.L4)
    p.ui_color = true
    handle = COLOR_TIMER:after(2.5,
        function()
            p.ui_color = false
            Color.copy(p.color, UI_COLOR.color)
            p:startColorLoop()
        end
    )
    table.insert(p.handles, handle)

    return p
end

function psycho.get()
  return Util.findId("psycho")
end

--LOCAL FUNCTIONS--

function psycho.updateSpeed(self)

    p = self --Psycho
    sp = p.speedv --Speed Value

    p.speed = Vector(0,0)
    --Movement
    if love.keyboard.isDown 'w' or love.keyboard.isDown 'up' then --move up
        p.speed = p.speed + Vector(0,-1)
    end
    if love.keyboard.isDown 'a' or love.keyboard.isDown 'left' then --move left
        p.speed = p.speed + Vector(-1,0)
    end
    if love.keyboard.isDown 's' or love.keyboard.isDown 'down' then --move down
        p.speed = p.speed + Vector(0,1)
    end
    if love.keyboard.isDown'd' or love.keyboard.isDown 'right' then --move right
        p.speed = p.speed + Vector(1,0)
    end

    p.speed = p.speed:normalized() * sp

end

--Checks if psycho has leaved (even if partially) the game screen and returns correction vector
function isOutside(o)
    local v, r, scale

    scale = FreeRes.scale()

    v = Vector(0,0)

    --X position
    if     o.pos.x - o.r <= 0 then
        v = v + Vector(1,0)
    elseif o.pos.x + o.r >= ORIGINAL_WINDOW_WIDTH then
        v = v + Vector(-1,0)
    end
    --Y position
    if o.pos.y - o.r <= 0 then
        v = v + Vector(0,1)
    elseif o.pos.y + o.r >= ORIGINAL_WINDOW_HEIGHT then
        v = v + Vector(0,-1)
    end

    return v:normalized()
end

--return function
return psycho
