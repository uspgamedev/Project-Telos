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

-------------------------
--ENEMY INDICATOR BATCH--
-------------------------

--Enemy indicator batch that holds a group of enemy_indicators, and deletes them after a while, creating the enemies
Enemy_Indicator_Batch = Class{
    __includes = {ELEMENT},
    init = function(self, _endtime)
        ELEMENT.init(self)

        self.batch = {}
        self.endtime = _endtime
        self.time = 0
        self.spawn = true --If this batch should spawn the enemies from the indicators or not

        self.tp = "enemy_indicator_batch"
    end
}

--CLASS FUNCTIONS--

function Enemy_Indicator_Batch:update(dt)

    if self.death then return end

    self.time = self.time + dt
    if (self.time >= self.endtime) then
        self.death = true
    end

end

--Destroy self, indicators and create enemies
function Enemy_Indicator_Batch:destroy()
    local p

    if self.batch then
        if self.spawn then
            for _, ind in pairs(self.batch) do

                if not ind.death then
                    ind.death = true
                    if not ind.follow_psycho then

                        ind.enemy.create(ind.enemy_pos.x, ind.enemy_pos.y, ind.enemy_dir, ind.enemy_speed_m, ind.enemy_radius, ind.enemy_score_mul, ind.enemy_game_win_idx)

                    else

                        p  = Util.findId("psycho")
                        if p then
                            local win = WINM.getWin(ind.enemy_game_win_idx)
                            ind.enemy.create(ind.enemy_pos.x, ind.enemy_pos.y, Vector(p.pos.x + win.x - ind.enemy_pos.x, p.pos.y + win.y - ind.enemy_pos.y), ind.enemy_speed_m, ind.enemy_radius, ind.enemy_score_mul, ind.enemy_game_win_idx)
                        else
                            ind.enemy.create(ind.enemy_pos.x, ind.enemy_pos.y, Vector(WINDOW_WIDTH/2 - ind.enemy_pos.x, WINDOW_HEIGHT/2 - ind.enemy_pos.y), ind.enemy_speed_m, ind.enemy_radius, ind.enemy_score_mul, ind.enemy_game_win_idx)
                        end
                    end
                end
            end
        end
    end
    ELEMENT.destroy(self)
end


function Enemy_Indicator_Batch:put(indicator)
    table.insert(self.batch, indicator)
end

--UTILITY FUNCTIONS--

function indicator.create_enemy_batch(endtime)
    local batch

    batch = Enemy_Indicator_Batch(endtime)
    batch:setSubTp("enemy_indicator_batch")

    return batch
end

-------------------
--Enemy Indicator--
-------------------

--Indicates where an enemy will appear, with a triangle. After _duration, disappears.
--Pass only the center of the triangle, the direction to face, and side length
Enemy_Indicator = Class{
    __includes = {TRIANGLE},
    init = function(self, _center_pos, _dir, _side, _color, _follow_psycho, _game_win_idx)
        local p1, p2, p3

        p1, p2, p3 = getPositions(_center_pos, _dir, _side)
        TRIANGLE.init(self, p1, p2, p3, _color) --Set atributes

        self.center = Vector(_center_pos.x, _center_pos.y)
        self.side = _side

        self.follow_psycho = _follow_psycho or false

        --Create a full triangle when is following psycho
        if self.follow_psycho then
            self.mode = "fill"
        else
            self.mode = "line"
        end

        self.game_win_idx = _game_win_idx

        self.tp = "enemy_indicator" --Type of this class
    end
}

--CLASS FUNCTIONS--

--If indicator is following psycho, update his positions
function Enemy_Indicator:update(dt)
    local i, dir, p

    i = self

    p = Util.findId("psycho")

    if not i.follow_psycho or not p then return end

    local win = WINM.getWin(self.game_win_idx)
    dir = Vector(p.pos.x + win.x - i.center.x, p.pos.y + win.y - i.center.y)

    i.p1, i.p2, i.p3 = getPositions(i.center, dir, i.side)

end

--Creates an aim that remains on screen for 6 seconds
function Enemy_Indicator:create_aim()
    local aim, h1, h2

    aim, h1, h2 = Aim_Functions.create_indicator(self.center.x, self.center.y, Color.red(), self.game_win_idx)
    table.insert(self.handles, h1)
    table.insert(self.handles, h2)

end

--UTILITY FUNCTIONS--

