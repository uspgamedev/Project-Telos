require "classes.primitive"
local LM = require "level_manager"
local Aim = require "classes.psycho_aim"
local Bullet = require "classes.bullet"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local Ultra = require "classes.ultrablast"
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
        self.collision_r = 17 --Radius of psycho that detects collision, and radius when psyho is focused
        self.normal_radius = r --Radius when psycho is not focused
        CIRC.init(self, _x, _y, r, color, color_table, "fill") --Set atributes

        ELEMENT.setSubTp(self, "player")
        ELEMENT.setId(self, "psycho")

        self.color_duration = 3 --Duration between color transitions
        self.ui_color = false --If its color should be the same as the ui

        self.speedv = 265 --Speed value
        self.speed_multiplier = 0 --Multiplier for speed
        self.speed = Vector(0,0) --Speed vector

        self.focused = false --If psycho is focused or not
        self.speedvm_focus = .5 -- Speed value multiplier when focused

        self.shoot_tick = 0 --Bullet "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = .155 --How fast to shoot bullets

        self.circle_fx_tick = 0 --Circle Effect "cooldown" timer
        self.circle_fx_fps = .2 --How fast to create the circle effect

        self.score = 0 --Score psycho has
        self.life_score = 0 --How much score psycho has accumulated to win a life
        self.life_score_target = 8000 --How many points psycho must win to get a life
        self.ultrablast_score = 0 --How much score psycho has accumulated to win a ultrablast
        self.ultrablast_score_target = 2000 --How many points psycho must win to get a ultrablast
        self.can_ultra = true -- If psycho can use ultrablast (for tutorial)

        self.lives = 10 --How many lives psycho by default has

        self.ultrablast_counter = 2 --How many ultrablasts psycho has
        self.default_ultrablast_number = 2 --How many ultrablasts psycho by default has in every life
        self.default_ultrablast_power = 50 --Ultrablast power when using right mouse button

        self.invincible = false --If psycho can't collide with enemies
        self.ultrablast_invincibility_timer = 0 --If its <= 0, then psycho can die (used for invincibility when using ultrablast)
        self.ultrablast_invincibility_timer_max = .5 --How much time psychoball is invincible when using ultrablast
        self.controlsLocked = false --If psycho cant move or shoot
        self.shootLocked = true --If psycho cant shoot or ultrablast

        self.tp = "psycho" --Type of this class

    end
}

--CLASS FUNCTIONS--

function Psy:draw()
    local p, size

    p = self

    --Draws the circle
    if not p.ui_color then
        Color.set(p.color)
    else
        Color.set(UI_COLOR.color)
    end

    Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r)
end

function Psy:shoot(x,y)
    local p, bullet, dir, c, color_table, w, h, scale
     SFX_PSYCHOBALL_SHOT:play()
    p = self
    if p.shootLocked then return end



    --Fix mouse position click to respective distance
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    c = HSL(Hsl.hsl(p.color)) --Color of bullet is current psycho color
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

    --On godmode, shoot 10 bullets instead of 1
    if GODMODE then
        for j = 1,9 do
            Bullet.create(p.pos.x, p.pos.y, dir, c, color_table, "player_bullet")
        end
    end

end

function Psy:ultrablast(power)
    local p

    p = self

    if p.ultrablast_counter <= 0 or not p.can_ultra then return end

    p.ultrablast_invincibility_timer = p.ultrablast_invincibility_timer_max

    --Update ultrablast counter
    LM.giveUltrablast(-1)

    Ultra.create(p.pos.x, p.pos.y, p.color, power)

end

