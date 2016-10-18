require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local F = require "formation"
local Audio = require "audio"
local Indicator = require "classes.indicator"
local LM = require "level_manager"

local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

--BOSS #1 CLASS--
--[[GORGAMAX]]

--Behaviours--
local Stage_1_and_2, Stage_3, Stage_4

local boss = {}

Boss_1 = Class{
    __includes = {CIRC},
    init = function(self)
        local r, saturation, lightness, color

        r = 120 --Radius of enemy
        self.initial_saturation = 255 --Inicial color saturation in %
        self.bottom_lightness = 100 --Bottom color lightness in %
        self.upper_lightness = 130 --Upper color lightness in %
        self.color_stage_hue = {}
        self.color_stage_hue[1] = 77.88 --Color hue for stage 1 (green)
        self.color_stage_hue[2] = 42.48  --Color hue for stage 2 (yellow)
        self.color_stage_hue[3] = 152.22 --Color hue for stage 3 (blue)
        self.color_stage_hue[4] = 188.32 --Color hue for stage 4 (purple)
        self.color_stage_hue[5] = 228.79 --Color hue for stage 5 (pink)
        self.color_onhit_hue = 254 --Color hue for when boss is hit (red)
        self.color_onhit_saturation = 235 --Color saturation for when boss is hit
        self.color_stage_current_saturation = self.initial_saturation --Current stage color saturation this boss has
        self.color_dying_target_saturation = 180 --Target saturation the boss is reaching whenever he gets hit

        color = HSL(self.color_stage_hue[1], self.initial_saturation, self.bottom_lightness) --Color of boss

        self.color_pulse_duration = 1 --Duration between color saturation transitions

        CIRC.init(self, ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2, r, color, nil, "fill") --Set atributes
        ELEMENT.setSubTp(self, "boss")

        --Boss speed value
        self.speedv = 350 --Speed value

        self.life = 50 --How many hits this boss can take before changing state (this value is for stage 1 and 2)
        self.damage_taken = 0 --How many hits this boss has taken
        self.invincible = true --If boss can get hit
        self.static = true --If boss can move
        self.stage = 1 --Stage this boss is
        self.target = nil --Index of target position (stage 1 and 2)
        self.newTarget = true --If boss needs a new target (stage 1 and 2)

        self.getDir = nil --If boss should pick a direction to shoot (stage 3)
        self.dir = nil --Direction to shoot the enemies (stage 3)
        self.enemy_2_shoot = nil --What enemy to shoot (stage 3)
        self.getIndicator = nil

        self.isShooting = false --If boss is shooting player
        self.shoot_tick = 0 --Enemy shooter "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = .5 --How fast to shoot enemies

        self.spawn_tick = 0 --Enemy spawn "cooldown" timer (for spawning repeatedly)
        self.spawn_fps = .2 --How fast to spawn enemies

        self.validPositions = {}
        self.validPositions[1] = Vector(self.r + 5, self.r + 5) --Top Left
        self.validPositions[2] = Vector(ORIGINAL_WINDOW_WIDTH - self.r - 5, self.r + 5) --Top Right
        self.validPositions[3] = Vector(ORIGINAL_WINDOW_WIDTH - self.r - 5, ORIGINAL_WINDOW_HEIGHT - self.r  - 5) --Bottom Right
        self.validPositions[4] = Vector(self.r + 5, ORIGINAL_WINDOW_HEIGHT - self.r - 5) --Bottom Left

        self.stomp = love.audio.newSource("assets/sfx/boss1/stomp.wav")
        self.big_thump = love.audio.newSource("assets/sfx/boss1/big_thump.wav")
        self.long_roar =  love.audio.newSource("assets/sfx/boss1/long_roar.wav")
        self.hurt_roar =  love.audio.newSource("assets/sfx/boss1/hurt_roar.wav")
        self.angry_hurt_roar =  love.audio.newSource("assets/sfx/boss1/angry_hurt_roar.wav")
        self.angry_af_roar =  love.audio.newSource("assets/sfx/boss1/angry_af_roar.wav")

        self.behaviour = Stage_1_and_2 --What behaviour this boss is following
        self.tp = "boss_one" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Boss_1:kill()
    local b

    b = self

    if b.death then return end
    b.death = true

    FX.explosion(self.pos.x, self.pos.y, 500, self.color, 600, 200, 200, 4, true)

end

--Update this boss
function Boss_1:update(dt)
    local b

    b = self
    --Boss won't move if static
    if b.static then return end

    if b.behaviour then
        b:behaviour(dt) --Make boss current stage behaviour
    end

end


--Called when boss gets hit with psycho's bullet
function Boss_1:getHit()
    local b

    b = self

    if b.stage >= 5 then return end

    b.damage_taken = b.damage_taken + 1
    b.bottom_lightness = b.bottom_lightness - .2
    b.upper_lightness = b.upper_lightness - .2
    b:getHitAnimation()

    if b.damage_taken >= b.life then
        b.stage = b.stage + 1

        b:changeStage() --Change boss stage

    end

end

--Color animation when boss gets hit
function Boss_1:getHitAnimation()
    local b, diff

    b = self
    --Remove previous transition
    if b.level_handles["gethithue"] then
        LEVEL_TIMER:cancel(b.level_handles["gethithue"])
    end
    if b.level_handles["gethitsaturation"] then
        LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"])
    end
    if b.level_handles["gethittimer"] then
        LEVEL_TIMER:cancel(b.level_handles["gethittimer"])
    end

    --Make boss red when hit
    b.color.h = b.color_onhit_hue
    b.color.s = b.color_onhit_saturation

    --Update boss stage current saturation
    diff = b.damage_taken/b.life * (b.color_dying_target_saturation - b.initial_saturation) --Calculate how much of the difference between target saturation and initial stage color saturation the boss has reached
    b.color_stage_current_saturation = b.initial_saturation + diff --Make current saturation the proper saturation

    --Stay red for .05 seconds
    b.level_handles["gethittimer"] = LEVEL_TIMER:after(.05,
        function()
            --Transition current onhit hue to boss stage current hue when saturation is 0
            b.level_handles["gethithue"] = LEVEL_TIMER:after(.25,
                function()
                    b.color.h = b.color_stage_hue[b.stage]
                end)
            --Drops saturation, then go to stage current saturation
            b.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, b.color, {s = 0}, 'in-linear',
               function()
                   b.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, b.color, {s = b.color_stage_current_saturation}, 'in-linear')
                end
            )
        end
    )

