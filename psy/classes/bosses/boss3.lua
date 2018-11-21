require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local F = require "formation"
local Indicator = require "classes.indicator"
local LM = require "level_manager"

--BOSS #3 CLASS--
--[[coisas]]

local boss = {}

Boss_3 = Class{
    __includes = {ELEMENT},
    init = function(self)
        ELEMENT.init(self)

        self.r = 30
        self.pos = Vector(WINDOW_WIDTH/2, -self.r)

        self.dir = Vector(0,1)
        self.speed = 160 --Speed boss moves
        self.turn_speed = math.pi/4 --Speed boss turns
        self.turn_to = "left" --Which direction the snake should turn

        local segments_size = 10
        local x, y = self.pos.x, self.pos.y
        self.segments = {}
        for i = 1, segments_size do
            self.segments[i] = {
                pos = Vector(x, y),
                damage_taken = 0
            }
            x = x - self.dir.x*2*self.r
            y = y - self.dir.y*2*self.r
        end

        self.stage = 1 --Which stage this boss is in
    end
}

function Boss_3:draw()
    if self.stage <= 1 then
        --Draw each segment
        Color.set(Color.red())
        for i, seg in ipairs(self.segments) do
            Draw_Smooth_Circle(seg.pos.x, seg.pos.y, self.r)
        end
    end
end

--Behaviours--

local behaviours = {}
function Boss_3:update(dt)
    behaviours[self.stage](self,dt)
end

behaviours[1] = function(boss,dt)
    local head_seg = boss.segments[1]
    local psycho = Util.findId("psycho")

    --Update direction
    if psycho then
        local dir = (psycho.pos - head_seg.pos)
        local angle = boss.dir:angleTo(dir)%(2*math.pi)
        local angle_limit = math.pi/3

        --Only change direction if further from a limit
        --to create centipede-like movement
        if angle >= angle_limit and angle <= 2*math.pi - angle_limit then
            --Psycho is on the right of boss
            if angle <= math.pi then
                boss.turn_to = "right"
            --Psycho is on the left of boss
            else
                boss.turn_to = "left"
            end
        end

        if boss.turn_to == "right" then
            boss.dir:rotateInplace(dt*boss.turn_speed*-math.pi/2)
        elseif boss.turn_to == "left" then
            boss.dir:rotateInplace(dt*boss.turn_speed*math.pi/2)
        else
            error("Not a valid direction for boss3 to turn to")
        end

    end

    --Update head segment
    head_seg.pos = head_seg.pos + boss.dir*boss.speed*dt

    --Update all other segments
    for i = 2, #boss.segments do
        local this_seg = boss.segments[i]
        local next_seg = boss.segments[i-1]
        local dir = (next_seg.pos - this_seg.pos):normalized()
        this_seg.pos = next_seg.pos - dir*(2*boss.r-2)
    end
end

--Collision--
function Boss_3:getHit(arg)
end

function boss.create()

    local b = Boss_3()
    b:addElement(DRAW_TABLE.BOSS, "bosses") --make boss appear

    return b
end

--return function
return boss