--Create an enemy indicator from a margin in the screen, and after duration, create the enemy
function indicator.create_enemy(enemy, pos, dir, following, side, speed_m, radius, score_mul, game_win_idx, st)
    local i, center, margin, handle, color

    center = Vector(pos.x, pos.y)
    side = side or 20
    margin = side/2 + 4
    color = enemy.indColor()

    local win = WINM.getWin(game_win_idx)

    --Put indicator center inside the screen
    local on_left = pos.x < win.x + margin
    local on_right = pos.x > win.x + win.w - margin
    local on_top = pos.y < win.y + margin
    local on_bottom = pos.y > win.y + win.h - margin
    local left_border = win.x + margin
    local right_border =  win.x + win.w - margin
    local top_border = win.y + margin
    local bottom_border = win.y + win.h - margin
    local target_border = nil --Determine which border the enemy will hit
    local abs_dx = math.abs(dir.x)
    local abs_dy = math.abs(dir.y)
    local lamb
    if on_left and on_top then
        if abs_dy >= abs_dx then
            lamb = (left_border - pos.x)/dir.x
        else
            lamb = (top_border - pos.y)/dir.y
        end
    elseif on_left and on_bottom then
        if abs_dy >= abs_dx then
            lamb = (left_border - pos.x)/dir.x
        else
            lamb = (bottom_border - pos.y)/dir.y
        end
    elseif on_right and on_top then
        if abs_dy >= abs_dx then
            lamb = (right_border - pos.x)/dir.x
        else
            lamb = (top_border - pos.y)/dir.y
        end
    elseif on_right and on_bottom then
        if abs_dy >= abs_dx then
            lamb = (right_border - pos.x)/dir.x
        else
            lamb = (bottom_border - pos.y)/dir.y
        end
    elseif on_left then
        lamb = (left_border - pos.x)/dir.x
    elseif on_right then
        lamb = (right_border - pos.x)/dir.x
    elseif on_top then
        lamb = (top_border - pos.y)/dir.y
    elseif on_bottom then
        lamb = (bottom_border - pos.y)/dir.y
    end

    if lamb then
        print(on_left, on_right, on_top, on_bottom)
        center.x = center.x + lamb*dir.x
        center.y = center.y + lamb*dir.y
    else
        return
        error("Enemy was spawned inside the game area")
    end

    st = st or "enemy_indicator" --subtype

    i = Enemy_Indicator(center, dir, side, color, following, game_win_idx)

    i:addElement(DRAW_TABLE.L5, st)

    i.color.a = 0
    --Fade in the indicator
    i.level_handles["fadein"] = LEVEL_TIMER:tween(.3, i.color, {a = 255}, 'in-linear')

    --Set up enemy information so it can be later created
    i.enemy_pos = pos
    i.enemy_dir = dir
    i.enemy_speed_m = speed_m
    i.enemy_radius = radius
    i.enemy_score_mul = score_mul
    i.enemy_game_win_idx = game_win_idx
    i.enemy = enemy

    return i
end

--Create an enemy indicator from a margin in the screen, and after duration, create the turret enemy
function indicator.create_enemy_turret(turret, pos, speed_m, e_speed_m, radius, score_mul, enemy, target_pos, duration, life, number, start_angle, rot_angle, fps, side, ind_duration, game_win_idx, st)
    local i, center, margin, handle, color

    center = Vector(pos.x, pos.y)
    side = side or 20
    margin = side/2 + 1
    color = turret.indColor()

    local win = WINM.getWin(game_win_idx)
    --Put indicator center inside the screen
    if pos.x < win.x + margin then
        center.x = win.x + margin
    elseif pos.x > win.x + win.w - margin then
        center.x = win.x + win.w - margin
    end
    if pos.y < win.y + margin then
        center.y = win.y + margin
    elseif pos.y > win.y + win.h - margin then
        center.y = win.y + win.h - margin
    end

    st = st or "enemy_indicator" --subtype

    i = Enemy_Indicator(center, Vector(target_pos.x - pos.x, target_pos.y - pos.y), side, color, false, game_win_idx)

    i:addElement(DRAW_TABLE.L5, st)

    i.color.a = 0
    --Fade in the indicator
    i.level_handles["fadein"] = LEVEL_TIMER:tween(.3, i.color, {a = 255}, 'in-linear')

    i.level_handles["create_enemy"] = LEVEL_TIMER:after(ind_duration,
        function()
            i.death = true --Remove the indicator

            turret.create(pos.x, pos.y, speed_m, e_speed_m, radius, score_mul, enemy, target_pos, duration, life, number, start_angle, rot_angle, fps, game_win_idx) --Create the turret

        end
    )

    return i
end

