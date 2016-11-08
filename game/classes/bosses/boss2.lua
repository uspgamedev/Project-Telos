require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local F = require "formation"
local Audio = require "audio"
local Indicator = require "classes.indicator"
local LM = require "level_manager"

--Stencil functions for drawing the boss
local stencil = {

    --Stencil function for top left part of main bosd
    function()
        b = Util.findId("boss_2_main")
        love.graphics.rectangle("fill", b.pos.x - 2*b.r, b.pos.y - 2*b.r, 2*b.r, 2*b.r)
    end,

    --Stencil function for top right part of main_boss
    function()
        b = Util.findId("boss_2_main")
        love.graphics.rectangle("fill", b.pos.x, b.pos.y - 2*b.r, 2*b.r, 2*b.r)
    end,

    --Stencil function for bottom part of main bosd
    function()
        b = Util.findId("boss_2_main")
        love.graphics.rectangle("fill", b.pos.x, b.pos.y, 2*b.r, 2*b.r)
    end,

    --Stencil function for bottom left part of main bosd
    function()
        b = Util.findId("boss_2_main")
        love.graphics.rectangle("fill", b.pos.x - 2*b.r, b.pos.y, 2*b.r, 2*b.r)
    end

}

--BOSS #2 CLASS--
--[[Name of Boss here]]

--Behaviours for main part--
local Stage_1, Stage_2, Stage_3, Stage_4

--Behaviours for turret part--
local Stage_1_t, Stage_2_t, Stage_3_t, Stage_4_t, Increase_Radius

--Utility variables for boss
local Stage_5_fps, Stage_5_bounce
Stage_5_bounce = false

local boss = {}

------------------
--Main Boss Part--
------------------