end

function Boss_1:getTargetPosition()
    local position, b

    b = self

    position = love.math.random(4) --Get random position index
    if not b.target then return position end --If target == nil just go to any valid position
    --Don't go to opposing position on screen
    if b.stage == 1 then
        while(position == b.target or  position == (b.target + 2 - 1 )%4 + 1) do
            position = love.math.random(4) --Get random position index
        end
    elseif b.stage == 2 then
        --Just don't go to same position on screen
        while(position == b.target) do
            position = love.math.random(4) --Get random position index
        end
    end

    return position
end

function Boss_1:changeStage()
    local b

    b = self

    if b.stage == 2 then
        --Reset stats
        b.bottom_lightness = 100 --Reset bottom color lightness (in %)
        b.upper_lightness = 130 --Reset upper color lightness (in %)
        b:colorLightnessLoop() --Start transition all over again
        b.color_stage_current_saturation = b.initial_saturation
        b.speedv = 450 --Make boss faster
        b.damage_taken = 0 --Reset boss life
        b.invincible = true --Can't take damage
        b.isShooting = false --Stop shooting
        b.shoot_tick = 0
        b.shoot_fps = .45
        LM.giveScore(1000, "boss hurted")

        --Stop moving
        b.static = true
        if b.level_handles["move"] then
            LEVEL_TIMER:cancel(b.level_handles["move"])
        end

        b.hurt_roar:play()
        SFX["boss_roar"] = b.hurt_roar
        FX.shake(2, 3) --Shake screen
        F.circle{x_center = b.pos.x, y_center = b.pos.y, radius = 40, speed_m = 1.1, ind_mode = false, enemy = {SB, DB}, number = 20, score_mul = 0}

        --Start stage 2
        b.level_handles["begin_stage"] = LEVEL_TIMER:after(2.1,
            function()

                 b.static, b.invincible, b.isShooting = false, false, true --Make boss walk, be able to die and shoot

                 --Continue his movement
                 b.level_handles["move"] = LEVEL_TIMER:tween(timeToReach(b), b.pos, {x = b.validPositions[b.target].x, y = b.validPositions[b.target].y}, 'in-linear',
                     function()
                         b.newTarget = true
                     end
                 )
             end
        )

    elseif b.stage == 3 then
        --Reset stats
        b.bottom_lightness = 100 --Reset bottom color lightness (in %)
        b.upper_lightness = 130 --Reset upper color lightness (in %)
        b:colorLightnessLoop() --Start transition all over again
        b.color_stage_current_saturation = b.initial_saturation
        b.damage_taken = 0 --Reset boss life
        b.invincible = true --Can't take damage
        b.behaviour = Stage_3
        b.life = 175 --Increase boss max life
        --Stop moving
        b.static = true
        b.isShooting = false
        b.shoot_tick = 0
        LM.giveScore(1000, "boss hurted")

        if b.level_handles["move"] then
            LEVEL_TIMER:cancel(b.level_handles["move"])
        end

        b.angry_hurt_roar:play()
        SFX["boss_roar"] = b.angry_hurt_roar
        FX.shake(2.5, 4) --Shake screen
        F.circle{x_center = b.pos.x, y_center = b.pos.y, radius = 40, speed_m = 1.1, ind_mode = false, enemy = {DB}, number = 20, score_mul = 0}


        --Start stage 3
        b.level_handles["begin_stage"] = LEVEL_TIMER:after(2.6,
            function()

                 --Move to the center
                 b.level_handles["move"] = LEVEL_TIMER:tween((b.pos:dist(Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2))) / b.speedv, b.pos, {x = ORIGINAL_WINDOW_WIDTH/2, y = ORIGINAL_WINDOW_HEIGHT/2}, 'in-linear',
                     function()
                         b.static, b.invincible, b.getIndicator = false, false, true --Make boss walk, be able to die and get a direction for spin attack
                     end
                 )
             end
        )
    elseif b.stage == 4 then
        --Reset stats
        b.bottom_lightness = 100 --Reset bottom color lightness (in %)
        b.upper_lightness = 130 --Reset upper color lightness (in %)
        b:colorLightnessLoop() --Start transition all over again
        b.color_stage_current_saturation = b.initial_saturation
        b.damage_taken = 0 --Reset boss life
        b.invincible = true --Can't take damage
        b.behaviour = Stage_4
        b.life = 18 --Increase boss max life
        LM.giveScore(1000, "boss killed")


        --Stop moving
        b.static = true
        if b.indicator then b.indicator.death = true end --Remove pending indicator

        b.angry_af_roar:play()
        SFX["boss_roar"] = b.angry_af_roar
        FX.shake(3, 4) --Shake screen
        F.circle{x_center = b.pos.x, y_center = b.pos.y, radius = 40, speed_m = 1.1, ind_mode = false, enemy = {DB}, number = 20, score_mul = 0}


        --Start stage 4
        b.level_handles["begin_stage"] = LEVEL_TIMER:after(3.1,
            function()

                 --Move to the center
                 b.level_handles["move"] = LEVEL_TIMER:after(1,
                     function()
                         b.static = false --Make boss start to shrink
                     end
                 )
             end
        )
    elseif b.stage == 5 then
        --Reset stats
        b.bottom_lightness = 100 --Reset bottom color lightness (in %)
        b.upper_lightness = 130 --Reset upper color lightness (in %)
        b:colorLightnessLoop() --Start transition all over again
        b.color_stage_current_saturation = b.initial_saturation
        b.damage_taken = 0 --Reset boss life
        b.invincible = true --Can't take damage
        b.behaviour = nil
        b.life = 10
        LM.giveScore(4000, "boss killed for real this time")

        --Remove growing tween
        if b.level_handles["grow_quick"] then
            LEVEL_TIMER:cancel(b.level_handles["grow_quick"])
        end

        --Shrinks then dies
        b.level_handles["die"] = LEVEL_TIMER:tween(1.5, b, {r = 1}, 'in-back', function() b:kill() end)

    end

