require "classes.primitive"
local LM = require "level_manager"
local Aim = require "classes.psycho_aim"
local Bullet = require "classes.bullet"
local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local Ultra = require "classes.ultrablast"
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
        self.alpha = 255

        self.speedv = 265 --Speed value
        self.speed_multiplier = 0 --Multiplier for speed
        self.speed = Vector(0,0) --Speed vector

        self.focused = false --If psycho is focused or not
        self.speedvm_focus = .5 -- Speed value multiplier when focused

        self.shoot_tick = 0 --Bullet "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = .155 --How fast to shoot bullets

        self.circle_fx_tick = 0 --Circle Effect "cooldown" timer
        self.circle_fx_fps = .2 --How fast to create the circle effect
        self.circle_fx_alpha_min = 50 --Min value for fx alpha
        self.circle_fx_alpha_max = 100 --Max value for fx alpha
        self.circle_fx_alpha_speed = 10 --Spped to increase circle fx alpha
        self.circle_fx_alpha = self.circle_fx_alpha_min --CUrrent alpha value for circle fx

        self.score = 0 --Score psycho has
        self.life_score = 0 --How much score psycho has accumulated to win a life
        self.life_score_target = 5000 --How many points psycho must win to get a life

        self.can_ultra = true --If psycho can use ultrablast (for tutorial)
        self.can_move = true --If psycho can move (for tutorial)
        self.can_focus = true --If psycho can focus (for tutorial)
        self.can_shoot = true --If psycho can shoot
        self.can_charge = true --If psycho can charge his ultrablast bar

        self.default_lives = 10 --How many lives psycho by default has
        self.lives = self.default_lives --How many lives psycho has

        self.default_ultrablast_number = 1 --How many ultrablasts psycho by default has in every life
        self.ultrablast_counter = self.default_ultrablast_number--How many ultrablasts psycho has
        self.default_ultrablast_power = 50 --Ultrablast power when using right mouse button
        --Variables used to control repetition of same input triggering several ultrablasts
        self.ultra1_active = false
        self.ultra2_active = false

        self.invincible = false --If psycho can't collide with enemies
        self.invincible_handles = {} --Handles for psycho invencibility timers

        self.tp = "psycho" --Type of this class

    end
}

--CLASS FUNCTIONS--

function Psy:draw()
    local p, size

    p = self

    local color = Color.black()

    --Get correct color
    if not p.ui_color then
        Color.copy(color, p.color)
    else
        Color.copy(color, UI_COLOR.color)
    end
    color.a = p.alpha
    Color.set(color)

    --Draw all psychos from all windows
    for idx, win in ipairs(GAME_WINDOWS) do
        if win.active then
            --Apply effect for invisible radius and draw the circle
            if p.invisible_circle_radius_ratio > 0 then
                Draw_Smooth_Ring(p.pos.x + win.x, p.pos.y + win.y, p.r, p.invisible_circle_radius_ratio*p.r)
            else
                Draw_Smooth_Circle(p.pos.x + win.x, p.pos.y + win.y, p.r)
            end
        end
    end

end

function Psy:shoot(x,y)
    local p, bullet, dir, c, color_table, w, h, scale
    p = self
    if not p.can_shoot then return end


    SFX.psychoball_shot:play()

    c = HSL(Hsl.hsl(p.color)) --Color of bullet is current psycho color
    color_table = {
        HSL(Hsl.stdv(51,100,50)),
        HSL(Hsl.stdv(355,89,48)),
        HSL(Hsl.stdv(95, 89,42)),
        HSL(Hsl.stdv(207,81,49)),
        HSL(Hsl.stdv(271,75,52))
    }
    --Find out which window the position is, to get correct direction
    local game_win = WINM.winAtPoint(x,y)
    if game_win then
        dir = Vector(x-(p.pos.x+game_win.x), y-(p.pos.y+game_win.y))
    else
        dir = Vector(x-p.pos.x, y-p.pos.y)
    end
    dir = dir:normalized()

    --Create bullets for all psychos from all windows
    for idx, win in ipairs(GAME_WINDOWS) do
        if win.active then
            Bullet.create(p.pos.x+win.x, p.pos.y+win.y, dir, c, color_table, "player_bullet")
        end
        --On godmode, shoot 10 bullets instead of 1
        if GODMODE then
            for j = 1,9 do
                Bullet.create(p.pos.x+win.x, p.pos.y+win.y, dir, c, color_table, "player_bullet")
            end
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

    FX.shake(.3,2)

    --Signal ultrablast counter that psycho used ultrablast
    local counter = Util.findId("ultrablast_counter")
    if counter then counter:psychoShot(true) end

end

