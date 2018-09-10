require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--Local functions
local isInside

--SNAKE CLASS--
--[[Snake made of circles that follows a path]]

local enemy = {}

Snake = Class{
    __includes = {ELEMENT, ENEMY},
    init = function(self, _segments, _positions, _life, _speed_m, _radius, _score_mul)
        local color_table = {
            HSL(Hsl.stdv(103, 83, 47)),
            HSL(Hsl.stdv(103,64,42)),
            HSL(Hsl.stdv(103,71,56)),
            HSL(Hsl.stdv(123,100,42))
        }

        ENEMY.init(self,  nil, nil, nil, _speed_m, _radius, _score_mul, color_table, 270, nil)

        self.segment_score =  10 --Score each segment gives when killed
        self.full_snake_score_bonus = _segments*5 --Bonus score added when full snake is dead

        self.positions = {} --Target positions snake will travel to
        for i, pos in ipairs(_positions) do
            --Transform array into vector
            self.positions[i] = Vector(pos[1], pos[2])
        end

        self.segments_life = _life --How much hits it takes to kill an active segment

        self.on_hit = false --If ball got hit and should play use on_hit_color
        self.on_hit_color = Color.black()

        local dir = (Vector(unpack(_positions[1])) - Vector(unpack(_positions[2]))):normalized()
        local x, y = unpack(_positions[1])
        self.segments = {}
        for i = 1, _segments do
            self.segments[i] = {
                pos = Vector(x, y),
                enter = false, --If enemy has entered the screen
                target_pos_idx = 2, --Start going to second position
                dead = false,
                active = false, --If this is the active segment,
                damage_taken = 0
            }
            x = x + dir.x*2*self.r
            y = y + dir.y*2*self.r
        end
        self.segments[1].active = true --Make first active

        self.tp = "snake" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Snake:kill(gives_score, dont_explode)

    if self.death then return end
    if gives_score == nil then gives_score = true end --If this enemy should give score

    --Check each segment and kill all marked for death
    local number_of_dead = 0
    for i, seg in ipairs(self.segments) do
        if seg.dead == "marked for death" then

            if not dont_explode then
              FX.explosion(seg.pos.x, seg.pos.y, self.r, self.color)
            end
            if gives_score and self.segment_score*self.score_mul > 0 then
                LM.giveScore(math.ceil(self.segment_score*self.score_mul))
                FX.shake(.1,.09)
                SFX.hit_simple:play()
            end
            seg.dead = "dead"
            --Make next head active
            if i < #self.segments then self.segments[i+1].active = true end
        end
        if seg.dead == "dead" then
            number_of_dead = number_of_dead + 1
        end
    end

    --Check if full snake is dead
    if number_of_dead >= #self.segments then
        self.enter = false
        self.death = true
        if gives_score and self.full_snake_score_bonus*self.score_mul > 0 then
            LM.giveScore(math.ceil(self.full_snake_score_bonus*self.score_mul), "snake killed")
            FX.shake(.4,1.5)
        end
    end

end

--Update this enemy
function Snake:update(dt)
    local o

    o = self

    for i, seg in ipairs(o.segments) do
        if not seg.dead then
            --Update movement, going to next target
            local distance = dt*o.speedv*o.speed_m --Maximum distance it can travel
            while distance > 0 and seg.target_pos_idx > 0 do
                local vec = o.positions[seg.target_pos_idx] - seg.pos
                local dir, len = vec:normalized(), vec:len()
                if len > distance then
                    --Cant reach next target position, move all it can
                    seg.pos = seg.pos + dir*distance
                    distance = 0
                else
                    --Arrived at next target position, go to target position
                    seg.pos = seg.pos + dir*len
                    seg.target_pos_idx = (seg.target_pos_idx+1)%(#o.positions+1)
                    distance = distance - len
                end
            end

            --Check if segment entered then leaved the game screen
            if not seg.enter then
                if isInside(o, i) then seg.enter = true; o.enter = true end
            else
                if not isInside(o, i) then
                    --Don't give score if enemy is killed by leaving screen
                    seg.dead = "marked for death"
                    o:kill(false, true)
                end
            end
        end
    end
end

function Snake:draw()
    local o = self
    --Draws each segment
    for i, seg in ipairs(o.segments) do
        if seg.enter and seg.dead ~= "dead" then
            if seg.active then
                if o.use_on_hit_color then
                    Color.set(o.on_hit_color)
                else
                    Color.set(o.color)
                end
            else
                local c = Color.black()
                Color.copy(c, o.color)
                c.s = c.s/12
                Color.set(c)
            end
            Draw_Smooth_Circle(seg.pos.x, seg.pos.y, o.r)
        end
    end
end

--Check collision with circular object that has a radius
function Snake:collides(o)
    local e = self
    --Check collision with all segments
    local collided_with_something = false
    for i, seg in ipairs(e.segments) do
        if not seg.dead then
            local dx = seg.pos.x - o.pos.x
            local dy = seg.pos.y - o.pos.y
            local dr
            --In case of psycho, check collision with his collision radius
            if o.tp == "psycho" then
                dr = e.r + o.collision_r
            else
                dr = e.r + o.r
            end

            if (dx*dx + dy*dy) < dr*dr then
                collided_with_something = true
                if o.tp == "bullet" and seg.active then
                    seg.damage_taken = seg.damage_taken + 1
                    if seg.damage_taken >= self.segments_life then
                        seg.dead = "marked for death"
                    else
                        e:getHitAnimation()
                    end
                end
            end
        end
    end

    return collided_with_something
end

function Snake:getHitAnimation()
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

    t.use_on_hit_color = true

    --Make boss red when hit
    t.on_hit_color.h = 255
    t.on_hit_color.s = 226.95
    t.on_hit_color.l = 125

    --Stay red for .05 seconds
    t.level_handles["gethittimer"] = LEVEL_TIMER:after(.05,
        function()
            --Go back to original lightness
            t.level_handles["gethitlightness"] = LEVEL_TIMER:tween(.5, t.on_hit_color, {l = t.color.l}, 'in-linear')

            --Transition current onhit hue to snake current hue when saturation is 0
            t.level_handles["gethithue"] = LEVEL_TIMER:after(.25,
                function()
                    t.on_hit_color.h = t.color.h
                end)
            --Drops saturation, then go to original saturation
            t.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, t.on_hit_color, {s = 0}, 'in-linear',
               function()
                   t.level_handles["gethitsaturation"] = LEVEL_TIMER:tween(.25, t.on_hit_color, {s = t.color.s}, 'in-linear',
                    function()
                        t.use_on_hit_color = false
                    end)
                end
            )
        end
    )
end

--UTILITY FUNCTIONS--

function enemy.create(segments, positions, life, speed_m, radius, score_mul)
    local e

    e = Snake(segments, positions, life, speed_m, radius, score_mul)
    e:addElement(DRAW_TABLE.L4)
    e:startColorLoop()

    return e
end

--Return this enemy default radius
function enemy.radius()
    return 20
end

--Return the color for this enemy indicator
function enemy.indColor()
    return HSL(Hsl.stdv(123,100,42))
end

--Return the default score this enemy gives when killed
function enemy.score()
    return 10
end

--LOCAL FUNCTION--

--Checks if a snake segment has entered (even if partially) inside the game screen
function isInside(snake, segment_index)
    local o = snake.segments[segment_index]
    if    o.pos.x + snake.r >= 0
      and o.pos.x - snake.r <= WINDOW_WIDTH
      and o.pos.y + snake.r >= 0
      and o.pos.y - snake.r <= WINDOW_HEIGHT
      then
          return true
      end

    return false
end

--return function
return enemy
