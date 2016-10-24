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

--Behaviours--
local Stage_0, Stage_1, Stage_3, Stage_4

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
        self.color_stage_hue[1] = 77.88 --Color hue for stage 0 (green)
        self.color_stage_hue[2] = 77.88 --Color hue for stage 1 (green)
        self.color_stage_hue[3] = 42.48  --Color hue for stage 2 (yellow)
        self.color_stage_hue[4] = 152.22 --Color hue for stage 3 (blue)
        self.color_stage_hue[5] = 188.32 --Color hue for stage 4 (purple)
        self.color_stage_hue[6] = 228.79 --Color hue for stage 5 (pink)
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

        --Boss speed value
        self.speedv = 350 --Speed value
        self.target = _target --Target to move

        self.life = {} --How many hits this boss can take before changing state (this value is for stage 1)
        self.damage_taken = {} --How many hits this boss has taken
        for i = 1, 4 do
            self.life[i] = 10
            self.damage_taken[i] = 0
        end

        self.parts_alive = 4 --Number of parts alive

        self.invincible = true --If boss can get hit
        self.static = false --If boss can move
        self.stage = 0 --Stage this boss is


        self.behaviour = Stage_0 --What behaviour this boss is following
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
        love.graphics.stencil(stencil[i], "replace", 1)

        -- Only allow rendering on pixels which have a stencil value greater than 0, so will only draw pixels inside the rectangle
        love.graphics.setStencilTest("greater", 0)

        --Draw the circle
        love.graphics.setShader(Generic_Smooth_Circle_Shader)
        love.graphics.draw(PIXEL, x, y, 0, 2*p.r)
        love.graphics.setShader()

        --Stop using stencil
        love.graphics.setStencilTest()

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

    if b.stage >= 5 then return end

    b.damage_taken[id] = b.damage_taken[id] + 1
    b.bottom_lightness[id] = b.bottom_lightness[id] - .2
    b.upper_lightness[id] = b.upper_lightness[id] - .2
    b:getHitAnimation(id)

    if b.damage_taken[id] >= b.life[id] then
        b.parts_alive = b.parts_alive - 1

        b.level_handles["become_grey"..id] = LEVEL_TIMER:tween(1, b.part_colors[id], {s = 0}, 'in-linear')

        if b.parts_alive <= 0 then
            b.stage = b.stage + 1

            b:changeStage() --Change boss stage
        end

    end

end

--Color animation when boss gets hit
function Boss_2_Main:getHitAnimation(id)
    local b, diff

    b = self
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
                    b.part_colors[id].h = b.color_stage_hue[b.stage+1]
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
        --Reset stats
        for i = 1,4 do
            b.color_stage_current_saturation[i] = b.initial_saturation
            b.bottom_lightness[i] = 100 --Bottom color lightness in %
            b.upper_lightness[i] = 130 --Upper color lightness in %
            b.part_colors[i] = HSL(b.color_stage_hue[3], 0, b.bottom_lightness[i])
            b.level_handles["no_more_saturation"..i] = LEVEL_TIMER:tween(1, b.part_colors[i], {s = 255}, 'in-linear')
            b.damage_taken[i] = 0

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
        end

        b.invincible = true --Can't take damage

        --Stop moving
        b.static = true


    elseif b.stage == 3 then

    elseif b.stage == 4 then

    elseif b.stage == 5 then

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


--UTILITY FUNCTIONS--

function boss.create()
    local b

    b = Boss_2_Main()

    b:addElement(DRAW_TABLE.BOSSu, "bosses", "boss_2_main") --make boss appear
    for i = 1,4 do
        b:colorLightnessLoop(i) --Start color transition
    end

    b.target = Vector(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2)

    --Make boss move to the center
    b.level_handles["moving"] = LEVEL_TIMER:tween(b.pos:dist(b.target)/b.speedv, b.pos, {x = b.target.x, y = b.target.y}, 'in-linear',
        function()

            LM.boss_title("WILSO KAZUO MIZUTANI") --Boss title

            --After 2 seconds, make boss smaller in 1 second
            b.level_handles["moving_2"] = LEVEL_TIMER:after(2,
                function()
                    local _r
                    _r = 2*b.r/3
                    for id = 1, 4 do
                        local _x, _y
                        _x, _y = 2*(b.positions[id].x) / 3, 2*(b.positions[id].y) / 3
                        b.level_handles["shrink"..id] = LEVEL_TIMER:tween(1, b.positions[id], {x = _x, y = _y})
                        b.level_handles["turn_green"..id] = LEVEL_TIMER:tween(1, b.part_colors[id], {s = 255}, 'in-linear')
                    end
                    b.level_handles["shrink_radius"] = LEVEL_TIMER:tween(1, b, {r = _r}, 'in-linear')
                    --After shrinking, make boss vincible
                    b.level_handles["after_shrink"] = LEVEL_TIMER:after(1.1,
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


    return
end


--LOCAL FUNCTIONS--

--STAGES--

--Does nothing
Stage_0 = function(b, dt)
    --Does nothing
end

--Does nothing
Stage_1 = function(b, dt)
    --Does nothing
end


--return function
return boss
