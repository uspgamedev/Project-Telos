require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local Aim_Functions = require "classes.psycho_aim"
--INDICATOR CLASS--
--[[Indicates when something is about to happen]]--

local indicator = {}

--------------------
--Useful Functions--
--------------------

--Get the center, direction to face and side length of a triangle. Return all vertex positions
function getPositions(center, dir, side)
    local p1, p2, p3, ndir

    ndir = dir:normalized() --Normalized direction

    --Get vertex positions
    p1 = Vector(center.x + ndir.x * ((1.8*side)/math.sqrt(3)), center.y + ndir.y * (1.8*side/math.sqrt(3)) ) --"Pointing" vertex
    p2 = Vector(center.x + ndir:rotated((2*math.pi)/3).x*(side/math.sqrt(3)), center.y + ndir:rotated((2*math.pi)/3).y*(side/math.sqrt(3))) --Other vertex
    p3 = Vector(center.x + ndir:rotated((-2*math.pi)/3).x*(side/math.sqrt(3)), center.y + ndir:rotated((-2*math.pi)/3).y*(side/math.sqrt(3))) --Remaining vertex

    return p1,p2,p3
end

-------------------
--Enemy Indicator--
-------------------

--Indicates where an enemy will appear, with a triangle. After _duration, disappears.
--Pass only the center of the triangle, the direction to face, and side length
Enemy_Indicator = Class{
    __includes = {TRIANGLE},
    init = function(self, _center_pos, _dir, _side, _color, _duration, _follow_psycho)
        local p1, p2, p3

        p1, p2, p3 = getPositions(_center_pos, _dir, _side)
        TRIANGLE.init(self, p1, p2, p3, _color) --Set atributes

        self.center = Vector(_center_pos.x, _center_pos.y)
        self.side = _side

        self.tick = 0 --Time this indicator has been "alive"
        self.duration = _duration or 1

        self.follow_psycho = _follow_psycho or false

        --Create a full triangle when is following psycho
        if self.follow_psycho then
            self.mode = "fill"
        else
            self.mode = "line"
        end

        self.tp = "enemy_indicator" --Type of this class
    end
}

--CLASS FUNCTIONS--

--If indicator is following psycho, update his positions
function Enemy_Indicator:update(dt)
    local i, dir, p

    i = self

    --Ticks the indicator
    i.tick = i.tick + dt

    if i.tick >= i.duration then
        i.death = true
    end

    p = Util.findId("psycho")

    if not i.follow_psycho or not p then return end


    dir = Vector(p.pos.x - i.center.x, p.pos.y - i.center.y)

    i.p1, i.p2, i.p3 = getPositions(i.center, dir, i.side)

end

--Creates an aim that remains on screen for 6 seconds
function Enemy_Indicator:create_aim()
    local aim, h1, h2

    aim, h1, h2 = Aim_Functions.create_indicator(self.center.x, self.center.y, Color.red())
    table.insert(self.handles, h1)
    table.insert(self.handles, h2)

end

--UTILITY FUNCTIONS--

--Create an enemy indicator from a margin in the screen, and after duration, create the enemy
function indicator.create_enemy(enemy, pos, dir, following, side, duration, speed_m, radius, st)
    local i, center, margin, handle, color

    center = Vector(pos.x, pos.y)
    side = side or 20
    margin = side/2 + 1
    color = enemy.indColor()

    --Put indicator center inside the screen
    if pos.x < margin then
        center.x = margin
    elseif pos.x > ORIGINAL_WINDOW_WIDTH - margin then
        center.x = ORIGINAL_WINDOW_WIDTH - margin
    end
    if pos.y < margin then
        center.y = margin
    elseif pos.y > ORIGINAL_WINDOW_HEIGHT - margin then
        center.y = ORIGINAL_WINDOW_HEIGHT - margin
    end

    st = st or "enemy_indicator" --subtype

    i = Enemy_Indicator(center, dir, side, color, duration, following)

    i:addElement(DRAW_TABLE.L5, st)

    i.color.a = 0
    --Fade in the indicator
    LEVEL_TIMER:tween(.3, i.color, {a = 255}, 'in-linear')

    if not following then
        --Create the enemy after duration
        handle = LEVEL_TIMER:after(duration,
            function()
                enemy.create(pos.x, pos.y, dir, speed_m, radius)
            end
        )
        table.insert(INDICATOR_HANDLES, handle)
    else
        --Create the enemy after duration getting psycho current position
        handle = LEVEL_TIMER:after(duration,
            function()
                local p, position

                p  = Util.findId("psycho")
                position = Vector(pos.x, pos.y)

                enemy.create(pos.x, pos.y, Vector(p.pos.x - pos.x, p.pos.y - pos.y), speed_m, radius)
            end
        )
        table.insert(INDICATOR_HANDLES, handle)

    end

    return i
end

--Return functions
return indicator