end

--UTILITY FUNCTIONS--

function boss.create()
    local b, shadow, volume, bgm

    b = Boss_1()

    --Create shadow of boss
    shadow = CIRC(ORIGINAL_WINDOW_WIDTH/2, -1200, 800, HSL(0,0,8,200))
    shadow:addElement(DRAW_TABLE.BOSS, "boss_effect")

    --Lower music volume
    bgm = SOUNDTRACK["next"] or SOUNDTRACK["current"]
    Audio.fade_out(bgm, bgm:getVolume(), bgm:getVolume()/10, .8)

    --Shake screen
    volume = .2
    shadow.level_handles["shake_screen"] = LEVEL_TIMER:every(1.5,
        function()
            FX.shake(.5, 2)
            b.stomp:setVolume(volume)
            volume = volume + .1
            b.stomp:play()
        end,
        6
    )

    --Moves shadow
    shadow.level_handles["create_boss"] = LEVEL_TIMER:tween(9, shadow.pos, {y = ORIGINAL_WINDOW_HEIGHT/2}, 'in-linear',
        function()
            --Shrinks shadow
            shadow.level_handles["create_boss"] = LEVEL_TIMER:tween(1, shadow, {r = 120}, 'in-cubic' ,
                function()
                    shadow.death = true --Remove shadow

                    b:addElement(DRAW_TABLE.BOSS, "bosses") --make boss appear
                    b:colorLightnessLoop() --Start color transition

                    LM.boss_title("GORGAMAX") --Boss title

                    --Increase music volume
                    bgm = SOUNDTRACK["next"] or SOUNDTRACK["current"]
                    Audio.fade_in(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL, 2)

                    FX.shake(.5, 5) --Shake screen
                    b.big_thump:play()

                    --SHOW BOSS NAME

                    --Screen shake and roar
                    b.level_handles["begin_stage"] = LEVEL_TIMER:after(2,
                        function()

                            --ROAR AND SHAKE
                            b.long_roar:play()
                            SFX["boss_roar"] = b.long_roar
                            FX.shake(2, 3) --Shake screen
                            F.circle{x_center = b.pos.x, y_center = b.pos.y, radius = 40, speed_m = 1.1, ind_mode = false, enemy = {SB}, number = 20, score_mul = 0}

                            --Start stage 1
                            b.level_handles["begin_stage"] = LEVEL_TIMER:after(2.2,
                                function()
                                     b.static ,b.invincible, b.isShooting = false, false, true
                                 end
                            )
                        end
                    )
                end
            )
        end
    )


    return b