Boss_2_Main = Class{
    __includes = {CIRC},
    init = function(self)
        local r

        r = 80 --Radius of each boss part
        self.initial_saturation = 255 --Inicial color saturation in %
        self.bottom_lightness = {}
        self.upper_lightness = {}
        self.color_stage_hue = {}
        self.color_stage_hue[1] = 188.32 --Color hue for stage 0 (purple)
        self.color_stage_hue[2] = 188.32 --Color hue for stage 1 (purple)
        self.color_stage_hue[3] = 162.22  --Color hue for stage 2 (deep blue)
        self.color_stage_hue[4] = 142.22 --Color hue for stage 3 (light blue)
        self.color_stage_hue[5] = 132.32 --Color hue for stage 4
        self.color_stage_hue[6] = 112.79 --Color hue for stage 5
        self.color_onhit_hue = 254 --Color hue for when boss is hit (red)
        self.color_onhit_saturation = 255 --Color saturation for when boss is hit
        self.color_stage_current_saturation = {}  --Current stage color saturation this boss has
        self.part_colors = {}
        for i = 1,4 do
            self.color_stage_current_saturation[i] = self.initial_saturation
            self.bottom_lightness[i] = 100 --Bottom color lightness in %
            self.upper_lightness[i] = 130 --Upper color lightness in %
            self.part_colors[i] = HSL(self.color_stage_hue[1], 0, self.bottom_lightness[i])
        end
        self.color_dying_target_saturation = 180 --Target saturation the boss is reaching whenever he gets hit

        self.color_pulse_duration = 1 --Duration between color saturation transitions

        CIRC.init(self, ORIGINAL_WINDOW_WIDTH/2, - 500, r, Color.transp(), nil, "fill") --Set atributes

        self.number_parts = 4 --Number of parts the main boss has

        self.positions = { --Relative position each parts of the poss has
            Vector(-r/2, -r/2), --Top left
            Vector(r/2, -r/2),  --Top right
            Vector(r/2, r/2),   --Bottom right
            Vector(-r/2, r/2),  --Bottom left

        }

        self.turrets = {} --All turrets the main boss has
        self.turret_alive = 4 --Number of turrets alive (for stage 5)

        self.random_enemies = false --If main boss should shoot random enemies (Stage 5)

        --Boss speed value
        self.speedv = 350 --Speed value
        self.target = nil --Target to move

        self.life = {} --How many hits this boss can take before changing state (this value is for stage 1)
        self.damage_taken = {} --How many hits this boss has taken
        for i = 1, 4 do
            self.life[i] = 25 --25 --Inicial life for stage 1
            self.damage_taken[i] = 0
        end

        self.parts_alive = 4 --Number of parts alive

        self.invincible = true --If boss can get hit
        self.static = false --If boss can move
        self.stage = 0 --Stage this boss is

        self.shoot_tick = 2.4 --Enemy shooter "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = 2.4 --How fast to shoot enemies

        self.behaviour = nil --What behaviour this boss is following
        self.tp = "boss_two_main" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Boss_2_Main:draw()
    local p, x, y

    p = self

    for i = 1, p.number_parts do
        Color.set(p.part_colors[i])

        x = p.pos.x - p.r + p.positions[i].x
        y = p.pos.y - p.r + p.positions[i].y

        -- Draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
        if p.number_parts == 4 then
            love.graphics.stencil(stencil[i], "replace", 1)
        end

        -- Only allow rendering on pixels which have a stencil value greater than 0, so will only draw pixels inside the rectangle
        if p.number_parts == 4 then
            love.graphics.setStencilTest("greater", 0)
        end

        --Draw the circle
        love.graphics.setShader(Generic_Smooth_Circle_Shader)
        love.graphics.draw(PIXEL, x, y, 0, 2*p.r)
        love.graphics.setShader()

        --Stop using stencil
        if p.number_parts == 4 then
            love.graphics.setStencilTest()
        end

    end

end

function Boss_2_Main:collides(o)
    local col

    e = self
    for i = 1, e.number_parts do
        dx = e.pos.x + e.positions[i].x - o.pos.x
        dy = e.pos.y + e.positions[i].y - o.pos.y

        --In case of psycho, check collision with his collision radius
        if o.tp == "psycho" then
            dr = e.r + o.collision_r
        else
            dr = e.r + o.r
        end

        if ((dx*dx + dy*dy) < dr*dr) then
            return true, i
        end
    end


    return false

end

function Boss_2_Main:kill()
    local b

    b = self

    if b.death then return end

    b.death = true

    FX.explosion(self.pos.x, self.pos.y, 20, self.color, 600, 600, 100, 4, true)

end

--Update this boss
function Boss_2_Main:update(dt)
    local b

    b = self
    --Boss won't move if static
    if b.static then return end

    if b.behaviour then
        b:behaviour(dt) --Make boss current stage behaviour
    end

end


--Called when a part of main boss gets hit with psycho's bullet
function Boss_2_Main:getHit(id)
    local b

    b = self

    if b.damage_taken[id] >= b.life[id] then return end

    if b.stage >= 7 then return end

    b.damage_taken[id] = b.damage_taken[id] + 1 --Make part take damage
    b.bottom_lightness[id] = b.bottom_lightness[id] - .6 --Make part glow darker
    if b.stage ~= 6 then
        b:getHitAnimation(id)
    else
        b.r = b.r - 2 --For last stage, make boss smaller
    end

    if b.damage_taken[id] >= b.life[id] then
        b.parts_alive = b.parts_alive - 1

        if b.stage ~= 6 then
            b.level_handles["become_grey"..id] = LEVEL_TIMER:tween(1, b.part_colors[id], {s = 0}, 'in-linear')
        end

        if b.parts_alive <= 0 then
            b.stage = b.stage + 1
            b:changeStage() --Change boss stage
        end

    end

end

--Color animation when boss gets hit
function Boss_2_Main:getHitAnimation(id)
    local b, diff, color

    b = self

    color = b.color_stage_hue[b.stage+1]

    --Remove previous transition
    if b.level_handles["gethithue"..id] then
        LEVEL_TIMER:cancel(b.level_handles["gethithue"..id])
    end
    if b.level_handles["gethitsaturation"..id] then
        LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"..id])
    end
    if b.level_handles["gethittimer"..id] then
        LEVEL_TIMER:cancel(b.level_handles["gethittimer"..id])
    end

    --Make boss red when hit
    b.part_colors[id].h = b.color_onhit_hue
    b.part_colors[id].s = b.color_onhit_saturation

    --Update boss stage current saturation
    diff = b.damage_taken[id]/b.life[id] * (b.color_dying_target_saturation - b.initial_saturation) --Calculate how much of the difference between target saturation and initial stage color saturation the boss has reached
    b.color_stage_current_saturation[id] = b.initial_saturation + diff --Make current saturation the proper saturation

    --Stay red for .05 seconds
    b.level_handles["gethittimer"..id] = LEVEL_TIMER:after(.05,
        function()
            --Transition current onhit hue to boss stage current hue when saturation is 0
            b.level_handles["gethithue"..id] = LEVEL_TIMER:after(.25,
                function()
                    b.part_colors[id].h = color
                end)
            --Drops saturation, then go to stage current saturation
            b.level_handles["gethitsaturation"..id] = LEVEL_TIMER:tween(.25, b.part_colors[id], {s = 0}, 'in-linear',
               function()
                   b.level_handles["gethitsaturation"..id] = LEVEL_TIMER:tween(.25, b.part_colors[id], {s = b.color_stage_current_saturation[id]}, 'in-linear')
                end
            )
        end
    )

end


function Boss_2_Main:changeStage()
    local b

    b = self

    if b.stage == 1 then
        b.behaviour = Stage_1
    elseif b.stage == 2 then
        FX.shake(1,3) --Shake screen
        LM.giveScore(1500, "boss hurt")
        --Reset stats
        for i = 1,4 do
            b.color_stage_current_saturation[i] = b.initial_saturation
            b.bottom_lightness[i] = 100 --Bottom color lightness in %
            b.upper_lightness[i] = 130 --Upper color lightness in %
            b.part_colors[i] = HSL(b.color_stage_hue[3], 0, b.bottom_lightness[i])
            b.level_handles["no_more_saturation"..i] = LEVEL_TIMER:tween(1, b.part_colors[i], {s = 255}, 'in-linear')
            b.damage_taken[i] = 0
            b.life[i] = 30 --30
            b.parts_alive = 4

            --Remove previous transitions
            if b.level_handles["gethithue"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethithue"..i])
            end
            if b.level_handles["gethitsaturation"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"..i])
            end
            if b.level_handles["gethittimer"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethittimer"..i])
            end

            b:colorLightnessLoop(i) --Start transition all over again

            b.turrets[i].static = true

        end

        b.shoot_fps = 1 --Update boss fps
        b.shoot_tick = 0 --Reset tick
        b.invincible = true --Can't take damage

        --Stop moving
        b.static = true

        b.level_handles["start_stage2"] = LEVEL_TIMER:after(1,
            function()
                b.invincible = false --Make boss "hittable"
                b.static = false --Make boss shoot player
                b.behaviour = Stage_2
                --Change turrets behaviour
                for i = 1, 4 do
                    local turret
                    turret = b.turrets[i]
                    turret.behaviour = Stage_2_t --Change their behaviour
                    turret.static = false --Make turrets move
                    turret.target = nil --Make them choose a target
                    turret.shoot_fps = 1.5 --Make turrets shoot slower
                    turret.shoot_tick = 0 --Reset tick
                    turret.speedv = 150 --Make turret slower

                    if i == 1 then
                        --From left to top left
                        turret.target = Vector(70, 70)
                    elseif i == 2 then
                        --From top to top right
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, 70)
                    elseif i == 3 then
                        --From right to bottom right
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT - 70)
                    else
                        --From bottom to bottom left
                        turret.target = Vector(70, ORIGINAL_WINDOW_HEIGHT - 70)
                    end

                    --Move turret to target position
                    turret.level_handles["moving_to_target"] = LEVEL_TIMER:tween(turret.pos:dist(turret.target)/turret.speedv, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                        function()
                            turret.target = nil
                        end
                    )

                end
            end
        )

    elseif b.stage == 3 then
        LM.giveScore(2000, "boss hurt")
        FX.shake(1,3) --Shake screen
        --Reset stats
        for i = 1,4 do
            b.color_stage_current_saturation[i] = b.initial_saturation
            b.bottom_lightness[i] = 100 --Bottom color lightness in %
            b.upper_lightness[i] = 130 --Upper color lightness in %
            b.part_colors[i] = HSL(b.color_stage_hue[4], 0, b.bottom_lightness[i])
            b.level_handles["timer_saturation"..i] = LEVEL_TIMER:after(3,
                function()
                    b.level_handles["no_more_saturation"..i] = LEVEL_TIMER:tween(1, b.part_colors[i], {s = 255}, 'in-linear',
                        function()
                            b.behaviour = Stage_3
                            b.invincible = false
                            b.static = false
                        end
                    )
                end
            )
            b.damage_taken[i] = 0
            b.life[i] = 30 --40 (change to 30?)
            b.parts_alive = 4
            b.shoot_tick = 0 --Reset tick
            b.invincible = true --Can't take damage
            b.static = true --Stop moving
            b.shoot_fps = .5 --Make boss shoot faster

            --Remove previous transitions
            if b.level_handles["gethithue"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethithue"..i])
            end
            if b.level_handles["gethitsaturation"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"..i])
            end
            if b.level_handles["gethittimer"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethittimer"..i])
            end

            b:colorLightnessLoop(i) --Start transition all over again

            local turret = b.turrets[i]
            turret.shoot_fps = 1 --Make turrets shoot faster
            turret.shoot_tick = 0 --Reset tick
            turret.static = true --Stop turrets action
            turret.speedv = 200 --Make turret faster

            if turret.level_handles["moving_to_target"] then
                LEVEL_TIMER:cancel(turret.level_handles["moving_to_target"])
            end


            --Move turret to the middle
            turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2)
            turret.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                function()
                    FX.shake(.3,3)
                    --Get turret target position
                    if turret.identification == 1 then
                        turret.target = Vector(70, ORIGINAL_WINDOW_HEIGHT/2) --Left
                    elseif turret.identification == 2 then
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, 70)  --Up
                    elseif turret.identification == 3 then
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT/2) --Right
                    else
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT - 70) --Bottom
                    end

                    --Move turret to target position
                    turret.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                        function()
                            turret.static = false
                            turret.behaviour = Stage_3_t
                            turret.target = nil
                        end
                    )
                end
            )

        end

    elseif b.stage == 4 then
        LM.giveScore(2500, "boss hurt")
        FX.shake(1,3) --Shake screen
        --Reset stats
        for i = 1,4 do
            b.color_stage_current_saturation[i] = b.initial_saturation
            b.bottom_lightness[i] = 100 --Bottom color lightness in %
            b.upper_lightness[i] = 130 --Upper color lightness in %
            b.part_colors[i] = HSL(b.color_stage_hue[5], 0, b.bottom_lightness[i])
            --Wait 3 seconds, then turn the correct color and start stage
            b.level_handles["wait"..i] = LEVEL_TIMER:after(6,
                function()
                    b.level_handles["no_more_saturation"..i] = LEVEL_TIMER:tween(2.5, b.part_colors[i], {s = 255}, 'in-linear',
                        function()
                            b.static = false
                            b.invincible = false
                            b.behaviour = Stage_4
                        end
                    )
                end
            )
            b.damage_taken[i] = 0
            b.life[i] = 20 --20
            b.parts_alive = 4
            b.shoot_fps = .7 --Make main boss shoot faster
            b.shoot_tick = 0 --Reset tick
            b.invincible = true --Can't take damage
            b.static = true --Stop moving

            --Remove previous transitions
            if b.level_handles["gethithue"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethithue"..i])
            end
            if b.level_handles["gethitsaturation"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"..i])
            end
            if b.level_handles["gethittimer"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethittimer"..i])
            end

            b:colorLightnessLoop(i) --Start transition all over again

            local turret = b.turrets[i]

            turret.static = true
            turret.behaviour = Stage_4_t
            turret.stage = 4
            turret.shoot_fps = 2 --Make turrets shoot slower

            --Stop movement of turret
            if turret.level_handles["moving_to_target"] then
                LEVEL_TIMER:cancel(turret.level_handles["moving_to_target"])
            end

            --Move turret to the middle
            turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2)
            turret.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                function()
                    --Get turret inicial position
                    if turret.identification == 1 then
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2 - 115, ORIGINAL_WINDOW_HEIGHT/2) --Left
                    elseif turret.identification == 2 then
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2 - 115)  --Up
                    elseif turret.identification == 3 then
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2 + 115, ORIGINAL_WINDOW_HEIGHT/2) --Right
                    else
                        turret.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2 + 115) --Bottom
                    end

                    --Restart turret movement
                    turret.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                        function()
                            local ball1, ball2, ball3, ball4 --Index for red balls around turret, based on his original identification
                            ball1 = turret.identification --Get ball same direction from current direction
                            ball2 = (turret.identification%4) + 1 --Get ball one direction clockwise from current direction
                            ball3 = ((turret.identification+1)%4) + 1 --Get ball two direction clockwise from current direction
                            ball4 = ((turret.identification+2)%4) + 1 --Get ball three direction clockwise from current direction

                            --Ball1 and ball3 will decrease until they are gone, while ball2 and ball4 will be active
                            turret.parts_alive[ball1] = false
                            turret.parts_alive[ball3] = false
                            turret.active_ball1 = ball2
                            turret.red_circle_tick1 = turret.red_circle_time1
                            turret.active_ball2 = ball4
                            turret.red_circle_tick2 = turret.red_circle_time2

                            turret.static = false --Make turret red circle grow/shrink

                            --Make red of balls more saturated, then make them hittable
                            turret.level_handles["increase_sat"] = LEVEL_TIMER:tween(2.5, turret.second_color, {s = 255}, 'in-linear', function() turret.invincible = false end)

                        end
                    )
                end
            )

        end

    elseif b.stage == 5 then
        LM.giveScore(3000, "boss hurt")
        FX.shake(2,3) --Shake screen
        --Reset stats
        for i = 1,4 do
            b.color_stage_current_saturation[i] = b.initial_saturation
            b.bottom_lightness[i] = 100 --Bottom color lightness in %
            b.upper_lightness[i] = 130 --Upper color lightness in %
            b.part_colors[i] = HSL(b.color_stage_hue[6], 0, b.bottom_lightness[i])
            b.damage_taken[i] = 0
            b.life[i] = 20
            b.parts_alive = 4
            b.shoot_tick = 0 --Reset tick
            b.invincible = true --Can't take damage
            b.static = true --Stop moving
            b.behaviour = Stage_5

            --Move main parts to the middle
            b.level_handles["move_to_middle "..i] = LEVEL_TIMER:tween(2, b.positions[i], {x = 0, y = 0}, 'in-linear')
            --"Delete" the parts, to only consider the first
            if i > 1 then
                b.level_handles["after_move"..i] = LEVEL_TIMER:after(2.5, function() b.parts_alive = b.parts_alive - 1; b.number_parts = b.number_parts - 1; end)
            --Make main part shoot again
            else
                b.level_handles["after_move"..i] = LEVEL_TIMER:after(2.5, function() b.static = false; end)
            end

            --Remove previous transitions
            if b.level_handles["gethithue"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethithue"..i])
            end
            if b.level_handles["gethitsaturation"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethitsaturation"..i])
            end
            if b.level_handles["gethittimer"..i] then
                LEVEL_TIMER:cancel(b.level_handles["gethittimer"..i])
            end

            b:colorLightnessLoop(i) --Start transition all over again

            local turret = b.turrets[i]

            local _x, _y
            --Explode active red circles

            for j = 1,4 do
                if j == turret.active_ball1 or j == turret.active_ball2 then

                    --Get red circle position
                    _x = turret.pos.x - turret.red_circles_r[j] + turret.positions[j].x
                    _y = turret.pos.y - turret.red_circles_r[j] + turret.positions[j].y

                    --Create explosion
                    FX.explosion(_x, _y, turret.red_circles_r[j], Color.red(), 50, nil, 300, 3, true)

                    --"Remove" red circle
                    turret.red_circles_r[j] = 0
                    turret.parts_alive[j] = false

                end
            end

            turret.static = true
            turret.invincible = true
            turret.behaviour = Stage_5_t
            turret.stage = 5
            turret.speedv = 250
            Stage_5_fps = 2 --Set fps for both turret and main

            if i == 1 then
                --From left to top left
                turret.target = Vector(70, 70)
            elseif i == 2 then
                --From top to top right
                turret.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, 70)
            elseif i == 3 then
                --From right to bottom right
                turret.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT - 70)
            else
                --From bottom to bottom left
                turret.target = Vector(70, ORIGINAL_WINDOW_HEIGHT - 70)
            end

            --Move turret to respective position
            turret.level_handles["move_to_position"] = LEVEL_TIMER:tween(2, turret.pos, {x = turret.target.x, y = turret.target.y}, 'in-linear',
                function()
                    --Increase ring size, thank make turret hittable/active
                    turret.level_handles["grow_ring"] = LEVEL_TIMER:tween(2, turret, {outer_ring = turret.initial_outer_ring_size}, 'in-linear',
                        function()
                            turret.static = false
                            turret.invincible = false
                        end
                    )
                    --Make turret natural color again
                    turret.level_handles["become_blue"] = LEVEL_TIMER:tween(2, turret.color, {s = 180}, 'in-linear')
                end
            )
        end

    elseif b.stage == 6 then
        LM.giveScore(4000, "boss defeated")
        b.static = true

        b.level_handles["text_appear"] = LEVEL_TIMER:after(.5, function() LM.text(ORIGINAL_WINDOW_WIDTH/2 - 105, ORIGINAL_WINDOW_HEIGHT/2 - 90, "please don't kill me", 4.5, 110) end)
        b.level_handles["wait"] = LEVEL_TIMER:after(2,
            function()
                b.level_handles["no_more_saturation"] = LEVEL_TIMER:tween(1.5, b.part_colors[1], {s = 255}, 'in-linear',
                    function()
                        b.invincible = false
                    end
                )
            end
        )

    elseif b.stage == 7 then
        LM.giveScore(666, "boss killed")
        b:kill()

    end