--Create an enemy indicator from a margin in the screen, and after duration, create a snake enemy
function indicator.create_enemy_snake(snake, segments, pos, life, speed_m, radius, score_mul, side, ind_duration, game_win_idx, st, id)
    local i, center, margin, handle, color

    center = Vector(pos[1][1], pos[1][2])
    side = side or 20
    margin = side/2 + 1
    color = snake.indColor()

    local win = WINM.getWin(game_win_idx)
    --Put indicator center inside the screen
    if pos[1][1] < win.x + margin then
        center.x = win.x + margin
    elseif pos[1][1] > win.x + win.w - margin then
        center.x = win.x + win.w - margin
    end
    if pos[1][2] < win.y + margin then
        center.y = win.y + margin
    elseif pos[1][2] > win.y + win.h - margin then
        center.y = win.y + win.h - margin
    end

    st = st or "enemy_indicator" --subtype

    i = Enemy_Indicator(center, Vector(pos[2][1] - pos[1][1], pos[2][2] - pos[1][2]), side, color, false, game_win_idx)

    i:addElement(DRAW_TABLE.L5, st)

    i.color.a = 0
    --Fade in the indicator
    i.level_handles["fadein"] = LEVEL_TIMER:tween(.3, i.color, {a = 255}, 'in-linear')

    i.level_handles["create_enemy"] = LEVEL_TIMER:after(ind_duration,
        function()
            i.death = true --Remove the indicator
            snake.create(segments, pos, life, speed_m, radius, score_mul, game_win_idx, id) --Create the turret
        end
    )

    return i
end


----------------------
--Rotating Indicator--
----------------------

--Indicates where an enemy will appear, with a triangle. After _duration, disappears.
--Pass only the center of the triangle, the direction to face, and side length
--Rotates around a given circle radius, following psycho
Rotating_Indicator = Class{
    __includes = {TRIANGLE},
    init = function(self, _side, _color, _duration, _radius, _circle_center)
        local p1, p2, p3, p, center

        p = Util.findId("psycho")
        self.radius = _radius --Radius of circle this indicator is rotating from
        self.circle_center = Vector(_circle_center.x, _circle_center.y) --Center of circle this indicator is rotating from
        if p then
            self.dir = Vector(p.pos.x - self.circle_center.x, p.pos.y - self.circle_center.y)
        else
            self.dir = Vector(WINDOW_WIDTH/2 - self.circle_center.x, WINDOW_HEIGHT/2 - self.circle_center.y)
        end
        self.center = Vector(self.circle_center.x + self.radius*self.dir:normalized().x, self.circle_center.y + self.radius*self.dir:normalized().y)--Center of triangle
        self.side = _side

        p1, p2, p3 = getPositions(self.center, self.dir, self.side)
        TRIANGLE.init(self, p1, p2, p3, _color) --Set atributes


        self.tick = 0 --Time this indicator has been "alive"
        self.duration = _duration or 1

        --Create a full triangle when is following psycho
        self.mode = "fill"
        self.mode = "line"

        self.tp = "rotating_indicator" --Type of this class
    end
}

--CLASS FUNCTIONS--

--If indicator is following psycho, update his positions
function Rotating_Indicator:update(dt)
    local i, dir, p

    i = self

    --Ticks the indicator
    i.tick = i.tick + dt

    if i.tick >= i.duration then
        i.death = true
    end

    p = Util.findId("psycho")
    if p then
        i.dir = Vector(p.pos.x - i.circle_center.x, p.pos.y - i.circle_center.y)
    else
        i.dir = Vector(WINDOW_WIDTH/2 - i.circle_center.x, WINDOW_HEIGHT/2 - i.circle_center.y)
    end
    i.center = Vector(i.circle_center.x + i.radius*i.dir:normalized().x, i.circle_center.y + i.radius*i.dir:normalized().y)--Center of triangle

    i.p1, i.p2, i.p3 = getPositions(i.center, i.dir, i.side)

end

--UTILITY FUNCTIONS--

--Create an enemy indicator from a margin in the screen, and after duration, create the enemy
function indicator.create_rotating(side, color, duration, radius, circle_center, st)
    local i

    st = st or "rotating_indicator" --subtype

    i = Rotating_Indicator(side, color, duration, radius, circle_center)
    i:addElement(DRAW_TABLE.L5, st)

    i.color.a = 0
    --Fade in the indicator
    i.level_handles["fadein"] = LEVEL_TIMER:tween(.3, i.color, {a = 255}, 'in-linear')

    return i
end

--Return functions
return indicator