end

--Return this boss radius
function boss.radius()
    return 120
end

--LOCAL FUNCTION--

--Return the time needed for boss to reach target position based on his current position and speed
function timeToReach(b)
    return (b.pos:dist(b.validPositions[b.target])) / b.speedv
end

--STAGES--

--Run around the corners of the screen shooting at psycho. For stage 2, it can go to opposing corners and shoots faster
Stage_1_and_2 = function(b, dt)
    local e, mul

    --Shoot enemies with boss fps
    if b.isShooting then
        b.shoot_tick = b.shoot_tick + dt
        if b.shoot_tick >= b.shoot_fps then
            b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

            --Shoot enemies

            --Choose to shoot simple ball(66%) or double ball(34%)
            if b.stage == 1 then
                if love.math.random() > .66 then
                    e = DB
                    mul = 2
                else
                    e = SB
                    mul = 2.6
                end
                F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, speed_m = mul, score_mul = 0}

            --Choose to shoot simple ball(40%) or double ball(60%)
            else
                if love.math.random() > .4 then
                    e = DB
                    mul = 2
                else
                    e = SB
                    mul = 2.7
                end
                F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, speed_m = mul, score_mul = 0}
            end

        end
    end

    if b.newTarget then
        --Get new target for boss
        b.target = b:getTargetPosition()
        b.newTarget = false
        --Transition to new position
        b.level_handles["move"] = LEVEL_TIMER:tween(timeToReach(b), b.pos, {x = b.validPositions[b.target].x, y = b.validPositions[b.target].y}, 'in-linear',
            function()
                b.newTarget = true
            end
        )
    end
end