end

--Keeps transitioning boss color saturation from values bottom_lightness to upper_lightness, and vice-versa
function Boss_2_Main:colorLightnessLoop(id)
    local b

    b = self

    --Remove previous timer
    if b.level_handles["lightness"..id] then
        COLOR_TIMER:cancel(b.level_handles["lightness"..id])
    end

    --Start saturation transition from bottom_lightness to upper_lightness
    b.level_handles["lightness"..id] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.part_colors[id], {l = b.upper_lightness[id]}, 'in-linear',
        --After reaching upper_lightness, start lightness transition from upper_lightness to bottom_lightness
        function()
            b.level_handles["lightness"..id] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.part_colors[id], {l = b.bottom_lightness[id]}, 'in-linear',
                --After reaching bottom_lightness, start eveything again
                function()
                    b:colorLightnessLoop(id)
                end
            )
        end
    )

end

--------------------
--BOSS TURRET PART--
--------------------

Boss_2_Turret = Class{
    __includes = {CIRC},
    init = function(self, x, y, id)
        local r, color

        r = 40 --Radius of central turret part
        self.red_circles_r = {20,20,20,20} --Radius of red circles around
        self.max_red_circle_r = 57 --Max radius for red circles (for stage 4)
        self.active_ball1 = nil --First active red circle (for stage 4)
        self.active_ball2 = nil --Second active red circle (for stage 4)
        self.red_circle_tick1 = 0 --Tick to increase red circle size (first active cicle) (for stage 4)
        self.red_circle_time1 = 3 --Time necessary for red circle to start increasing size (first active cicle) (for stage 4)
        self.red_circle_tick2 = 0 --Tick to increase red circle size (second active cicle) (for stage 4)
        self.red_circle_time2 = 3 --Time necessary for red circle to start increasing size (second active cicle) (for stage 4)

        self.outer_ring = 0 --Radius of ring for turrets (for stage 5)
        self.initial_outer_ring_size = 40 --Inicial radius for the outer ring (Stage 5)

        self.outer_radius = r --Radius for final part
        self.bottom_lightness = 100
        self.upper_lightness = 130
        self.color_pulse_duration = 1 --Duration between color saturation transitions

        self.second_color = HSL(250, 90, 150) --"Grey Red"
        color = HSL(250, 0, self.bottom_lightness)

        CIRC.init(self, x, y, r, color, nil, "fill") --Set atributes

        self.identification = id --This turret id


        self.positions = { --Relative position each parts of the poss has
            Vector(-r, 0), --Left
            Vector(0, -r), --Top
            Vector(r, 0),  --Right
            Vector(0, r),  --Bottom

        }

        --Boss speed value
        self.speedv = 350 --Speed value
        self.target = nil --Target to move

        self.dir = nil --Direction to move (Stage 5)

        self.getDir = false --If turret should get a direction to shoot itself to player
        self.getIndicator = false --If turret create a indicator following psycho
        self.shoot_to_player = false --If turret should shoot itself to player

        self.counter = 0 --Counter for stage 3

        self.parts_alive = {true,true,true,true} --Secondary parts alive (true if its alive)

        self.invincible = true --If boss can get hit
        self.static = false --If turret can "act"

        self.shoot_tick = 1.4 --Enemy shooter "cooldown" timer (for shooting repeatedly)
        self.shoot_fps = 1.4 --How fast to shoot enemies

        self.stage = 0
        self.behaviour = nil --What behaviour this turret is following
        self.tp = "boss_two_turret" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Boss_2_Turret:draw()
    local p, x, y

    p = self

    --Draw the outer ring (stage 5)
    if p.outer_ring > 0 then
        love.graphics.setLineWidth(4)
        Color.set(p.second_color)
        love.graphics.circle("line", p.pos.x, p.pos.y, p.r + p.outer_ring)
    end

    --Draw the small red circles
    Color.set(p.second_color)
    for i = 1, 4 do
        if p.red_circles_r[i] > 0 then
            x = p.pos.x - p.red_circles_r[i] + p.positions[i].x
            y = p.pos.y - p.red_circles_r[i] + p.positions[i].y


            --Draw the circle
            love.graphics.setShader(Generic_Smooth_Circle_Shader)
            love.graphics.draw(PIXEL, x, y, 0, 2*p.red_circles_r[i])
            love.graphics.setShader()
        end
    end

    Color.set(p.color)
    --Draw the big center circle
    love.graphics.setShader(Generic_Smooth_Circle_Shader)
    love.graphics.draw(PIXEL, p.pos.x - p.r, p.pos.y - p.r, 0, 2*p.r)
    love.graphics.setShader()

end

function Boss_2_Turret:collides(o)
    local col

    e = self
    for i = 1, 4 do
        if e.red_circles_r[i] > 0  then
            dx = e.pos.x + e.positions[i].x - o.pos.x
            dy = e.pos.y + e.positions[i].y - o.pos.y

            --In case of psycho, check collision with his collision radius
            if o.tp == "psycho" then
                dr = e.red_circles_r[i] + o.collision_r
            else
                dr = e.red_circles_r[i] + o.r
            end

            if ((dx*dx + dy*dy) < dr*dr) then
                return true, i
            end
        end
    end

    --Collision with center

    dx = e.pos.x - o.pos.x
    dy = e.pos.y - o.pos.y

    --In case of psycho, check collision with his collision radius
    if o.tp == "psycho" then
        dr = (e.r + e.outer_ring) + o.collision_r
    else
        dr = (e.r + e.outer_ring) + o.r
    end

    if ((dx*dx + dy*dy) < dr*dr) then
        return true, 5
    end

    return false

end

function Boss_2_Turret:getHit(id)
    local t

    t = self
    if t.stage == 4 then
        if id == t.active_ball1 then
            t.red_circle_tick1 = 0 --Reset tick that increases the circle
            t.red_circles_r[id] = t.red_circles_r[id] - 4 --Reduces the circle size
            if t.red_circles_r[id] < 0 then t.red_circles_r[id] = 0 end --Cap radius at 0
        elseif id == t.active_ball2 then
            t.red_circle_tick2 = 0 --Reset tick that increases the circle
            t.red_circles_r[id] = t.red_circles_r[id] - 4 --Reduces the circle size
            if t.red_circles_r[id] < 0 then t.red_circles_r[id] = 0 end --Cap radius at 0
        end
    end

    if t.stage == 5 then
        if id == 5  and t.outer_ring > 0 then
            t.outer_ring = t.outer_ring - 2 --Decreases the size of outer ring
            if t.outer_ring <= 0 then
                t:kill() --Kill this turret

                FX.shake(1,3) --Shake screen

                --Reduced number of turrets alive, and do stuff
                local main = Util.findId("boss_2_main")

                main.turret_alive = main.turret_alive - 1 --Update turret counter

                --Make boss shoot faster
                if main.turret_alive == 3 then
                    Stage_5_fps = 1.5
                    Increase_Radius(20)
                --Make boss shoot faster and turrets start bouncing on the screen
                elseif main.turret_alive == 2 then
                    Stage_5_bounce = true
                    Stage_5_fps = 1
                    Increase_Radius(40)
                elseif main.turret_alive == 1 then
                    Stage_5_fps = .8
                    Stage_5_bounce = false --Stop bouncing
                    for turret in pairs(Util.findSbTp("bosses")) do

                        if turret.tp == "boss_two_turret" then
                            turret.getIndicator = true
                            turret.speedv = 700 --Increase turret speed
                        end

                    end
                    main.random_enemies = true --Start shooting random enemies
                    Increase_Radius(80)
                elseif main.turret_alive == 0 then
                    main.stage = main.stage + 1
                    main:changeStage() --Change boss to last stage
                end

            end
        end
    end

end

function Boss_2_Turret:kill()
    local b

    b = self

    if b.death then return end
    b.death = true

    FX.explosion(self.pos.x, self.pos.y, 20, self.color, 600, 600, 100, 4, true)

end

--Update this boss
function Boss_2_Turret:update(dt)
    local b

    b = self
    --Boss won't move if static
    if b.static then return end

    if b.behaviour then
        b:behaviour(dt) --Make boss current stage behaviour
    end

end


--Keeps transitioning boss color saturation from values bottom_lightness to upper_lightness, and vice-versa
function Boss_2_Turret:colorLightnessLoop(id)
    local b

    b = self

    --Remove previous timer
    if b.level_handles["lightness"..id] then
        COLOR_TIMER:cancel(b.level_handles["lightness"..id])
    end

    --Start saturation transition from bottom_lightness to upper_lightness
    b.level_handles["lightness"..id] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.second_color, {l = b.upper_lightness[id]}, 'in-linear',
        --After reaching upper_lightness, start lightness transition from upper_lightness to bottom_lightness
        function()
            b.level_handles["lightness"..id] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.second_color, {l = b.bottom_lightness[id]}, 'in-linear',
                --After reaching bottom_lightness, start eveything again
                function()
                    b:colorLightnessLoop(id)
                end
            )
        end
    )