function Psy:update(dt)
    local p

    p = self

    if p.ultrablast_invincibility_timer > 0 then
        p.ultrablast_invincibility_timer = p.ultrablast_invincibility_timer - dt
    end

    --Update psycho radius
    if p.focused and p.r > p.collision_r + 2 then
        p.r = p.r - 20*dt
        if p.r <  p.collision_r + 2 then p.r =  p.collision_r + 2 end --Cap radius to collision radius + 2
    elseif not p.focused and p.r < p.normal_radius then
        p.r = p.r + 20*dt
        if p.r >  p.normal_radius then p.r =  p.normal_radius end --Cap radius to normal_radius
    end

    --Update shooting
    p.shoot_tick = p.shoot_tick - dt
    if love.mouse.isDown(1) or love.keyboard.isDown('z') then
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

    --Psycho is moving, then accelerate
    if p.speed:len() > 0 then
        if p.speed_multiplier < 1 then
            p.speed_multiplier = p.speed_multiplier + 7*dt
            if p.speed_multiplier > 1 then p.speed_multiplier = 1 end
        end
    --Psycho is not moving, slow down
    else
        if p.speed_multiplier > 0 then
            p.speed_multiplier = p.speed_multiplier - 7*dt
            if p.speed_multiplier < 0 then p.speed_multiplier = 0 end
        end
    end

    --Update movement
    if not p.focused then
        p.pos = p.pos + dt*p.speed*p.speed_multiplier
    else
        p.pos = p.pos + dt*p.speed*p.speedvm_focus*p.speed_multiplier
    end
    --Fixes if psycho leaves screen
    p.pos.x, p.pos.y = isOutside(p)
end

function Psy:kill()
    local p, temp

    if GODMODE then return end --GODMODE cheat

    p = self

    if p.ultrablast_invincibility_timer > 0 or p.lives == 0 then return end

    SFX_PSYCHOBALL_DIES:play()

    LM.giveLives(-1)
    temp = p.default_ultrablast_number - p.ultrablast_counter
    if temp ~= 0 then
        LM.giveUltrablast(p.default_ultrablast_number - p.ultrablast_counter, "reset") --Reset ultrablast counter if its not the default
    end


    if not p.death and p.lives <= 0 then
        FX.explosion(p.pos.x, p.pos.y, p.r, p.color, 100, 450, 250, 4)
        p.death = true
        Util.findId("psycho_aim").death = true --Delete aim
        SWITCH =  "GAMEOVER"
    else
        FX.psychoExplosion(p)
    end
end



function Psy:keypressed(key)
    local p

    p = self --Psycho

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
        psycho.updateSpeed(self)
    elseif key == 'lshift' then
        p.focused = true
    elseif key == 'space' then
        if not p.shootLocked then
            p:ultrablast(p.default_ultrablast_power)
        end
    end

end

function Psy:keyreleased(key)

    --Movement
if key == 'w' or key == 'a' or key == 's' or key == 'd' or
   key == 'up' or key == 'left' or key == 'down' or key == 'right' then
      psycho.updateSpeed(self)
elseif key == 'lshift' then
    self.focused = false
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

    --Create psycho
    p = Psy(x, y)
    p:addElement(DRAW_TABLE.L4)

    --Create aim
    Aim.create("psycho_aim")

    --Make psycho first color to be the UI color (to blend with title)
    p.ui_color = true
    --Return to normal after 2.5 seconds
    handle = COLOR_TIMER:after(2.5,
        function()
            p.ui_color = false
            Color.copy(p.color, UI_COLOR.color)
            p:startColorLoop()
        end
    )
    table.insert(p.handles, handle)

    --Enable shooting after 2.5 seconds
    LEVEL_TIMER:after(2.5,
        function()
            p.shootLocked = false
        end
    )

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

--Checks if psycho has leaved (even if partially) the game screen and returns correct position
function isOutside(o)
    local x, y


    x, y = o.pos.x, o.pos.y

    --X position
    if     o.pos.x - o.r <= 0 then
        x = o.r
    elseif o.pos.x + o.r >= ORIGINAL_WINDOW_WIDTH then
        x = ORIGINAL_WINDOW_WIDTH - o.r
    end
    --Y position
    if o.pos.y - o.r <= 0 then
        y = o.r
    elseif o.pos.y + o.r >= ORIGINAL_WINDOW_HEIGHT then
        y = ORIGINAL_WINDOW_HEIGHT - o.r
    end

    return x,y
end

--return function
return psycho