--Stays at the center of the screen, and shoots in circle motion to the psycho, while enemies spawn at corners
Stage_3 = function(b, dt)
    local p, d, clockwise, turn_angle, turn_ratio, e, indicator_duration

    d = 4.5 --Duration of spinning attack
    cooldown = .5 --Duration between attacks
    indicator_duration = 3 --Duration for indicators

    --Spawn enemies at corners
    b.spawn_tick = b.spawn_tick + dt
    if b.spawn_tick >= b.spawn_fps then
        b.spawn_tick = b.spawn_tick - b.spawn_fps
        F.single{x = -25, y = 25, dx = 1, enemy = DB, speed_m = 2, ind_mode = false, score_mul = 0} --Top left corner, shooting right
        F.single{x = ORIGINAL_WINDOW_WIDTH - 25, y = - 25, dy = 1, enemy = DB, speed_m = 2, ind_mode = false, score_mul = 0} --Top right corner, shooting down
        F.single{x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT - 25, dx = -1, enemy = DB, speed_m = 2, ind_mode = false, score_mul = 0} --Bottom right corner, shooting left
        F.single{x = 25, y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, enemy = DB, speed_m = 2, ind_mode = false, score_mul = 0} --Bottom left corner, shooting up
    end

    --Shoot enemies
    if b.isShooting then
        b.shoot_tick = b.shoot_tick + dt
        if b.shoot_tick >= b.shoot_fps then
            b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick
            if b.enemy_2_shoot == SB then
                e = (love.math.random()>.1 and SB or DB) --Choose to shoot SB(90%) or DB(10%)
            else
                e = DB
            end
            --Shoot enemies
            F.single{x = b.pos.x, y = b.pos.y, dx = b.dir.x, dy = b.dir.y, ind_mode = false, enemy = e, speed_m = 2, score_mul = 0}

        end
    end

    if b.getIndicator then
        b.getIndicator = false
        b.enemy_2_shoot = (love.math.random()>.5 and SB or DB) --Choose to rotate clockwise or not
        b.indicator = Indicator.create_rotating(35, b.enemy_2_shoot.indColor(), indicator_duration, b.r + 30, Vector(b.pos.x, b.pos.y))
        b.level_handles["get_direction"] = LEVEL_TIMER:after(indicator_duration, function() b.getDir = true end)
    end

    --Get direction to shoot enemies
    if b.getDir then
        b.getDir = false
        b.isShooting = true
        clockwise = (love.math.random()>.5 and -1 or 1) --Choose to rotate clockwise or not

        if b.enemy_2_shoot == SB then
            turn_angle = 18
            turn_ratio = .04
            b.shoot_fps = .04
        else
            turn_angle = 40
            turn_ratio = .07
            b.shoot_fps = .07
        end

        p = Util.findId("psycho")
        if p then
            b.dir = Vector(p.pos.x - b.pos.x, p.pos.y - b.pos.y):normalized() --At first, point at psycho
        else
            b.dir = Vector(1,0)
        end
        --Rotates the direction
        b.level_handles["spin"] = LEVEL_TIMER:every(turn_ratio,
            function()
                --2% chance of inverting clock direction if on SB spin attack
                if b.enemy_2_shoot == SB and love.math.random() >.98 then
                    clockwise =  -clockwise
                --Directions tries to follow psycho using cross product on vectors
                elseif b.enemy_2_shoot == DB then
                    p = Util.findId("psycho")
                    if p and b.dir:cross(Vector(p.pos.x - b.pos.x, p.pos.y - b.pos.y)) > 0 then
                        clockwise = 1
                    else
                        clockwise = -1
                    end
                end
                b.dir = b.dir:rotated(clockwise*math.pi/turn_angle)
            end,
            d/turn_ratio
        )
        b.level_handles["stop_spinning_attack"] = LEVEL_TIMER:after(d, function() b.isShooting = false end)
        b.level_handles["loop_spinning_attack"] = LEVEL_TIMER:after(d + cooldown, function() b.getIndicator = true end)
    end


end

--Shrinks, then gorws quickly trying to kill psycho one last time
Stage_4 = function(b, dt)

    --Shrink
    if not b.static and not b.level_handles["shrink"] then
        b.level_handles["shrink"] = LEVEL_TIMER:tween(6, b, {r = 25}, 'in-linear',
            --Grow quick
            function()
                b.invincible = false
                b.level_handles["grow_quick"] = LEVEL_TIMER:tween(4, b, {r = 600}, 'in-linear',
                    function()
                        b.stage = 5
                        b:changeStage() --Change boss stage
                    end
                )
            end
        )
    end
end

--Keeps transitioning boss color saturation from values bottom_lightness to upper_lightness, and vice-versa
function Boss_1:colorLightnessLoop()
    local b

    b = self

    --Remove previous timer
    if b.level_handles["lightness"] then
        COLOR_TIMER:cancel(b.level_handles["lightness"])
    end

    --Start saturation transition from bottom_lightness to upper_lightness
    b.level_handles["lightness"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {l = b.upper_lightness}, 'in-linear',
        --After reaching upper_lightness, start lightness transition from upper_lightness to bottom_lightness
        function()
            b.level_handles["lightness"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {l = b.bottom_lightness}, 'in-linear',
                --After reaching bottom_lightness, start eveything again
                function()
                    b:colorLightnessLoop()
                end
            )
        end
    )

end

--return function
return boss