end



--UTILITY FUNCTIONS--

function boss.create()
    local b, a

    b = Boss_2_Main()

    b:addElement(DRAW_TABLE.BOSSu, "bosses", "boss_2_main") --make boss appear
    for i = 1,4 do
        b:colorLightnessLoop(i) --Start color transition
    end

    b.turrets[1] = Boss_2_Turret(b.pos.x - math.sqrt(3)*b.r/2, b.pos.y, 1) --Left
    b.turrets[1]:addElement(DRAW_TABLE.BOSS, "bosses")
    b.turrets[2] = Boss_2_Turret(b.pos.x, b.pos.y - math.sqrt(3)*b.r/2, 2) --Top
    b.turrets[2]:addElement(DRAW_TABLE.BOSS, "bosses")
    b.turrets[3] = Boss_2_Turret(b.pos.x + math.sqrt(3)*b.r/2, b.pos.y, 3) --Right
    b.turrets[3]:addElement(DRAW_TABLE.BOSS, "bosses")
    b.turrets[4] = Boss_2_Turret(b.pos.x, b.pos.y + math.sqrt(3)*b.r/2, 4) --Bottom
    b.turrets[4]:addElement(DRAW_TABLE.BOSS, "bosses")



    b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2)

    --Make boss move to the center
    b.level_handles["moving"] = LEVEL_TIMER:tween(b.pos:dist(b.target)/b.speedv, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
        function()

            FX.shake(.5, 5) --Shake screen

            LM.boss_title("NATHAN, THE ETERNAL BEAUTY") --Boss title

            --After 2 seconds, make boss smaller in 1 second
            b.level_handles["moving_2"] = LEVEL_TIMER:after(2,
                function()
                    local _r
                    _r = 2*b.r/3
                    for id = 1, 4 do
                        local _x, _y
                        _x, _y = 2*(b.positions[id].x) / 3, 2*(b.positions[id].y) / 3
                        b.level_handles["shrink"..id] = LEVEL_TIMER:tween(.8, b.positions[id], {x = _x, y = _y}, 'in-linear',
                            function()
                                --Shake screen
                                b.level_handles["shake_screen"] = LEVEL_TIMER:after(1,
                                    function()
                                        FX.shake(1,2)
                                    end
                                )
                                --Turn green
                                b.level_handles["turn_green"..id] = LEVEL_TIMER:tween(1.7, b.part_colors[id], {s = 255}, 'in-expo')
                            end
                        )
                    end
                    b.level_handles["shrink_radius"] = LEVEL_TIMER:tween(.8, b, {r = _r}, 'in-linear')
                    --After shrinking, make boss vincible
                    b.level_handles["after_shrink"] = LEVEL_TIMER:after(2.5,
                        function ()
                            b.invincible = false
                            b.stage = 1
                            b:changeStage()
                        end
                    )
                end
            )
        end
    )

    --Make turrets move to the center
    for i = 1, 4 do
        b.turrets[i].target = Vector(b.turrets[i].pos.x, b.turrets[i].pos.y + 500 + ORIGINAL_WINDOW_HEIGHT/2)
        b.turrets[i].level_handles["moving"] = LEVEL_TIMER:tween(b.turrets[i].pos:dist(b.turrets[i].target)/b.speedv, b.turrets[i].pos, {x = b.turrets[i].target.x, y = b.turrets[i].target.y}, 'in-linear',
            function()

                --After 2 seconds, make turret go to respective side in 1 second
                b.turrets[i].level_handles["moving_2"] = LEVEL_TIMER:after(2,
                    function()

                        _x, _y = b.turrets[i].pos.x, b.turrets[i].pos.y

                        if i == 1 then --Left
                            _x = 70
                        elseif i == 2 then --Top
                            _y = 70
                        elseif i == 3 then --Right
                            _x = ORIGINAL_WINDOW_WIDTH - 70
                        elseif i == 4 then --Bottom
                            _y = ORIGINAL_WINDOW_HEIGHT - 70
                        end

                        --Move turret to side
                        b.turrets[i].level_handles["moving_3"] = LEVEL_TIMER:tween(1.5, b.turrets[i].pos, {x = _x, y = _y}, 'in-linear')

                        --After waiting 2.1s (boss time to begins), start turrets stage 1
                        b.turrets[i].level_handles["after_move"] = LEVEL_TIMER:after(2.5,
                            function ()
                                b.turrets[i].stage = 1
                                b.turrets[i].behaviour = Stage_1_t
                            end
                        )
                    end
                )
            end
        )
    end


    return
