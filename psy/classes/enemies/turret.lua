require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--Local functions
local isInside

--TURRET CLASS--
--[[Turret enemy that goes to a target, and stays for a while shooting enemies]]

local enemy = {}

--Turret will got to a given target, stay for duration, then leave in the direction it came from
Turret = Class{
    __includes = {ENEMY},
    init = function(self, _x, _y, _speed_m, _e_speed_m, _radius, _score_mul, _enemy_spawn, _target_pos, _duration, _life, _number, _starting_angle, _rotation_angle, _shoot_fps)
        local color_table, score_value, dir

        self.color_stages = {
            HSL(Hsl.stdv(278,89,39)), --Violet (RYB) [100%-75%[
            HSL(Hsl.stdv(308,89,39)), --Bizantine [75%-50%[
            HSL(Hsl.stdv(339,89,39)), --Pictorial Carmine [50%-25%[
            HSL(Hsl.stdv(352,89,39))  --Lava [25%-0%]
        } --Colors the turret has in each % of life range

        self.enemy_spawn = _enemy_spawn --Enemy to shoot
        self.number = _number --Number of enemies to spawn
        score_value = self.number * self.enemy_spawn.score() --Score the turret will give
        self.e_speed_m = _e_speed_m

        self.starting_angle = _starting_angle --Starting angle to start shooting
        self.rotation_angle = _rotation_angle --Angle to rotate before spawning another enemy

        self.life = _life --How many hits this enemy can take before dying
        self.damage_taken = 0 --How many hits this enemy has taken

        self.shoot_tick = 3*_shoot_fps/4 --Enemy spawn "cooldown" timer
        self.shoot_fps = _shoot_fps --How fast to shoot enemies

        self.duration = _duration --How many seconds this enemy will stay in target before leaving (-1 if it will never leave)
        self.duration_tick = 0 --How many seconds this enemy has stayed in the target position

        self.target_pos = Vector(_target_pos.x,_target_pos.y) --Target this turret will go to
        self.reach_target = false --If enemy has reached its target
        self.leaving = false --If enemy should leave the screen

        dir = Vector(_x - _target_pos.x, _y - _target_pos.y) --Direction to leave the screen
        ENEMY.init(self, _x, _y, dir, _speed_m, _radius, _score_mul, nil, 270, score_value)

        self.inner_color = _enemy_spawn.indColor() --Color of outer circle (20% of radius)
        self.current_color = HSL(Hsl.stdv(278,89,39))
        self.color = HSL(Hsl.stdv(278,89,39))

        self.tp = "turret" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Turret:getHitAnimation()
    local t

    t = self

    --Remove previous transition
    if t.level_handles["gethithue"] then
        LEVEL_TIMER:cancel(t.level_handles["gethithue"])
    end
    if t.level_handles["gethitsaturation"] then
        LEVEL_TIMER:cancel(t.level_handles["gethitsaturation"])
    end
    if t.level_handles["gethittimer"] then
        LEVEL_TIMER:cancel(t.level_handles["gethittimer"])
    end
    if t.level_handles["gethitlightness"] then
        LEVEL_TIMER:cancel(t.level_handles["gethitlightness"])
    end

    --Make boss red when hit
    t.color.h = 255
    t.color.s = 226.95
    t.color.l = 125

    --Stay red for .05 seconds
    t.level_handles["gethittimer"] = LEVEL_TIMER:after(.05,
        function()
            --Go back to original lightness (99.45)
            t.level_handles["gethitlightness"] = LEVEL_TIMER:tween(.5, t.color, {l = 99.45}, 'in-linear')

            --Transition current onhit hue to turret current hue when saturation is 0
            t.level_handles["gethithue"] = LEVEL_TIMER:after(.25,
                function()
                    t.color.h = t.current_color.h
                end)
            --Drops saturation, then go to original saturation (226.95)
            t.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, t.color, {s = 0}, 'in-linear',
               function()
                   t.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, t.color, {s = 226.95}, 'in-linear')
                end
            )
        end
    )
end

function Turret:kill(gives_score, dont_explode)

    if self.death then return end

    self.damage_taken = self.damage_taken + 1

    --Find the quarter of life the turret has, and get the correspondent color
    self.current_color = self.color_stages[math.min(math.floor((self.damage_taken/self.life)/.25) + 1, 4)]
    self:getHitAnimation()

    --If turret is dead
    if self.damage_taken >= self.life then
        self.death = true
        self.color = HSL(Hsl.stdv(278,89,39)) --Reset color for the explosion
        if gives_score == nil then gives_score = true end --If this enemy should give score

        if gives_score then
            LM.giveScore(math.ceil(self.score_value*self.score_mul),"turret killed")
            FX.shake(.4,1.5)
            SFX.hit_simple:play()
        end

        if not dont_explode then
          FX.explosion(self.pos.x, self.pos.y, self.r, self.color, 30)
        end

    end


end

--Draws the enemy
function Turret:draw()
    local p, color

    p = self

    if not p.enter then return end


    --Draws the outer ring (from 100% to 50% of radius)
    Color.set(p.color)
    Draw_Smooth_Ring(p.pos.x, p.pos.y, p.r, p.r*.50)

    --Draws the inner circle (40% of radius)
    Color.set(p.inner_color)
    Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r*.4)

end

--Update this enemy
function Turret:update(dt)
    local o, angle, enemy

    o = self

    --Update movement if its leaving screen
    if o.leaving then
        o.pos = o.pos + dt*o.speed*o.speed_m
    end

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o:kill(false) end --Don't give score if enemy is killed by leaving screen
    end

    if o.reach_target then

        --Update shoot tick and if able, spawn enemy
        o.shoot_tick = o.shoot_tick + dt
        while o.shoot_tick >= o.shoot_fps do
            o.shoot_tick = o.shoot_tick - o.shoot_fps
            --Shoot enemies
            angle = o.starting_angle
            for i = 1, o.number do
                --Spawn the enemy with normal radius and same score multiplier as turret
                enemy = o.enemy_spawn.create(o.pos.x, o.pos.y, Vector(math.sin(angle), math.cos(angle)), o.e_speed_m, o.enemy_spawn.radius(), o.score_mul)
                enemy.enter = true
                angle = angle + o.rotation_angle --Rotate angle
            end
        end

        --Update duration tick and if able, start leaving
        o.duration_tick = o.duration_tick + dt
        if o.duration_tick >= o.duration then
            o.reach_target = false
            o.leaving = true
        end

    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, speed_m, e_speed_m,radius, score_mul, enemy_spawn, target_pos, duration, life, number, starting_angle, rotation_angle, shoot_fps)
    local e

    e = Turret(x, y, speed_m, e_speed_m, radius, score_mul, enemy_spawn, target_pos, duration, life, number, starting_angle, rotation_angle, shoot_fps)
    e:addElement(DRAW_TABLE.L4u)

    --Move turret to target position
    e.level_handles["go_to_target"] = LEVEL_TIMER:tween(e.pos:dist(e.target_pos)/(e.speedv*e.speed_m), e.pos, {x = e.target_pos.x, y = e.target_pos.y}, 'in-linear', function() e.reach_target = true end)

    return e
end

--Return this enemy radius
function enemy.radius()
    return 30
end

--Return the color for this enemy indicator
function enemy.indColor()
    return HSL(Hsl.stdv(278,89,39))
end

--LOCAL FUNCTION--

--Checks if a circular enemy has entered (even if partially) inside the game screen
function isInside(o)

    if    o.pos.x + o.r >= 0
      and o.pos.x - o.r <= WINDOW_WIDTH
      and o.pos.y + o.r >= 0
      and o.pos.y - o.r <= WINDOW_HEIGHT
      then
          return true
      end

    return false
end

--return function
return enemy
