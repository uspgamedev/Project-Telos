require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"

--BOSS #1 CLASS--
--[[Name of boss here]]

--Behaviours--
local Stage_1_and_2

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
        self.color_onhit_hue = 254 --Color hue for when boss is hit (red)
        self.color_onhit_saturation = 235 --Color saturation for when boss is hit
        self.color_stage_current_saturation = self.initial_saturation --Current stage color saturation this boss has
        self.color_dying_target_saturation = 180 --Target saturation the boss is reaching whenever he gets hit

        color = HSL(self.color_stage_hue[1], self.initial_saturation, self.bottom_lightness) --Color of boss


        self.color_pulse_duration = 2 --Duration between color saturation transitions

        CIRC.init(self, ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2, r, color, nil, "fill") --Set atributes
        ELEMENT.setSubTp(self, "boss")

        --Boss speed value
        self.speedv = 320 --Speed value

        self.life = 80 --How many hits this boss can take before changng state
        self.damage_taken = 0 --How many hits this boss has taken
        self.invincible = true --If boss can get hit
        self.static = true --If boss can move
        self.stage = 1 --Stage this boss is
        self.target = nil --Index of target position
        self.newTarget = true --If boss needs a new target

        self.validPositions = {}
        self.validPositions[1] = Vector(self.r + 10, self.r + 10) --Top Left
        self.validPositions[2] = Vector(ORIGINAL_WINDOW_WIDTH - self.r - 10, self.r + 10) --Top Right
        self.validPositions[3] = Vector(ORIGINAL_WINDOW_WIDTH - self.r - 10, ORIGINAL_WINDOW_HEIGHT - self.r  - 10) --Bottom Right
        self.validPositions[4] = Vector(self.r + 10, ORIGINAL_WINDOW_HEIGHT - self.r - 10) --Bottom Left

    	self.long_roar =  love.audio.newSource("assets/sfx/boss1/long_roar.wav")

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

    FX.explosion(self.pos.x, self.pos.y, self.r, self.color)

end

--Update this boss
function Boss_1:update(dt)
    local b

    b = self
    --Boss won't move if static
    if b.static then return end

    b:behaviour(dt) --Make boss current stage behaviour

end

Stage_1_and_2 = function(b, dt)
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

--Called when boss gets hit with psycho's bullet
function Boss_1:getHit()
    local b

    b = self

    b.damage_taken = b.damage_taken + 1
    b.bottom_lightness = b.bottom_lightness - .2
    b.upper_lightness = b.upper_lightness - .2
    b:getHitAnimation()

    if b.damage_taken >= b.life then
        b.stage = b.stage + 1
        print("changing state to", b.stage)
        if b.stage >= 5 then
            b:kill()
        else
            b:changeStage()
        end
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

    --Stay red for .03 seconds
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
        b.speedv = 400 --Make boss faster
        b.damage_taken = 0 --Reset boss life
        b.invincible = true --Can't take damage

        --Stop moving
        b.static = true
        if b.level_handles["move"] then
            LEVEL_TIMER:cancel(b.level_handles["move"])
        end

        --Start stage 2
        b.level_handles["begin_stage"] = LEVEL_TIMER:after(3,
            function()
                 print("changed")

                 b.static, b.invincible = false, false --Make boss walk and be able to die

                 --Continue his movement
                 b.level_handles["move"] = LEVEL_TIMER:tween(timeToReach(b), b.pos, {x = b.validPositions[b.target].x, y = b.validPositions[b.target].y}, 'in-linear',
                     function()
                         b.newTarget = true
                     end
                 )
             end
        )
    end

end

--UTILITY FUNCTIONS--

function boss.create()
    local b, shadow

    b = Boss_1()

    --Create shadow of boss
    shadow = CIRC(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2, 0, HSL(0,0,8,200))
    shadow:addElement(DRAW_TABLE.BOSS, "boss_effect")

    --Grows shadow
    shadow.level_handles["create_boss"] = LEVEL_TIMER:tween(4, shadow, {r = 120}, 'in-cubic' ,
        function()
            shadow.death = true --Remove shadow
            b:addElement(DRAW_TABLE.BOSS, "bosses") --make boss appear
            b:colorLightnessLoop() --Start color transition
            FX.shake(.5, 5) --Shake screen
            --Screen shake and roar
            b.level_handles["begin_stage"] = LEVEL_TIMER:after(1.5,
                function()

                    --ROAR AND SHAKE
                    b.long_roar:setVolume(5)
		            b.long_roar:play()
                    SFX["boss_roar"] = b.long_roar
                    FX.shake(2, 3) --Shake screen

                    --Start stage 1
                    b.level_handles["begin_stage"] = LEVEL_TIMER:after(2.2,
                        function()
                             b.static ,b.invincible = false, false
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

--return function
return boss
