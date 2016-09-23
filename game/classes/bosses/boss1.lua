require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"

--BOSS #1 CLASS--
--[[Name of boss here]]

local boss = {}

Boss_1 = Class{
    __includes = {CIRC},
    init = function(self)
        local r, saturation, lightness, color

        r = 100 --Radius of enemy
        self.initial_saturation = 255 --Inicial color saturation in %
        self.initial_lightness = 100 --Inicial color lightness in %
        self.color_stage_hue = {}
        self.color_stage_hue[1] = 77.88 --Color hue for stage 1 (green)
        self.color_stage_hue[2] = 42.48  --Color hue for stage 2 (yellow)
        self.color_stage_hue[3] = 152.22 --Color hue for stage 3 (blue)
        self.color_stage_hue[4] = 188.32 --Color hue for stage 4 (purple)
        self.color_onhit_hue = 254 --Color hue for when boss is hit (red)
        self.color_onhit_saturation = 225 --Color lightness for when boss is hit
        self.color_stage_current_saturation = self.initial_lightness --Current stage color hue this boss has
        self.color_dying_target_saturation = 0 --Target hue the boss is reaching whenever he gets hit (red)

        color = HSL(self.color_stage_hue[1], self.initial_saturation, self.initial_lightness) --Color of boss


        self.color_pulse_duration = 2 --Duration between color saturation transitions

        CIRC.init(self, ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2, r, color, nil, "fill") --Set atributes
        ELEMENT.setSubTp(self, "boss")

        --Normalize direction and set speed
        self.speedv = 250 --Speed value
        self.speed_m =  1 --Speed multiplier
        self.speed = Vector(0, 0) --Speed vector

        self.life = 100 --How many hits this boss can take before changng state
        self.damage_taken = 0 --How many hits this boss has taken
        self.invincible = true --If boss can get hit
        self.static = true --If boss can move
        self.stage = 1 --Stage this boss is

        self.tp = "boss_one" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Boss_1:kill()
    local b

    b = self

    if b.death then return end
    b.death = true

    --Remove transitions
    if b.handles["gethithue"] then
        LEVEL_TIMER:cancel(b.handles["gethithue"])
    end
    if b.handles["gethitsaturation"] then
        LEVEL_TIMER:cancel(b.handles["gethitsaturation"])
    end
    if b.handles["lightness"] then
        COLOR_TIMER:cancel(b.handles["lightness"])
    end
    if b.handles["gethittimer"] then
        LEVEL_TIMER:cancel(b.handles["gethittimer"])
    end


    FX.explosion(self.pos.x, self.pos.y, self.r, self.color)

end

--Update this boss
function Boss_1:update(dt)
    local b

    b = self

    --Boss won't move if static
    if b.static then return end

    --Update movement
    b.pos = b.pos + dt*b.speed*b.speed_m

end

--Keeps transitioning boss color saturation from values initial_lightness to 130, and vice-versa
function Boss_1:colorLightnessLoop()
    local b

    b = self

    --Remove previous timer
    if b.handles["lightness"] then
        COLOR_TIMER:cancel(b.handles["lightness"])
    end

    --Start saturation transition from initial_lightness to 130
    b.handles["lightness"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {l = 130}, 'in-linear',
        --After reaching 130, start lightness transition from 130 to initial_lightness
        function()
            b.handles["lightness"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {l = b.initial_lightness}, 'in-linear',
                --After reaching initial_lightness, start eveything again
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
    b:getHitAnimation()

    if b.damage_taken >= b.life then
        print("ded")
        b:kill()
    end

end

--Color animation when boss gets hit
function Boss_1:getHitAnimation()
    local b, diff

    b = self
    --Remove previous transition
    if b.handles["gethithue"] then
        LEVEL_TIMER:cancel(b.handles["gethithue"])
    end
    if b.handles["gethitsaturation"] then
        LEVEL_TIMER:cancel(b.handles["gethitsaturation"])
    end
    if b.handles["gethittimer"] then
        LEVEL_TIMER:cancel(b.handles["gethittimer"])
    end

    --Make boss red when hit
    b.color.h = b.color_onhit_hue
    b.color.s = b.color_onhit_saturation

    --Update boss stage current lightness
    diff = b.damage_taken/b.life * (b.color_dying_target_saturation - b.initial_saturation) --Calculate how much of the difference between target saturation and initial stage color saturation the boss has reached
    b.color_stage_current_saturation = b.initial_saturation + diff --Make current saturation the proper saturation

    --Stay red for .2 seconds
    b.handles["gethittimer"] = LEVEL_TIMER:after(.03,
        function()
            --Transition current onhit hue to boss stage current hue when saturation is 0
            b.handles["gethithue"] = LEVEL_TIMER:after(.4,
                function()
                    b.color.h = b.color_stage_hue[b.stage]
                end)
            --Drops saturation, then go to stage current saturation
            b.handles["gethitsaturation"] = LEVEL_TIMER:tween(.4, b.color, {s = 0}, 'in-linear',
               function()
                   b.handles["gethitsaturation"] = LEVEL_TIMER:tween(.4, b.color, {s = b.color_stage_current_saturation}, 'in-linear')
                end
            )
        end
    )

end


--UTILITY FUNCTIONS--

function boss.create()
    local b
    b = Boss_1()
    b:addElement(DRAW_TABLE.L4, "bosses")
    b:colorLightnessLoop()

    return b
end

--Return this boss radius
function boss.radius()
    return 100
end

--LOCAL FUNCTION--


--return function
return boss
