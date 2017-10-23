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
        self.invisible_circle_radius_ratio = 0 --Ratio of radius of invisibility inside psycho (for invunerability moments)
        self.invisible_circle_radius_max = .75
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
        self.life_score_target = 6000 --How many points psycho must win to get a life

        self.can_ultra = true --If psycho can use ultrablast (for tutorial)
        self.can_move = true --If psycho can move (for tutorial)
        self.can_focus = true --If psycho can focus (for tutorial)
        self.can_shoot = true --If psycho can shoot

        self.default_lives = 10 --How many lives psycho by default has
        self.lives = self.default_lives --How many lives psycho has

        self.default_ultrablast_number = 1 --How many ultrablasts psycho by default has in every life
        self.ultrablast_counter = self.default_ultrablast_number--How many ultrablasts psycho has
        self.default_ultrablast_power = 50 --Ultrablast power when using right mouse button

        self.invincible = false --If psycho can't collide with enemies
        self.invincible_handles = {} --Handles for psycho invencibility timers

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

    --Apply effect for invisible radius
    if p.invisible_circle_radius_ratio > 0 then
        Draw_Smooth_Ring(p.pos.x, p.pos.y, p.r, p.invisible_circle_radius_ratio*p.r)
    else
        Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r)
    end

end

function Psy:shoot(x,y)
    local p, bullet, dir, c, color_table, w, h, scale
    p = self
    if not p.can_shoot then return end


    SFX.psychoball_shot:play()

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

    --Signal ultrablast counter that psycho is shooting
    local counter = Util.findId("ultrablast_counter")
    if counter then counter:psychoShot() end

end

function Psy:ultrablast(power)
    local p

    p = self

    if p.ultrablast_counter <= 0 or not p.can_ultra then return end

    p:startInvincible(1)

    --Update ultrablast counter
    LM.giveUltrablast(-1)

    Ultra.create(p.pos.x, p.pos.y, p.color, power)

end

function Psy:update(dt)
    local p

    p = self

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
    if not p.can_move then return end

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

function Psy:destroy()
    for _,h in pairs(self.invincible_handles) do
        FX_TIMER:cancel(h) --Stops any timers this object has
    end
    ELEMENT.destroy(self)
end

function Psy:kill()

    if GODMODE then return end --GODMODE cheat

    local p = self

    if p.lives <= 0 then return end

    SFX.psychoball_dies:play()

    LM.giveLives(-1) --Update life

    if not p.death and p.lives <= 0 then
        FX.explosion(p.pos.x, p.pos.y, p.r, p.color, 100, 450, 250, 4)
        p.death = true
        Util.findId("psycho_aim").death = true --Delete aim
        Audio.tweenCurrentBGMPitch(.6,3)
        SWITCH =  "GAMEOVER"
        PSYCHO_SCORE = p.score
    else
        --Reset ultrablast counter if its not the default
        p.ultrablast_counter = p.default_ultrablast_number
        local counter = Util.findId("ultrablast_counter")
        if counter then counter:reset() end
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
    elseif key == 'lshift' and p.can_focus then
        p.focused = true
    elseif key == 'space' then
        if p.can_ultra then
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
function Psy:startInvincible(duration)
    local d, count, p

    p = self

    d = duration or 2 --Time psycho is invincible
    d2 = 2*d/3 --Time before outer circle grows

    p.invincible = true
    p.invisible_circle_radius_ratio = p.invisible_circle_radius_max

    --Tween psycho ring effect
    if p.invincible_handles["ring_effect"] then
        FX_TIMER:cancel(p.invincible_handles["ring_effect"])
    end
    p.invincible_handles["ring_effect"] = FX_TIMER:after(d2,
        function()

            p.invincible_handles["ring_effect"] = FX_TIMER:tween(d-d2, p, {invisible_circle_radius_ratio = 0}, 'in-linear')

        end)

    --Makes psycho visible and vunerable again (+.2 for game-feel)
    if p.invincible_handles["end_effect"] then
        FX_TIMER:cancel(p.invincible_handles["end_effect"])
    end
    p.invincible_handles["end_effect"] = FX_TIMER:after(d + .2,
        function()
            --local p = psycho.get()

            p.invisible = false
            p.invincible = false

        end)
end

--UTILITY FUNCTIONS--

function psycho.create(x, y, is_tutorial)
    local p, handle

    x, y = x or ORIGINAL_WINDOW_WIDTH/2, y or  ORIGINAL_WINDOW_HEIGHT/2

    --Create psycho
    p = Psy(x, y)
    p:addElement(DRAW_TABLE.L4)

    --Create aim
    p.aim = Aim.create("psycho_aim", is_tutorial)

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

    p.can_ultra = false
    p.can_shoot = false

    --Enable shooting after 2.5 seconds
    if not is_tutorial then
      LEVEL_TIMER:after(2.5,
          function()
              p.can_ultra = true
              p.can_shoot = true
          end
      )
    end

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
    if     o.pos.x - o.r <= TOP_LEFT_CORNER.x then
        x = o.r
    elseif o.pos.x + o.r >= BOTTOM_RIGHT_CORNER.x then
        x = BOTTOM_RIGHT_CORNER.x - o.r
    end
    --Y position
    if o.pos.y - o.r <= TOP_LEFT_CORNER.y then
        y = o.r
    elseif o.pos.y + o.r >= BOTTOM_RIGHT_CORNER.y then
        y = BOTTOM_RIGHT_CORNER.y - o.r
    end

    return x,y
end

--return function
return psycho