end


--LOCAL FUNCTIONS--

--STAGES--

--Shoots at the player with double balls
Stage_1 = function(b, dt)

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick


        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = DB, score_mul = 0, e_radius = 30}

    end

end

--Shoots at the player with simple balls
Stage_1_t = function(b, dt)

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = SB, speed_m = 1, score_mul = 0}

    end

end

--Shoots at the player with Grey Balls
Stage_2 = function(b, dt)

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = GrB, score_mul = 0, e_radius = 30}

    end

end

--Shoots at the player with double balls while moving clockwise in the corners
Stage_2_t = function(b, dt)

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = DB, speed_m = .8, score_mul = 0}

    end

    if b.target == nil then
        --Get target position
        if b.pos.x <= ORIGINAL_WINDOW_WIDTH/2 then
            if b.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
                --From top left to top right
                b.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, 70)
            else
                --From bottom left to top left
                b.target = Vector(70, 70)
            end
        else
            if b.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
                --From top right to bottom right
                b.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT - 70)
            else
                --From bottom right to bottom left
                b.target = Vector(70, ORIGINAL_WINDOW_HEIGHT - 70)
            end
        end

        --Move turret to target position
        b.level_handles["moving_to_target"] = LEVEL_TIMER:tween(b.pos:dist(b.target)/b.speedv, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
            function()
                b.target = nil
            end
        )
    end

