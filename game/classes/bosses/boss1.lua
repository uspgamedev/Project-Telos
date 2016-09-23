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
        self.initial_saturation = 160 --Inicial color saturation in %
        self.initial_lightness = 115 --Inicial color lightness in %
        self.color_stage_hue = {}
        self.color_stage_hue[1] = 77.88 --Color hue for stage 1 (green)
        self.color_stage_hue[2] = 42.48  --Color hue for stage 2 (yellow)
        self.color_stage_hue[3] = 152.22 --Color hue for stage 3 (blue)
        self.color_stage_hue[4] = 188.32 --Color hue for stage 4 (purple)
        self.color_onhit_hue = 254 --Color hue for when boss is hit (red)
        self.color_onhit_lightness = 115 --Color lightness for when boss is hit
        self.color_stage_current_lightness = self.initial_lightness --Current stage color hue this boss has
        self.color_dying_target_lightness = 50 --Target hue the boss is reaching whenever he gets hit (red)

        color = HSL(self.color_stage_hue[1], self.initial_saturation, self.initial_lightness) --Color of boss


        self.color_pulse_duration = 2 --Duration between color saturation transitions

        CIRC.init(self, ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2, r, color, nil, "fill") --Set atributes
        ELEMENT.setSubTp(self, "boss")

        --Normalize direction and set speed
        self.speedv = 250 --Speed value
        self.speed_m =  1 --Speed multiplier
        self.speed = Vector(0, 0) --Speed vector

        self.life = 25 --How many hits this boss can take before changng state
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
    if b.handles["gethitlightness"] then
        LEVEL_TIMER:cancel(b.handles["gethitlightness"])
    end
    if b.handles["saturation"] then
        COLOR_TIMER:cancel(b.handles["saturation"])
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

--Keeps transitioning boss color saturation from values initial_saturation to 255, and vice-versa
function Boss_1:colorSaturationLoop()
    local b

    b = self

    --Remove previous timer
    if b.handles["saturation"] then
        COLOR_TIMER:cancel(b.handles["saturation"])
    end

    --Start saturation transition from initial_saturation to 255
    b.handles["saturation"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {s = 255}, 'in-linear',
        --After reaching 255, start saturation transition from 255 to initial_saturation
        function()
            b.handles["saturation"] = COLOR_TIMER:tween(b.color_pulse_duration/2, b.color, {s = b.initial_saturation}, 'in-linear',
                --After reaching initial_saturation, start eveything again
                function()
                    b:colorSaturationLoop()
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
    print("hit")
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
    if b.handles["gethitlightness"] then
        LEVEL_TIMER:cancel(b.handles["gethitlightness"])
    end

    --Make boss red when hit
    b.color.h = b.color_onhit_hue
    b.color.l = b.color_onhit_lightness

    --Update boss stage current lightness
    diff = b.damage_taken/b.life * (b.color_dying_target_lightness - b.initial_lightness) --Calculate how much of the difference between target lightness and initial stage color lightness the boss has reached
    b.color_stage_current_lightness = b.initial_lightness + diff --Make current hue the proper color

    --Transition current onhit hue to boss stage current hue
    b.handles["gethithue"] = LEVEL_TIMER:after(1,
        function()
            b.handles["gethithue"] = LEVEL_TIMER:tween(.01, b.color, {h = b.color_stage_hue[b.stage]}, 'in-linear')
        end
    )
    --Goes to super light, then go to actual current lightness
    b.handles["gethitlightness"] = LEVEL_TIMER:tween(1, b.color, {l = 230}, 'in-linear',
        function()
            b.handles["gethitlightness"] = LEVEL_TIMER:tween(1, b.color, {l = b.color_stage_current_lightness}, 'in-linear')
        end
    )

end


--UTILITY FUNCTIONS--

function boss.create()
    local b
    b = Boss_1()
    b:addElement(DRAW_TABLE.L4, "bosses")
    b:colorSaturationLoop()

    return b
end

--Return this boss radius
function boss.radius()
    return 100
end

--LOCAL FUNCTION--


--return function
return boss
