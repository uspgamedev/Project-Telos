local Psycho = require "classes.psycho"
local Util = require "util"
--MODULE TO CREATE ENEMY FORMATIONS--

local formation = {}


--[[
Formation of a line of enemies coming from the left or right. with several
side: "left" ('l') or "right" ('r'), side that the enemies come from
mode: mode to apply the formation. As follows:
    --center (default): place enemies from the center of the screen, spaced with enemy margin and can be moved with screen_margin
    --distribute: place balls equally distributed on the screen side
    --top: start placing from the top , with an optional screen margin
    --bottom: start placing from the bottom, with an optional screen margin
number: number of enemies in the formation
enemy: enemy (or enemies) to be created
enemy_x_margin: horizontal margin between enemies
enemy_y_margin: vertical margin between enemies
screen_margin: margin from screen (or offset) the enemies are to be created
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
]]
function formation.fromHorizontal(a)
    local x, y, dir, half, p, enemy_table_size, max_r, current_enemy


    enemy_table_size = Util.tableLen(a.enemy)

    --Find the biggest radius between enemies
    max_r = a.enemy[1].radius()
    for i=2,enemy_table_size do
        if a.enemy[i].radius() > max_r then
            max_r = a.enemy[i].radius()
        end
    end

    --Default values
    p = Psycho.get()
    a.screen_margin = a.screen_margin or 0
    a.enemy_x_margin = a.enemy_x_margin or 0
    a.enemy_y_margin = a.enemy_y_margin or 10 + 2*max_r
    a.number = a.number or 3
    a.speed_m = a.speed_m or 1
    a.dir_follow = a.dir_follow or false

    if a.side == "left" or a.side == "l" then
        dir = Vector(1,0)
        x = -5 -max_r
    elseif a.side == "right" or a.side == "r" then
        dir = Vector(-1,0)
        x = ORIGINAL_WINDOW_WIDTH + 5 + max_r
    end
    ---------
    --MODES--
    ---------

    --Center mode
    if     a.mode == "center" then
        half = math.floor(a.number/2)
        y = ORIGINAL_WINDOW_HEIGHT/2 - (a.number-1)/2*a.enemy_y_margin + a.screen_margin
        --Placing from the center
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x - math.abs(i-half-1)*a.enemy_x_margin*dir.x, y, dir, a.speed_m)
            else
                current_enemy.create(x - math.abs(i-half-1)*a.enemy_x_margin*dir.x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            y = y + a.enemy_y_margin
        end
    --Distribute mode
    elseif a.mode == "distribute" then
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            y = i* (ORIGINAL_WINDOW_HEIGHT/(a.number+1))
            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
        end

    --Top mode
    elseif a.mode == "top" then
        y = a.screen_margin + max_r
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            y = y + a.enemy_y_margin
            x = x - a.enemy_x_margin*dir.x
        end

    --Bottom mode
    elseif a.mode == "bottom" then
        y = ORIGINAL_WINDOW_HEIGHT - a.screen_margin - max_r
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            y = y - a.enemy_y_margin
            x = x - a.enemy_x_margin*dir.x
        end
    end
end

--[[
Formation of a line of enemies coming from the top or bottom. with several
side: "top" ('t') or "bottom" ('b'), side that the enemies come from
mode: mode to apply the formation. As follows:
    --center (default): place enemies from the center of the screen, spaced with enemy margin and can be moved with screen_margin
    --distribute: place balls equally distributed on the screen side
    --left: start placing from the left , with an optional screen margin
    --right: start placing from the right, with an optional screen margin
number: number of enemies in the formation
enemy: enemy (or enemies) to be created
enemy_x_margin: horizontal margin between enemies
enemy_y_margin: vertical margin between enemies
screen_margin: margin from screen (or offset) the enemies are to be created
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
]]
function formation.fromVertical(a)
    local x, y, dir, half, max_r, enemy_table_size, current_enemy, p

    enemy_table_size = Util.tableLen(a.enemy)

    --Find the biggest radius between enemies
    max_r = a.enemy[1].radius()
    for i=2,enemy_table_size do
        if a.enemy[i].radius() > max_r then
            max_r = a.enemy[i].radius()
        end
    end

    --Default values
    p = Psycho.get()
    a.screen_margin = a.screen_margin or 0
    a.enemy_x_margin = a.enemy_x_margin or 10 + 2*max_r
    a.enemy_y_margin = a.enemy_y_margin or 0
    a.number = a.number or 3
    a.speed_m = a.speed_m or 1
    a.dir_follow = a.dir_follow or false

    if a.side == "top" or a.side == "t" then
        dir = Vector(0,1)
        y = -5 -max_r
    elseif a.side == "bottom" or a.side == "b" then
        dir = Vector(0,-1)
        y = ORIGINAL_WINDOW_HEIGHT + 5 + max_r
    end

    ---------
    --MODES--
    ---------

    --Center mode
    if     a.mode == "center" then
        half = math.floor(a.number/2)
        x = ORIGINAL_WINDOW_WIDTH/2 - (a.number-1)/2*a.enemy_x_margin + a.screen_margin
        --Placing from the center
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x, y - math.abs(i-half-1)*a.enemy_y_margin*dir.y, dir, a.speed_m)
            else
                current_enemy.create(x, y - math.abs(i-half-1)*a.enemy_y_margin*dir.y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            x = x + a.enemy_x_margin
        end
    --Distribute mode
    elseif a.mode == "distribute" then
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            x = i* (ORIGINAL_WINDOW_WIDTH/(a.number+1))
            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
        end

    --Left mode
    elseif a.mode == "left" then
        x = a.screen_margin + max_r
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            x = x + a.enemy_x_margin
            y = y - a.enemy_y_margin*dir.y
        end

    --Right mode
    elseif a.mode == "right" then
        x = ORIGINAL_WINDOW_WIDTH - a.screen_margin - max_r
        for i=1, a.number do
            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            if not a.dir_follow then
                current_enemy.create(x, y, dir, a.speed_m)
            else
                current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
            end
            x = x - a.enemy_x_margin
            y = y - a.enemy_y_margin*dir.y
        end
    end
end

--[[
Create an evenly distributed circle of enemies, with a specific radius
number: number of enemies in the formation
radius: radius of the circle
enemy: enemy (or enemies) to be created
enemy_margin: margin between enemies
x_center: x position of center
y_center: y position of center
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
]]
function formation.circle(a)
    local value, x, y, dir, enemy_table_size, current_enemy

    --Default values
    p = Psycho.get()
    a.radius = a.radius or 640
    a.enemy_margin = a.enemy_margin or 0
    a.x_center = a.x_center or ORIGINAL_WINDOW_WIDTH/2 --Center x of the circle
    a.y_center = a.y_center or ORIGINAL_WINDOW_HEIGHT/2 --Center y of the circle
    a.speed_m = a.speed_m or 1
    a.dir_follow = a.dir_follow or false

    enemy_table_size = Util.tableLen(a.enemy)

    value = 2*math.pi/a.number --Divides the circunference

    for i=0, a.number-1 do
        --Cicle through enemies
        current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

        x, y = a.radius*math.cos(i*value), a.radius*math.sin(i*value) --Get position in circle with radius and center (0,0)
        dir = Vector(-x,-y) --Get direction pointing to center
        x, y = a.x_center + x, a.y_center + y --Center circle
        x, y = x - dir:normalized().x*a.enemy_margin*i, y - dir:normalized().y*a.enemy_margin*i --Add enemy margin, if any
        if not a.dir_follow then
            current_enemy.create(x, y, dir, a.speed_m)
        else
            current_enemy.create(x, y, Vector(p.pos.x - x, p.pos.y - y), a.speed_m)
        end
    end
end

--[[
Create a single enemy starting in a (x,y) position and moving in a direction
enemy: enemy (or enemies) to be created
x: x position of enemy
y: y position of enemy
dx: x direction of enemy
dy: y direction of enemy
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
]]
function formation.single(a)
    local dir, p

    --Default values
    p = Psycho.get()
    a.speed_m = a.speed_m or 1
    a.dir_follow = a.dir_follow or false
    a.dx = a.dx or 0
    a.dy = a.dy or 0
    if not a.dir_follow then
        dir = Vector(a.dx, a.dy)
        a.enemy.create(a.x, a.y, dir, a.speed_m)
    else
        a.enemy.create(a.x, a.y, Vector(p.pos.x - a.x, p.pos.y - a.y), a.speed_m)
    end
end

--[[Create a line of enemies starting in a (x,y) position and moving in a direction
enemy: enemy (or enemies) to be created
number: number of enemies to be created
x: x start position of enemy line
y: y start position of enemy line
dx: x direction of enemies
dy: y direction of enemies
enemy_margin: margin between enemies
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
]]
function formation.line(a)
    local dir, n_dir, enemy_table_size, current_enemy, p

    --Default values
    p = Psycho.get()
    a.enemy_margin = a.enemy_margin or 60
    a.speed_m = a.speed_m or 1
    a.dir_follow = a.dir_follow or false
    a.dx = a.dx or 0
    a.dy = a.dy or 0
    enemy_table_size = Util.tableLen(a.enemy)
    dir = Vector(a.dx, a.dy)
    n_dir = dir:normalized() --Normalized direction

    for i=0, a.number-1 do
        --Cicle through enemies
        current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

        if not a.dir_follow then
            current_enemy.create(a.x - i*n_dir.x*a.enemy_margin, a.y - i*n_dir.y*a.enemy_margin, dir, a.speed_m)
        else
            current_enemy.create(a.x - i*n_dir.x*a.enemy_margin, a.y - i*n_dir.y*a.enemy_margin, Vector(p.pos.x - a.x, p.pos.y - a.y), a.speed_m)
        end
    end
end

--Return functions
return formation
