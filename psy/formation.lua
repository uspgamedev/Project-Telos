local Psycho = require "classes.psycho"
local Util = require "util"
local Indicator = require "classes.indicator"
--MODULE TO CREATE ENEMY FORMATIONS--

local formation = {}


--[[
Formation of a line of enemies coming from the left or right.

Arguments

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
ind_mode: indicator mode. If nil, won't create an indicator:
    --all: Create an indicator for all created enemies in the formation
    --first:Create an indicator only to the first enemy created
ind_duration: duration to display indicator before creating the enemies
ind_side: side of indicator
e_radius: Radius of enemy being created
score_mul: multiplier of score for enemies created
]]
function formation.fromHorizontal(a)
    local x, y, dir, half, p, enemy_table_size, max_r, batch


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
    a.score_mul = a.score_mul or 1
    a.dir_follow = a.dir_follow or false
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    if a.ind_mode ~= false then
        a.ind_mode = a.ind_mode or "all"
    end

    if a.side == "left" or a.side == "l" then
        dir = Vector(1,0)
        x = -5 -max_r
    elseif a.side == "right" or a.side == "r" then
        dir = Vector(-1,0)
        x = WINDOW_WIDTH + 5 + max_r
    end

    batch = Indicator.create_enemy_batch(a.ind_duration)
    ---------
    --MODES--
    ---------

    --Center mode
    if     a.mode == "center" then
        half = math.floor(a.number/2)
        y = WINDOW_HEIGHT/2 - (a.number-1)/2*a.enemy_y_margin + a.screen_margin
        --Placing from the center
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Setting local variables
            l_pos = Vector(x - math.abs(i-half-1)*a.enemy_x_margin*dir.x, y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            y = y + a.enemy_y_margin
        end
    --Distribute mode
    elseif a.mode == "distribute" then
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --"Distribute" the enemies
            y = i* (WINDOW_HEIGHT/(a.number+1))

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x, y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

        end

    --Top mode
    elseif a.mode == "top" then
        y = a.screen_margin + max_r
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x,y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            y = y + a.enemy_y_margin
            x = x - a.enemy_x_margin*dir.x
        end

    --Bottom mode
    elseif a.mode == "bottom" then

        y = WINDOW_HEIGHT - a.screen_margin - max_r
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x,y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            y = y - a.enemy_y_margin
            x = x - a.enemy_x_margin*dir.x
        end
    end
end

--[[
Formation of a line of enemies coming from the top or bottom.

Arguments

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
ind_mode: indicator mode. If nil, won't create an indicator:
    --all: Create an indicator for all created enemies in the formation
    --first:Create an indicator only to the first enemy created
ind_duration: duration to display indicator before creating the enemies
ind_side: side of indicator
e_radius: Radius of enemy being created
score_mul: multiplier of score for enemies created
]]
function formation.fromVertical(a)
    local x, y, dir, half, max_r, enemy_table_size, p, batch

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
    a.score_mul = a.score_mul or 1
    a.dir_follow = a.dir_follow or false
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    if a.ind_mode ~= false then
        a.ind_mode = a.ind_mode or "all"
    end

    if a.side == "top" or a.side == "t" then
        dir = Vector(0,1)
        y = -5 -max_r
    elseif a.side == "bottom" or a.side == "b" then
        dir = Vector(0,-1)
        y = WINDOW_HEIGHT + 5 + max_r
    end

    batch = Indicator.create_enemy_batch(a.ind_duration)

    ---------
    --MODES--
    ---------

    --Center mode
    if     a.mode == "center" then
        half = math.floor(a.number/2)
        x = WINDOW_WIDTH/2 - (a.number-1)/2*a.enemy_x_margin + a.screen_margin
        --Placing from the center
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x, y - math.abs(i-half-1)*a.enemy_y_margin*dir.y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            x = x + a.enemy_x_margin
        end
    --Distribute mode
    elseif a.mode == "distribute" then
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --"Distribute" enemies
            x = i* (WINDOW_WIDTH/(a.number+1))

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x, y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

        end

    --Left mode
    elseif a.mode == "left" then
        x = a.screen_margin + max_r
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x, y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            x = x + a.enemy_x_margin
            y = y - a.enemy_y_margin*dir.y
        end

    --Right mode
    elseif a.mode == "right" then
        x = WINDOW_WIDTH - a.screen_margin - max_r
        for i=1, a.number do
            local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

            --Cicle through enemies
            current_enemy = a.enemy[(i-1)%enemy_table_size + 1]

            --Make direction equal to current position of psycho, if desired
            if p and a.dir_follow then
                l_dir = Vector(p.pos.x - x, p.pos.y - y)
            elseif not p and a.dir_follow then
                l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
            else
                l_dir = Vector(dir.x, dir.y)
            end

            --Setting local variables
            l_pos = Vector(x, y)
            l_speed = a.speed_m
            l_follow = a.dir_follow
            l_side = a.ind_side

            if (i == 1 and a.ind_mode == "first") or a.ind_mode == "all" then
                --Create the indicator, and later, the enemy
                batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
            elseif a.ind_mode == "first" then
                --Create the enemy after duration
                handle = LEVEL_TIMER:after(a.ind_duration,
                    function()
                        local p

                        p  = Util.findId("psycho")
                        if p and l_follow then
                            l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                        end
                        current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                    end
                )
                table.insert(INDICATOR_HANDLES, handle)
            else
                --Just create the enemy
                current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
            end

            x = x - a.enemy_x_margin
            y = y - a.enemy_y_margin*dir.y
        end
    end
end

--[[
Create an evenly distributed circle of enemies, with a specific radius

Arguments

number: number of enemies in the formation
radius: radius of the circle
enemy: enemy (or enemies) to be created
enemy_margin: margin between enemies
x_center: x position of center
y_center: y position of center
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
ind_mode: indicator mode. If nil, won't create an indicator:
    --all: Create an indicator for all created enemies in the formation
    --first:Create an indicator only to the first enemy created
ind_duration: duration to display indicator before creating the enemies
ind_side: side of indicator
radius: Radius of circle of enemies
e_radius: Radius of enemy being created
score_mul: multiplier of score for enemies created
]]
function formation.circle(a)
    local value, x, y, dir, enemy_table_size, batch

    --Default values
    p = Psycho.get()
    a.radius = a.radius or 640
    a.enemy_margin = a.enemy_margin or 0
    a.x_center = a.x_center or WINDOW_WIDTH/2 --Center x of the circle
    a.y_center = a.y_center or WINDOW_HEIGHT/2 --Center y of the circle
    a.speed_m = a.speed_m or 1
    a.score_mul = a.score_mul or 1
    a.dir_follow = a.dir_follow or false
    a.aim = a.aim or false
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    if a.ind_mode ~= false then
        a.ind_mode = a.ind_mode or "all"
    end

    enemy_table_size = Util.tableLen(a.enemy)

    batch = Indicator.create_enemy_batch(a.ind_duration)

    value = 2*math.pi/a.number --Divides the circunference

    for i=0, a.number-1 do
        local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

        --Cicle through enemies
        current_enemy = a.enemy[(i%enemy_table_size) + 1]

        x, y = a.radius*math.cos(i*value), a.radius*math.sin(i*value) --Get position in circle with radius and center (0,0)
        dir = Vector(-x,-y) --Get direction pointing to center
        x, y = a.x_center + x, a.y_center + y --Center circle
        x, y = x - dir:normalized().x*a.enemy_margin*i, y - dir:normalized().y*a.enemy_margin*i --Add enemy margin, if any

        --Setting local variables
        l_pos = Vector(x, y)
        l_speed = a.speed_m
        l_follow = a.dir_follow
        l_side = a.ind_side

        --Make direction equal to current position of psycho, if desired
        if p and a.dir_follow then
            l_dir = Vector(p.pos.x - x, p.pos.y - y)
        elseif not p and a.dir_follow then
            l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
        else
            l_dir = Vector(dir.x, dir.y)
        end

        if (i == 0 and a.ind_mode == "first") or a.ind_mode == "all" then
            --Create the indicator, and later, the enemy
            batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
        elseif a.ind_mode == "first" then
            --Create the enemy after duration
            handle = LEVEL_TIMER:after(a.ind_duration,
                function()
                    local p

                    p  = Util.findId("psycho")
                    if p and l_follow then
                        l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                    end
                    current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                end
            )
            table.insert(INDICATOR_HANDLES, handle)
        else
            --Just create the enemy
            current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
        end

    end
end

--[[
Create a single enemy starting in a (x,y) position and moving in a direction

Arguments

enemy: enemy (or enemies) to be created
x: x position of enemy
y: y position of enemy
dx: x direction of enemy
dy: y direction of enemy
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
ind_mode: if true, create an indicator for the enemy being created
ind_duration: duration to display indicator before creating the enemy
e_radius: Radius of enemy being created
score_mul: multiplier of score for enemies created
ind_side: side of indicator
]]
function formation.single(a)
    local p, l_pos, l_speed, l_dir, l_follow, l_side, batch

    --Default values
    p = Psycho.get()
    a.speed_m = a.speed_m or 1
    a.score_mul = a.score_mul or 1
    a.dir_follow = a.dir_follow or false
    a.dx = a.dx or 0
    a.dy = a.dy or 0
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    if a.ind_mode == nil then a.ind_mode = true end

    --Setting local variables
    l_pos = Vector(a.x, a.y)
    l_speed = a.speed_m
    l_follow = a.dir_follow
    l_side = a.ind_side

    --Make direction equal to current position of psycho, if desired
    if p and a.dir_follow then
        l_dir = Vector(p.pos.x - a.x, p.pos.y - a.y)
    elseif not p and a.dir_follow then
        l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
    else
        l_dir = Vector(a.dx, a.dy)
    end

    batch = Indicator.create_enemy_batch(a.ind_duration)

    if a.ind_mode then
        --Create the indicator, and later, the enemy
        batch:put(Indicator.create_enemy(a.enemy, l_pos, l_dir, l_follow, l_side, l_speed, a.e_radius, a.score_mul))
    else
        --Just create the enemy
        a.enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
    end

end

--[[Create a line of enemies starting in a (x,y) position and moving in a direction

Arguments

enemy: enemy (or enemies) to be created
number: number of enemies to be created
x: x start position of enemy line
y: y start position of enemy line
dx: x direction of enemies
dy: y direction of enemies
enemy_margin: margin between enemies
speed_m: speed multiplier applied to the enemies created
dir_follow: whether the enemies' dir is facing towards psycho, or not
ind_mode: indicator mode. If nil, won't create an indicator:
    --all: Create an indicator for all created enemies in the formation
    --first:Create an indicator only to the first enemy created
ind_duration: duration to display indicator before creating the enemies
ind_side: side of indicator
e_radius: Radius of enemy being created
score_mul: multiplier of score for enemies created
]]
function formation.line(a)
    local dir, n_dir, enemy_table_size, p, batch

    --Default values
    p = Psycho.get()
    a.enemy_margin = a.enemy_margin or 60
    a.speed_m = a.speed_m or 1
    a.score_mul = a.score_mul or 1
    a.dir_follow = a.dir_follow or false
    a.dx = a.dx or 0
    a.dy = a.dy or 0
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    if a.ind_mode ~= false then
        a.ind_mode = a.ind_mode or "first"
    end

    enemy_table_size = Util.tableLen(a.enemy)
    dir = Vector(a.dx, a.dy)
    n_dir = dir:normalized() --Normalized direction

    batch = Indicator.create_enemy_batch(a.ind_duration)

    for i=0, a.number-1 do
        local l_pos, l_dir, current_enemy, l_speed, l_follow, l_side --Local values so that enemies are properly created

        --Cicle through enemies
        current_enemy = a.enemy[ (i%enemy_table_size) + 1]

        --Setting local variables
        l_pos = Vector(a.x - i*n_dir.x*a.enemy_margin, a.y - i*n_dir.y*a.enemy_margin)
        l_speed = a.speed_m
        l_follow = a.dir_follow
        l_side = a.ind_side

        --Make direction equal to current position of psycho, if desired
        if p and a.dir_follow then
            l_dir = Vector(p.pos.x - a.x, p.pos.y - a.y)
        elseif not p and a.dir_follow then
            l_dir = Vector(WINDOW_WIDTH/2 - x, WINDOW_HEIGHT/2 - y):normalized()
        else
            l_dir = Vector(a.dx, a.dy)
        end

        if (i == 0 and a.ind_mode == "first") or a.ind_mode == "all" then
            --Create the indicator, and later, the enemy
            batch:put(Indicator.create_enemy(current_enemy, l_pos, l_dir, a.dir_follow, l_side, l_speed, a.e_radius, a.score_mul))
        elseif a.ind_mode == "first" then
            --Create the enemy after duration
            handle = LEVEL_TIMER:after(a.ind_duration,
                function()
                    local p

                    p = Util.findId("psycho")
                    if p and l_follow then
                        l_dir = Vector(p.pos.x - l_pos.x, p.pos.y - l_pos.y)
                    end
                    current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
                end
            )
            table.insert(INDICATOR_HANDLES, handle)
        else

            --Just create the enemy
            current_enemy.create(l_pos.x, l_pos.y, l_dir, a.speed_m, a.e_radius, a.score_mul)
        end
    end
end

--[[
Create a single turret enemy starting in a (x,y) position, moving to a target position, spawn a given enemy, then leaving after duration

Arguments

enemy: enemy to be spawned
x: x position of turret
y: y position of turret
t_x: x value of target position
t_y: y value of target position
duration: duration the turret will stay at the target
life: how many hits the turret can take before dying
number: number of enemies to spawn
start_angle: starting angle for spawn (in radians)
rot_angle: rotating angle after spawning an enemy (in radians)
fps: how many seconds between every "wave" of spawning
speed_m: speed multiplier applied to the turret
e_speed_m: speed multiplier applied to the enemies spawned
ind_mode: if true, create an indicator for the enemy being created
ind_duration: duration to display indicator before creating the enemy
e_radius: Radius of turret being created
score_mul: multiplier of score for turret and enemies created
ind_side: side of indicator
]]
function formation.turret(a)
    local p, l_pos, l_speed, l_e_speed, l_duration, l_life, l_number, l_start_angle, l_rot_angle, l_fps, l_side, l_radius, l_score, l_enemy, l_target, batch, l_ind_duration

    --Default values
    p = Psycho.get()
    a.duration = a.duration or 10
    a.life = a.life or 10
    a.start_angle = a.start_angle or 0
    a.rot_angle = a.rot_angle or math.pi/2
    a.fps = a.fps or 1
    a.speed_m = a.speed_m or 1
    a.e_speed_m = a.e_speed_m or 1
    if a.ind_mode == nil then a.ind_mode = true end
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    a.e_radius = a.e_radius or Trt.radius()
    a.score_mul = a.score_mul or 1
    a.ind_side = a.ind_side or 35

    --Setting local variables
    l_pos = Vector(a.x, a.y)
    l_target = Vector(a.t_x, a.t_y)
    l_speed = a.speed_m
    l_e_speed = a.e_speed_m
    l_duration = a.duration
    l_life = a.life
    l_radius = a.e_radius
    l_number = a.number
    l_start_angle = a.start_angle
    l_rot_angle = a.rot_angle
    l_fps = a.fps
    l_side = a.ind_side
    l_score = a.score_mul
    l_enemy = a.enemy
    l_ind_duration = a.ind_duration

    if a.ind_mode then
        --Create the indicator, that will later create the enemy
        Indicator.create_enemy_turret(Trt, l_pos, l_speed, l_e_speed, l_radius, l_score, l_enemy, l_target, l_duration, l_life, l_number, l_start_angle, l_rot_angle, l_fps, l_side, l_ind_duration)
    else
        --Just create the enemy
        Trt.create(l_pos.x, l_pos.y, l_speed, l_e_speed, l_radius, l_score, l_enemy, l_target, l_duration, l_life, l_number, l_start_angle, l_rot_angle, l_fps)
    end

end

--[[
Create a single cage starting in a (x,y) position, reducing radius to target radius
Returns the enemy to call subsequent methods

Arguments

x: central x position of cage
y: central y position of cage
radius: target radius to tween-to
speed_radius: optional speed to tween radius
]]
function formation.cage(a)
    local p, l_pos, l_r, l_speed_r

    --Default values
    p = Psycho.get()
    a.x = a.x or WINDOW_WIDTH/2
    a.y = a.y or WINDOW_HEIGHT/2
    a.radius = a.radius or 200
    a.speed_radius = a.speed_radius or 200

    --Setting local variables
    l_pos = Vector(a.x, a.y)
    l_r = a.radius
    l_speed_r = a.speed_radius

    --Just create the enemy
    return Cge.create(l_pos.x, l_pos.y, l_r, l_speed_r)
end

--[[
Create a snake enemy given a table of positions to walk through and number of segments

Arguments

enemy: enemy (or enemies) to be created
segments: number of segments snake has
positions: table containing all positions snake will pass through (must have at least 2)
speed_m: speed multiplier applied to the enemies created
ind_mode: if true, create an indicator for the enemy being created
ind_duration: duration to display indicator before creating the enemy
e_radius: Radius of each segment being created
e_life: How much lif each segment has
score_mul: multiplier of score for enemies created
ind_side: side of indicator
]]
function formation.snake(a)
    --Default values
    a.segments = a.segments or 3
    a.positions = a.positions or {{-100,WINDOW_HEIGHT/2},{WINDOW_WIDTH+100, WINDOW_HEIGHT/2}}
    a.speed_m = a.speed_m or 1
    a.score_mul = a.score_mul or 1
    a.e_life = a.e_life or 3
    a.ind_duration = a.ind_duration or INDICATOR_DEFAULT
    a.ind_side = a.ind_side or 35
    a.e_radius = a.e_radius or Snk.radius()
    if a.ind_mode == nil then a.ind_mode = true end

    if a.ind_mode then
        --Create the indicator, that will later create the enemy
        Indicator.create_enemy_snake(Snk, a.segments, a.positions, a.e_life, a.speed_m, a.e_radius, a.score_mul, a.ind_side, a.ind_duration)
    else
        --Just create the enemy
        Snk.create(a.segments, a.positions, a.e_life, a.speed_m, a.e_radius, a.score_mul)
    end

end



--Return functions
return formation