end

--Shoots at the player with big Grey or Glitch Balls
Stage_3 = function(b, dt)
    local e

    --40% of shooting grey balls and 60% of shooting glitch balls
    if love.math.random() < .4 then
        e = GrB
    else
        e = GlB
    end

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, score_mul = 0, e_radius = 30}

    end

end

--Shoots at the player with Glitch Balls
Stage_3_t = function(b, dt)

    b.shoot_tick = b.shoot_tick + dt

    if b.shoot_tick >= b.shoot_fps then

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = GlB, speed_m = .8, score_mul = 0}

    end

    if b.target == nil then
        --Get target position
        if b.pos.x <= ORIGINAL_WINDOW_WIDTH/2 - 80  then
            --From left to top
            b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, 70)
        elseif b.pos.y <= ORIGINAL_WINDOW_HEIGHT/2 - 80 then
            --From top to right
            b.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT/2)
        elseif b.pos.x >= ORIGINAL_WINDOW_WIDTH/2 + 80 then
            --From right to bottom
            b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT - 70)
        else
            --From bottom to left
            b.target = Vector(70, ORIGINAL_WINDOW_HEIGHT/2)
        end

        --Move turret to target position 4 times, the goes to the center and back
        b.level_handles["moving_to_target"] = LEVEL_TIMER:tween(b.pos:dist(b.target)/b.speedv, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
            function()
                b.counter = b.counter + 1
                if b.counter < 3 then
                    b.target = nil
                else
                    b.static = true
                    --Move turret to the middle
                    b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2)
                    b.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
                        function()
                            FX.shake(3,1)
                            --Wait 3 seconds before going out
                            b.level_handles["moving_to_target"] = LEVEL_TIMER:after(3,
                                function()

                                    --Get turret inicial position
                                    if b.identification == 1 then
                                        b.target = Vector(70, ORIGINAL_WINDOW_HEIGHT/2) --Left
                                    elseif b.identification == 2 then
                                        b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, 70)  --Up
                                    elseif b.identification == 3 then
                                        b.target = Vector(ORIGINAL_WINDOW_WIDTH - 70, ORIGINAL_WINDOW_HEIGHT/2) --Right
                                    else
                                        b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT - 70) --Bottom
                                    end

                                    --Restart turret movement
                                    b.level_handles["moving_to_target"] = LEVEL_TIMER:tween(2, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
                                        function()
                                            b.static = false
                                            b.counter = 0
                                            b.target = nil
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            end
        )
    end

