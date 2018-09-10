require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--SNAKE CLASS--
--[[Snake made of circles that follows a path]]

local enemy = {}

Snake = Class{
    __includes = {ELEMENT, ENEMY},
    init = function(self, _segments, _positions, _speed_m, _radius, _score_mul)
        local color_table = {
            HSL(Hsl.stdv(201,100,50)),
            HSL(Hsl.stdv(239,100,26)),
            HSL(Hsl.stdv(220,78,30)),
            HSL(Hsl.stdv(213,100,54))
        }

        ENEMY.init(self,  nil, nil, nil, _speed_m, _radius, _score_mul, color_table, 270, nil)

        self.segment_score =  10 --Score each segment gives when killed
        self.full_snake_score_bonus = _segments*5 --Bonus score added when full snake is dead

        self.positions = _positions --Target positions snake will travel to

        local dir = (Vector(unpack(_positions[1])) - Vector(unpack(_positions[2]))):normalized()
        local x, y = unpack(_positions[1])

        self.segments = {}
        for i = 1, _segments do
            self.segments[i] = {
                pos = Vector(x, y),
                enter = false, --If enemy has entered the screen
                target_pos_idx = 2, --Start going to second position
                dead = false,
            }
            x = x + dir.x*2*self.r
            y = y + dir.y*2*self.r
        end

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
        end
        if seg.dead == "dead" then
            number_of_dead = number_of_dead + 1
        end
    end

    --Check if full snake is dead
    if number_of_dead >= #self.segments then
        self.death = true
        if gives_score and self.full_snake_score_bonus*self.score_mul > 0 then
                LM.giveScore(math.ceil(self.full_snake_score_bonus*self.score_mul))
        end
        FX.shake(.4,1.5)
    end

end

--Update this enemy
function Snake:update(dt)
    local o

    o = self

    for i, seg in ipairs(o.segments) do
        --Update movement, going to next target
        --o.pos = o.pos + dt*o.speed*o.speed_m

        --Check if segment entered then leaved the game screen
        if not seg.enter then
            if isInside(o, i) then seg.enter = true end
        else
            if not isInside(o, i) then
                seg.dead = "marked for death"
                o:kill(false, true) end --Don't give score if enemy is killed by leaving screen
        end
    end
end

function Snake:draw()
    local o = self

    --Draws each segment
    for i, seg in ipairs(o.segments) do
        if seg.enter then
            Color.set(o.color)
            Draw_Smooth_Circle(seg.pos.x, seg.pos.y, o.r)
        end
    end
end

--UTILITY FUNCTIONS--

function enemy.create(segments, positions, speed_m, radius, score_mul)
    local e

    e = Snake(segments, positions, speed_m, radius, score_mul)
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
    return HSL(Hsl.stdv(227,88.8,49.2))
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