function Psy:update(dt)
    local p

    p = self

    --Check for joystick input
    if USING_JOYSTICK and CURRENT_JOYSTICK then
        --Enter or leave focus mode (left shoulder button by default)
        if Controls.isActive(CURRENT_JOYSTICK,"focus") then
            self.focused = true
        else
            self.focused = false
        end

        --Activate ultrablast (right or left trigger button by default)
        --Checks for repetition of command press
        if Controls.isActive(CURRENT_JOYSTICK,"ultrablast1") then
            if not p.ultra1_active then
                self:ultrablast(self.default_ultrablast_power)
            end
            p.ultra1_active = true
        else
            p.ultra1_active = false
        end
        if Controls.isActive(CURRENT_JOYSTICK,"ultrablast2") then
            if not p.ultra2_active then
                self:ultrablast(self.default_ultrablast_power)
            end
            p.ultra2_active = true
        else
            p.ultra2_active = false
        end
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
    p.shoot_tick = math.max(p.shoot_tick - dt, 0)
    if not USING_JOYSTICK then
      if love.mouse.isDown(1) or
         love.keyboard.isDown('z')
      then
        if p.shoot_tick <= 0 then
            p.shoot_tick = p.shoot_tick + p.shoot_fps
            local x, y = love.mouse.getPosition()
            --Fix mouse position click to respective distance
            p:shoot(x, y)
        end
      end
    elseif CURRENT_JOYSTICK and
           (JOYSTICK_AUTO_SHOOT or Controls.isActive(CURRENT_JOYSTICK, "shoot")) and
           (Controls.isActive(CURRENT_JOYSTICK, "raxis_horizontal") or Controls.isActive(CURRENT_JOYSTICK, "raxis_vertical"))
    then
      if p.shoot_tick <= 0 then
          p.shoot_tick = p.shoot_tick + p.shoot_fps
          local v = Vector(Controls.getJoystickAxisValues(CURRENT_JOYSTICK, "raxis_horizontal", "raxis_vertical")):normalized()
          if v.x ~= 0 or v.y ~= 0 then --Check for deadzone case
            local x, y = p.pos.x + v.x, p.pos.y + v.y
            p:shoot(x, y)
          end
      end
    end

    --Leave before moving psycho or creating circle effects
    if not p.can_move then return end

    psycho.updateSpeed(p)

    --Create circle effect
    p.circle_fx_tick = p.circle_fx_tick - dt
    if p.circle_fx_tick <= 0 then
        p.circle_fx_tick = p.circle_fx_tick + p.circle_fx_fps
        C_FX.create(p.pos, p.circle_fx_alpha*p.alpha/255)
        --Update alpha for next circle
        p.circle_fx_alpha = math.min(p.circle_fx_alpha + dt*p.circle_fx_alpha_speed, p.circle_fx_alpha_max)
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
    for i, win in ipairs(GAME_WINDOWS) do
        if win.active then
            p.pos.x, p.pos.y = isOutside(p, win)
        end
    end
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
    p.circle_fx_alpha = p.circle_fx_alpha_min --Reset alpha for effects

    if not p.death and p.lives <= 0 then
        FX.explosion(p.pos.x, p.pos.y, p.r, p.color, 100, 450, 250, 4)
        p.death = true
        Util.findId("psycho_aim").death = true --Delete aim
        Audio.tweenCurrentBGMPitch(.6,3)
        SWITCH =  "GAMEOVER"
        PSYCHO_SCORE = p.score
    else
        --Reset ultrablast counter, and give ultrablasts if psycho has fewer than default
        local counter = Util.findId("ultrablast_counter")
        if counter then
            if p.ultrablast_counter < p.default_ultrablast_number then
                p.ultrablast_counter = p.default_ultrablast_number
                counter:reset(true)
            else
                counter:reset(false)
            end
        end
        FX.shake(.25,1.5)
        FX.psychoExplosion(p)
    end
end

function Psy:keypressed(key)
    local p

    p = self --Psycho

    if key == 'lshift' and p.can_focus then
        p.focused = true
    elseif key == 'space' and p.can_ultra then
        p:ultrablast(p.default_ultrablast_power)
    end

end

function Psy:keyreleased(key)
    if key == 'lshift' then
        self.focused = false
    end
end

function Psy:joystickaxis(joystick, axis, value)

end

function Psy:joystickpressed(joystick, button)

end

function Psy:joystickreleased(joystick, button)

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

    x, y = x or WINDOW_WIDTH/2, y or  WINDOW_HEIGHT/2

    --Create psycho
    p = Psy(x, y)
    p:addElement(DRAW_TABLE.L4)

    --Create aim
    p.aim = Aim.create("psycho_aim", is_tutorial)

    --Disable action until psycho enter animation ends
    p.can_ultra = false
    p.can_shoot = false
    p.can_charge = false

    --Make psycho first color to be the UI color (to blend with title) and fade-in with title
    --When title is leaving, make psycho normal and able to shoot
    p.ui_color = true
    p.alpha = 0
    p.level_handles["init-wait"] = LEVEL_TIMER:after(1.5,
        function()
            p.level_handles["fade-in"] = LEVEL_TIMER:tween(1, p, {alpha = 255})
            p.level_handles["turn-normal"] = LEVEL_TIMER:after(4,
              function()

                if not is_tutorial then
                  p.can_ultra = true
                  p.can_shoot = true
                  p.can_charge = true
                end

                p.ui_color = false
                Color.copy(p.color, UI_COLOR.color)
                p:startColorLoop()
              end
            )
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
    if not USING_JOYSTICK then
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
    else
      if CURRENT_JOYSTICK then
        --Prioritize hat (if exists), if not use axis value
        p.speed = Controls.getHatDirection(CURRENT_JOYSTICK:getHat(1))
        if p.speed.x == 0 and p.speed.y == 0 then --Hat == 'c'
          p.speed.x, p.speed.y = Controls.getJoystickAxisValues(CURRENT_JOYSTICK, "laxis_horizontal", "laxis_vertical")
        end
      end
    end

    p.speed = p.speed:normalized() * sp

end

--Checks if psycho has leaved (even if partially) the given game screen and returns
--needed correction for each coordinate
function isOutside(o, win)
    local x, y

    x, y = o.pos.x+win.x, o.pos.y+win.y

    --X position
    if  x - o.r <= win.x then
        x = win.x + o.r
    elseif x + o.r >= win.x + win.w then
        x = win.x + win.w - o.r
    end
    --Y position
    if y - o.r <= win.y then
        y = win.y + o.r
    elseif y + o.r >= win.y + win.h then
        y = win.y + win.h - o.r
    end

    return x-win.x,y-win.y
end

--return function
return psycho