end

--Shoots at the player with grey or glitch balls
Stage_4 = function(b, dt)
    local e

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        if love.math.random() > .8 then e = GrB else e = GlB end --Shoot randomly Glitch balls (80%) or Grey Balls (20%)
        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, score_mul = 0, e_radius = 30}

    end

end

--Decreases "dead" red circles, and increases size after some time.
--Also shoot randomly glitch or double balls at the player
Stage_4_t = function(b, dt)
    local e

    for i = 1, 4 do
        --Circles dead
        if b.parts_alive[i] == false and b.red_circles_r[i] > 0 then
            b.red_circles_r[i] = b.red_circles_r[i] - 20*dt
            if b.red_circles_r[i] < 0 then b.red_circles_r[i] = 0 end
        --Circles alive
    elseif b.parts_alive[i] == true then
            --First active ball
            if i == b.active_ball1 then
                --If tick has reached the necessary time to start increasing...
                if b.red_circle_tick1 > b.red_circle_time1 then
                    --Tries to increase radius, if possible
                    if b.red_circles_r[i] < b.max_red_circle_r then
                        b.red_circles_r[i] = b.red_circles_r[i] + 10*dt
                        if b.red_circles_r[i] > b.max_red_circle_r then b.red_circles_r[i] = b.max_red_circle_r end
                    end
                --Else, increase the tick for first active circle
                else
                    b.red_circle_tick1 = b.red_circle_tick1 + dt
                end
            --Second active ball
            else
                --If tick has reached the necessary time to start increasing...
                if b.red_circle_tick2 > b.red_circle_time2 then
                    --Tries to increase radius, if possible
                    if b.red_circles_r[i] < b.max_red_circle_r then
                        b.red_circles_r[i] = b.red_circles_r[i] + 10*dt
                        if b.red_circles_r[i] > b.max_red_circle_r then b.red_circles_r[i] = b.max_red_circle_r end
                    end
                --Else, increase the tick for second active circle
                else
                    b.red_circle_tick2 = b.red_circle_tick2 + dt
                end
            end
        end

    end

    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= b.shoot_fps do

        b.shoot_tick = b.shoot_tick - b.shoot_fps --Update tick

        if love.math.random() > .1 then e = GlB else e = DB end --Shoot randomly Glitch balls (90%) or Double Balls (10%)

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, speed_m = 1, score_mul = 0}

        --Randomly can make a following enemy to appear
        if love.math.random() < .15 then
            local _x, _y

            _x, _y = LM.outsidePosition(love.math.random(2*ORIGINAL_WINDOW_WIDTH+2*ORIGINAL_WINDOW_HEIGHT+1)-1)

            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 5, ind_side = 50, ind_duration = 2.5}

        end

    end

end

--Shoot at the player. If there is only one turret left, it may shoot Glitch Balls
Stage_5 = function(b, dt)
    local e
    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= Stage_5_fps do

        b.shoot_tick = b.shoot_tick - Stage_5_fps --Update tick

        e = GrB
        --If random enemies, boss shoot randomly glitch or grey balls
        if b.random_enemies and love.math.random() > .5 then e = GlB end

        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = e, score_mul = 0, e_radius = 35}

    end

end

Stage_5_t = function(b, dt)

    if Stage_5_bounce then
        --Get dir for turret if there isn't one
        if not b.dir then
            local dx, dy

            --Get random direction
            dx = math.cos(love.math.random()*2*math.pi)
            dy = math.sin(love.math.random()*2*math.pi)

            b.dir = Vector(dx,dy)

        end

        --Move turret
        b.pos.x = b.pos.x + dt*b.dir.x*b.speedv
        b.pos.y = b.pos.y + dt*b.dir.y*b.speedv

        --Fix horizontal direction if leave screen
        if b.pos.x < b.r + b.outer_ring then b.dir.x = math.abs(b.dir.x)
        elseif b.pos.x > ORIGINAL_WINDOW_WIDTH - (b.r + b.outer_ring)  then b.dir.x = -math.abs(b.dir.x) end

        --Fix vertical direction if leave screen
        if b.pos.y < b.r + b.outer_ring then b.dir.y = math.abs(b.dir.y)
        elseif b.pos.y > ORIGINAL_WINDOW_HEIGHT - (b.r + b.outer_ring)  then b.dir.y = -math.abs(b.dir.y) end


    end

    if b.getIndicator then
        b.getIndicator = false
        Indicator.create_rotating(50, b.color, 1, b.r + b.outer_ring + 50, Vector(b.pos.x, b.pos.y))
        b.level_handles["get_direction"] = LEVEL_TIMER:after(1, function() b.getDir = true end)
    end

    if b.getDir then
        local p
        b.getDir = false
        p = Util.findId("psycho")

        --Get direction to psycho
        if p then
            b.dir = Vector(p.pos.x - b.pos.x, p.pos.y - b.pos.y)
        else
            b.dir = Vector(ORIGINAL_WINDOW_WIDTH/2 - b.pos.x, ORIGINAL_WINDOW_HEIGHT/2 - b.pos.y)
        end

        b.dir = b.dir:normalized()

        b.shoot_to_player = true --Will shoot at player
    end

    if b.shoot_to_player then
        --Move turret
        b.pos.x = b.pos.x + dt*b.dir.x*b.speedv
        b.pos.y = b.pos.y + dt*b.dir.y*b.speedv

        --Stop turret if it reaches the edge of the screen
        if b.pos.x < b.r + b.outer_ring or
           b.pos.x > ORIGINAL_WINDOW_WIDTH - (b.r + b.outer_ring) or
           b.pos.y < b.r + b.outer_ring or
           b.pos.y > ORIGINAL_WINDOW_HEIGHT - (b.r + b.outer_ring) then
               FX.shake(.5,4)
               b.shoot_to_player = false
               --Restart cycle of getting an indicator
               b.level_handles["resume_indicator"] = LEVEL_TIMER:after(.3, function() b.getIndicator = true end)
        end

    end


    b.shoot_tick = b.shoot_tick + dt

    while b.shoot_tick >= 2*Stage_5_fps/3 do

        b.shoot_tick = b.shoot_tick - 2*Stage_5_fps/3 --Update tick


        F.single{x = b.pos.x, y = b.pos.y, dir_follow = true, ind_mode = false, enemy = DB, score_mul = 0, e_radius = 25, speed_m = 1.2}

    end


end

--Increase for all alive turrets their outer ring radius by i
Increase_Radius = function(i)

    for turret in pairs(Util.findSbTp("bosses")) do

        if turret.tp == "boss_two_turret" then
            turret.level_handles["increase"..i] = LEVEL_TIMER:tween(.5, turret, {outer_ring = turret.outer_ring + i}, 'in-linear')
        end

    end

end

--return function
return boss
