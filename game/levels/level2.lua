local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Audio = require "audio"
local Util = require "util"

local level_functions = {}

--Boss
local Boss = require "classes.bosses.boss2"

--LEVEL 2--

--2-1: A Cross the Planes
function level_functions.part_1()
    local p

    CONTINUE = 2 --Setup continue variable to later continue from where you started

    p = Util.findId("psycho")

    LM.level_part("Part 1 - A Cross the Planes")

    LM.wait(3)
    F.fromHorizontal{enemy = {DB}, side = "left", mode = "top" , number = 7, ind_duration = 2.5, ind_side = 40, speed_m = 1.5}
    LM.wait(2.5)
    for i = 1,10 do
        LM.wait(.3)
        F.fromHorizontal{enemy = {DB}, side = "left", mode = "top" , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
        if i == 9 then
            INDICATOR_DEFAULT = .5
            F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 170, speed_m = 1.5, ind_side = 35}
            F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, speed_m = 1.5, ind_side = 35}
        end
    end

    INDICATOR_DEFAULT = 1.5
    LM.wait(5.85)
    --Make traverse easy
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, ind_mode = false, speed_m = 1.5, enemy_margin = 70}
    LM.wait(2)

    --Choose mode based on psycho position
    local chosen_mode
    if p and p.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_mode = "top"
    else
        chosen_mode = "bottom"
    end

    F.fromHorizontal{enemy = {DB}, side = "right", mode = chosen_mode , number = 7, ind_duration = 5.1, ind_side = 40, speed_m = 1.5}
    LM.wait(4.55)
    --Make traverse difficult
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 40, speed_m = 1.5, ind_mode = false}
    LM.wait(.55)
    for i = 1,5 do
        LM.wait(.3)
        F.fromHorizontal{enemy = {DB}, side = "right", mode = chosen_mode , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
    end

    LM.wait(3.9)
    --Make traverse easy
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 20, ind_mode = false, speed_m = 1.5, enemy_margin = 70}
    LM.wait(1)

    --Choose mode based on psycho position
    if p and p.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_mode = "top"
    else
        chosen_mode = "bottom"
    end

    F.fromHorizontal{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_duration = 2.5, ind_side = 40, speed_m = 1.5}
    LM.wait(2.45)
    --Make traverse difficult
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 88, speed_m = 1.5, ind_mode = false}
    LM.wait(.2)
    for i = 1,5 do
        LM.wait(.3)
        F.fromHorizontal{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
    end


    LM.wait(1.9)
    --Make traverse easy
    F.line{enemy = {SB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 16, speed_m = 1.5, ind_mode = false}
    LM.wait(.85)

    --Choose mode based on psycho position
    if p and p.pos.x < ORIGINAL_WINDOW_WIDTH/2 then
        chosen_mode = "left"
    else
        chosen_mode = "right"
    end
    local chosen_side
    --Choose mode based on psycho position
    if p and p.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_side = "bottom"
    else
        chosen_side = "top"
    end

    F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode , number = 9, ind_duration = 1.5, ind_side = 40, speed_m = 1.5, screen_margin = 10}
    LM.wait(1.5)
    --Make traverse difficult
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 14, speed_m = 1.5, ind_mode = false}
    for i = 1,5 do
        LM.wait(.3)
        F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode , number = 9, ind_mode = false, ind_mode = false, speed_m = 1.5, screen_margin = 10}
    end
    LM.wait(.6)
    --Make traverse easy
    F.line{enemy = {SB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 9, speed_m = 1.5, ind_mode = false}

    --Choose mode based on psycho position
    if p and p.pos.x < ORIGINAL_WINDOW_WIDTH/2 then
        chosen_mode = "left"
    else
        chosen_mode = "right"
    end

    --Choose mode based on psycho position
    if p and p.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_side = "bottom"
    else
        chosen_side = "top"
    end

    F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode , number = 9, ind_duration = 1, ind_side = 40, speed_m = 1.5, screen_margin = 10}
    LM.wait(1)
    for i = 1,5 do
        LM.wait(.3)
        F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode , number = 9, ind_mode = false, ind_mode = false, speed_m = 1.5, screen_margin = 10}
        if i == 1 then
            --Make traverse difficult
            F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 25, speed_m = 1.5, ind_mode = false}
        end
    end
    LM.wait(2.5)

    --Make both traverse easy
    F.line{enemy = {SB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 216, speed_m = 1.5, ind_mode = false, enemy_margin = 65}
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 212, speed_m = 1.5, ind_mode = false, enemy_margin = 65}

    LM.wait(2)

    INDICATOR_DEFAULT = 2.6
    for i = 1,5 do
        --Choose mode based on psycho position
        if p and p.pos.x < ORIGINAL_WINDOW_WIDTH/2 then
            chosen_mode = "left"
        else
            chosen_mode = "right"
        end

        if p and p.pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
            chosen_side = "top"
        else
            chosen_side = "bottom"
        end
        --Mode and side for Vertical formation. For correspondent Horizontal, just switch the two values (because math, I guess)
        F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode, number = 9, ind_side = 40, speed_m = 1.8, screen_margin = 10}
        F.fromHorizontal{enemy = {DB}, side = chosen_mode, mode = chosen_side , number = 7, ind_side = 40, speed_m = 1.8}
        LM.wait(INDICATOR_DEFAULT)
        for j = 1,5 do
            LM.wait(.3)
            F.fromVertical{enemy = {DB}, side = chosen_side, mode = chosen_mode, number = 9, ind_mode = false, ind_mode = false, speed_m = 1.8, screen_margin = 10}
            F.fromHorizontal{enemy = {DB}, side = chosen_mode, mode = chosen_side, number = 7, ind_mode = false, ind_mode = false, speed_m = 1.8}
        end
        if i < 3 then
            LM.wait(2.5)
        elseif i < 4 then
            INDICATOR_DEFAULT = 2.4
            LM.wait(2)
        else
            INDICATOR_DEFAULT = 2.3
            LM.wait(2)
        end
    end

    INDICATOR_DEFAULT = 3
    F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "top", mode = "left", number = 9, ind_side = 40, screen_margin = 10}
    F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "left", mode = "top" , number = 7, ind_side = 40}
    F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "top", mode = "right", number = 9, ind_side = 40, screen_margin = 10}
    F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "right", mode = "top" , number = 7, ind_side = 40}
    F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "bottom", mode = "left", number = 9, ind_side = 40, screen_margin = 10}
    F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "left", mode = "bottom" , number = 7, ind_side = 40}
    F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "bottom", mode = "right", number = 9, ind_side = 40, screen_margin = 10}
    F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "right", mode = "bottom" , number = 7, ind_side = 40}
    LM.wait(3)
    for j = 1,5 do
        LM.wait(.3)
        F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "top", mode = "left", number = 9, ind_mode = false, screen_margin = 10}
        F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "left", mode = "top" , number = 7, ind_mode = false}
        F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "top", mode = "right", number = 9, ind_mode = false, screen_margin = 10}
        F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "right", mode = "top" , number = 7, ind_mode = false}
        F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "bottom", mode = "left", number = 9, ind_mode = false, screen_margin = 10}
        F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "left", mode = "bottom" , number = 7, ind_mode = false}
        F.fromVertical{enemy = {DB}, speed_m = 1.7, side = "bottom", mode = "right", number = 9, ind_mode = false, screen_margin = 10}
        F.fromHorizontal{enemy = {DB}, speed_m = 1.7, side = "right", mode = "bottom" , number = 7, ind_mode = false}
    end
    LM.wait("noenemies")
    LM.giveLives(4, "finished part")

    LM.stop()
    LM.start(level_functions.part_2)

end

--2-2: The Outsider
function level_functions.part_2()
    local p

    p = Util.findId("psycho")

    LM.level_part("Part 2 - The Outsider")

    LM.wait(3)
    F.single{enemy = GrB, x = -20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0, ind_duration = 2, ind_side = 35, speed_m = .7, e_radius = 30}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.fromVertical{enemy = {GrB}, speed_m = 1.7, side = "top", mode = "left", number = 8, screen_margin = 10}
    F.fromHorizontal{enemy = {GrB}, speed_m = 1.7, side = "left", mode = "top" , number = 6}
    F.fromVertical{enemy = {GrB}, speed_m = 1.7, side = "top", mode = "right", number = 8, screen_margin = 10}
    F.fromHorizontal{enemy = {GrB}, speed_m = 1.7, side = "right", mode = "top" , number = 6}
    F.fromVertical{enemy = {GrB}, speed_m = 1.7, side = "bottom", mode = "left", number = 8, screen_margin = 10}
    F.fromHorizontal{enemy = {GrB}, speed_m = 1.7, side = "left", mode = "bottom" , number = 6}
    F.fromVertical{enemy = {GrB}, speed_m = 1.7, side = "bottom", mode = "right", number = 8, screen_margin = 10}
    F.fromHorizontal{enemy = {GrB}, speed_m = 1.7, side = "right", mode = "bottom" , number = 6}
    LM.wait(.5)

    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.9)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.9)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.9)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.9)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    --Get harder
    LM.wait(.7)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.7)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.7)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 6, screen_margin = -20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait(.7)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "left", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {GrB}, number = 5, screen_margin = 20, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "top", enemy = {GrB}, number = 1, speed_m = .85}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {GrB}, number = 1, speed_m = .85}
    LM.wait("noenemies")

    F.single{enemy = GlB, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, dy = 0, ind_duration = 2, ind_side = 35, speed_m = .7}
    LM.wait("noenemies")

    --Lines trapping psycho in the middle
    F.line{enemy = {GlB}, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2 + 57, number = 103, dx = -1}
    F.line{enemy = {GlB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2 - 57, number = 103, dx = 1}
    F.fromHorizontal{side = "left", mode = "top", number = 6, enemy = {GlB}}
    F.fromHorizontal{side = "right", mode = "top", number = 7, enemy = {GlB}}
    F.fromHorizontal{side = "left", mode = "bottom", number = 7, enemy = {GlB}}
    F.fromHorizontal{side = "right", mode = "bottom", number = 6, enemy = {GlB}}
    LM.wait(4)

    INDICATOR_DEFAULT = 2.5
    local wait
    wait = 1.5
    for i = 1, 67 do

        LM.wait(wait)
        F.fromHorizontal{side = "left", mode = "top", number = 6, enemy = {GlB}, ind_mode = false}
        F.fromHorizontal{side = "right", mode = "bottom", number = 6, enemy = {GlB}, ind_mode = false}

        if i == 1 then
            F.fromVertical{side = "bottom", mode = "right", number =  18, enemy_y_margin = 20, enemy = {GrB}}
            INDICATOR_DEFAULT = 2
        elseif i == 4 then
            F.fromVertical{side = "bottom", mode = "left", number =  18, enemy_y_margin = 20, enemy = {GrB}}
            INDICATOR_DEFAULT = 1.7
        elseif i == 7 then
            F.fromVertical{side = "bottom", mode = "right", number =  18, enemy_y_margin = 20, enemy = {GrB}}
        elseif i == 9 then
            F.fromVertical{side = "top", mode = "left", number =  9, enemy = {GrB}, speed_m = .9}
            F.fromVertical{side = "top", mode = "right", number =  10, enemy = {GrB}, speed_m = .9}
            INDICATOR_DEFAULT = .5
        elseif i == 11 then
            F.fromVertical{side = "top", mode = "left", number =  7, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  12, enemy = {GrB}}
        elseif i == 12 then
            F.fromVertical{side = "top", mode = "left", number =  6, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  13, enemy = {GrB}}
        elseif i == 13 then
            F.fromVertical{side = "top", mode = "left", number =  6, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  13, enemy = {GrB}}
            LM.wait(.5)
            F.line{enemy = {GlB}, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2 + 57, number = 103, dx = -1}
            F.line{enemy = {GlB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2 - 57, number = 103, dx = 1}
            wait = .5
        elseif i == 14 then
            wait = 1
            F.fromVertical{side = "top", mode = "left", number =  3, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  16, enemy = {GrB}}
        elseif i == 15 then
            F.fromVertical{side = "top", mode = "left", number =  7, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  12, enemy = {GrB}}
        elseif i == 16 then
            F.fromVertical{side = "top", mode = "left", number =  11, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  8, enemy = {GrB}}
        elseif i == 17 then
            F.fromVertical{side = "top", mode = "left", number =  14, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  5, enemy = {GrB}}
        elseif i == 18 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 19 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 20 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 21 then
            F.fromVertical{side = "top", mode = "left", number =  10, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  9, enemy = {GrB}}
        elseif i == 22 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 23 then
            F.fromVertical{side = "top", mode = "left", number =  14, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  5, enemy = {GrB}}
        elseif i == 24 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 25 then
            F.fromVertical{side = "top", mode = "left", number =  11, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  8, enemy = {GrB}}
        elseif i == 26 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 27 then
            F.fromVertical{side = "top", mode = "left", number =  7, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  12, enemy = {GrB}}
        elseif i == 28 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 29 then
            F.fromVertical{side = "top", mode = "left", number =  11, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  8, enemy = {GrB}}
        elseif i == 30 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 31 then
            F.fromVertical{side = "top", mode = "left", number =  7, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  12, enemy = {GrB}}
        elseif i == 32 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 33 then
            F.fromVertical{side = "top", mode = "left", number =  9, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  10, enemy = {GrB}}
        elseif i == 34 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
        elseif i == 35 then
            F.fromVertical{side = "top", mode = "left", number =  6, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  13, enemy = {GrB}}
        elseif i == 36 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB}}
            LM.wait(.25)
            F.line{enemy = {GlB}, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2 + 57, number = 103, dx = -1}
            F.line{enemy = {GlB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2 - 57, number = 103, dx = 1}
            wait = wait -.25
            --Continue stream
        elseif i == 37 then
            wait = wait + .25
            F.fromVertical{side = "top", mode = "right", number =  14, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "left", number =  6, enemy = {SB}}
            wait = 1.5
        elseif i == 38 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB,DB}}
        elseif i == 39 then
            F.fromVertical{side = "top", mode = "left", number =  5, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  14, enemy = {GrB}}
        elseif i == 40 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {DB}}
        elseif i == 41 then
            F.fromVertical{side = "top", mode = "left", number =  9, enemy = {GrB}}
            F.fromVertical{side = "top", mode = "right", number =  10, enemy = {GrB}}
        elseif i == 42 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB,GrB,SB}}
        elseif i == 43 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {SB,GrB,GrB}}
        elseif i == 44 then
            F.fromVertical{side = "top", mode = "center", number =  20, enemy = {DB,GrB,DB,GrB,GrB,SB,GrB,GrB}}
            INDICATOR_DEFAULT = 1.5
        elseif i == 46 then
            F.circle{radius = 640, dir_follow = true, number = 20, enemy = {SB}, ind_duration = 4, ind_side = 35}
        elseif i == 50 then
            F.circle{radius = 640, dir_follow = true, number = 20, enemy = {DB,SB}, ind_duration = 4, ind_side = 35}
        elseif i == 51 then
            LM.wait(.1)
            F.line{enemy = {GlB}, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2 + 57, number = 103, dx = -1}
            F.line{enemy = {GlB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2 - 57, number = 103, dx = 1}
            wait = wait - .1
        elseif i == 54 then
            wait = wait + .1
            F.circle{radius = 640, number = 20, enemy = {DB,SB}, ind_duration = 2, ind_side = 35}
        elseif i == 58 then
            F.line{x = -20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 28, enemy = {SB}, ind_duration = 5, ind_side = 35, speed_m = .85}
            F.line{x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 28, enemy = {SB}, ind_duration = 5, ind_side = 35, speed_m = .85}
        end
    end
    LM.wait("noenemies")
    LM.giveLives(5, "finished part")

    LM.stop()
    LM.start(level_functions.part_3)

end

--2-3: Standing Still
function level_functions.part_3()
    local p

    p = Util.findId("psycho")

    LM.level_part("Part 3 - Standing Still")

    LM.wait(3)
    INDICATOR_DEFAULT = 1.5
    F.turret{x = -60, y = ORIGINAL_WINDOW_HEIGHT/2, t_x = ORIGINAL_WINDOW_WIDTH/2, t_y = ORIGINAL_WINDOW_HEIGHT/2, enemy = SB, number = 8, life = 20, duration = 15, rot_angle = math.pi/4, speed_m = 2, ind_duration = 2.5}
    LM.wait("noenemies")

    F.turret{x = ORIGINAL_WINDOW_WIDTH/2, y = -60, t_x = ORIGINAL_WINDOW_WIDTH/2, t_y = 2*ORIGINAL_WINDOW_HEIGHT/5, enemy = DB, number = 6, life = 20, duration = 15, rot_angle = math.pi/3, speed_m = 1.5}
    F.turret{x = ORIGINAL_WINDOW_WIDTH/2, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = ORIGINAL_WINDOW_WIDTH/2, t_y = 3*ORIGINAL_WINDOW_HEIGHT/5, enemy = DB, number = 6, life = 20, duration = 15, rot_angle = math.pi/3, speed_m = 1.5}
    LM.wait(5)
    F.fromHorizontal{side = "left", mode = "distribute", number = 10, enemy = {SB}}
    LM.wait(3)
    F.fromHorizontal{side = "right", mode = "distribute", number = 10, enemy = {SB}}
    LM.wait(3)
    F.fromVertical{side = "top", mode = "distribute", number = 15, enemy = {SB}}
    LM.wait(3)
    F.fromVertical{side = "bottom", mode = "distribute", number = 15, enemy = {SB}}
    LM.wait("noenemies")

    F.turret{x = -60, y = -60, t_x = 60, t_y = 60, enemy = DB, number = 3, life = 15, duration = 32, start_angle = math.pi/2, rot_angle = -math.pi/4, speed_m = 1.5, ind_duration = 1, e_speed_m = 1.1}
    F.turret{x = ORIGINAL_WINDOW_WIDTH + 60, y = -60, t_x = ORIGINAL_WINDOW_WIDTH - 60, t_y = 60, enemy = DB, number = 3, life = 15, duration = 32, start_angle = -math.pi/2, rot_angle = math.pi/4, speed_m = 1.5, ind_duration = 1, e_speed_m = 1.1}
    F.turret{x = ORIGINAL_WINDOW_WIDTH + 60, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = ORIGINAL_WINDOW_WIDTH  - 60, t_y = ORIGINAL_WINDOW_HEIGHT - 60, enemy = DB, number = 3, life = 15, duration = 32, start_angle = math.pi, rot_angle = math.pi/4, speed_m = 1.5, ind_duration = 1, e_speed_m = 1.1}
    F.turret{x = -60, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = 60, t_y = ORIGINAL_WINDOW_HEIGHT - 60, enemy = DB, number = 3, life = 15, duration = 32, start_angle = math.pi, rot_angle = -math.
    pi/4, speed_m = 1.5, ind_duration = 1, e_speed_m = 1.1}
    LM.wait(5)
    F.fromHorizontal{side = "left", mode = "distribute", number = 10, enemy = {SB}}
    LM.wait(3)
    F.fromHorizontal{side = "right", mode = "distribute", number = 10, enemy = {SB}}
    LM.wait(3)
    F.fromVertical{side = "top", mode = "distribute", number = 15, enemy = {SB}}
    LM.wait(3)
    F.fromVertical{side = "bottom", mode = "distribute", number = 15, enemy = {SB}}
    LM.wait(5)
    INDICATOR_DEFAULT = 3
    F.fromHorizontal{side = "left", mode = "distribute", number = 10, enemy = {SB}, speed_m = .7}
    F.fromHorizontal{side = "right", mode = "distribute", number = 10, enemy = {SB}, speed_m = .7}
    F.fromVertical{side = "top", mode = "distribute", number = 15, enemy = {SB}, speed_m = .7}
    F.fromVertical{side = "bottom", mode = "distribute", number = 15, enemy = {SB}, speed_m = .7}

    LM.wait(6)
    F.circle{radius = 640, number = 12, enemy = {SB}, dir_follow = true, ind_side = 40}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.turret{x = -60, y = -60, t_x = 2*ORIGINAL_WINDOW_WIDTH/7, t_y = ORIGINAL_WINDOW_HEIGHT/2, enemy = GrB, number = 2, life = 12, duration = 11, start_angle = 0, rot_angle = math.pi, speed_m = 1.5, e_speed_m = 2, fps = .2}
    F.turret{x = ORIGINAL_WINDOW_WIDTH + 60, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = 5*ORIGINAL_WINDOW_WIDTH/7, t_y = ORIGINAL_WINDOW_HEIGHT/2, enemy = GrB, number = 2, life = 12, duration = 11, start_angle = 0, rot_angle = math.pi, speed_m = 1.5, e_speed_m = 2, fps = .2}

    LM.wait(3)

    local pos1, pos2 --Positions the psycho can be ("left" for left, "center" for middle and "right" for right)
    local num --Number of enemies to create

    if p.pos.x <= 2*ORIGINAL_WINDOW_WIDTH/7 then
        pos1 = "left"
        num = 6
    elseif p.pos.x <= 5*ORIGINAL_WINDOW_WIDTH/7 then
        pos1 = "center"
        num = 7
    else
        pos1 = "right"
        num = 6
    end

    F.fromVertical{side = "top", mode = pos1, number = num, speed_m = .9, enemy = {GlB}}
    LM.wait(2)
    F.fromVertical{side = "top", mode = pos1, number = num, speed_m = .9, enemy = {GlB}, ind_mode = false}
    LM.wait(.5)
    F.fromVertical{side = "top", mode = pos1, number = num, speed_m = .9, enemy = {GlB}, ind_mode = false}
    LM.wait(.5)
    F.fromVertical{side = "top", mode = pos1, number = num, speed_m = .9, enemy = {GlB}, ind_mode = false}
    LM.wait(2)

    local dist1, dist2

    dist1, dist2 = nil, nil

    if p.pos.x <= 2*ORIGINAL_WINDOW_WIDTH/7 then
        pos2 = "left"
        dist2 = 60
    elseif p.pos.x <= 5*ORIGINAL_WINDOW_WIDTH/7 then
        pos2 = "center"
    else
        pos2 = "right"
        dist2 = 60
    end

    --If psycho is in the same position, get another close position (or choose one at random if he is at the center)
    if pos1 == pos2 then
        if pos1 == "right" or pos1 == "left" then
            pos2 = "center"
            dist2 = nil
        elseif love.math.random() > .5 then
            pos2 = "left"
            dist2 = 60
        else
            pos2 = "right"
            dist2 = 60
        end
    end

    if pos1 == "left" or pos1 == "right" then dist1 = 60 end


    F.fromVertical{side = "bottom", mode = pos1, number = 6, speed_m = 1, enemy = {GlB}, enemy_x_margin = dist1}
    F.fromVertical{side = "bottom", mode = pos2, number = 6, speed_m = 1, enemy = {GlB}, enemy_x_margin = dist2}
    LM.wait(2)
    F.fromVertical{side = "bottom", mode = pos1, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist1}
    F.fromVertical{side = "bottom", mode = pos2, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist2}
    LM.wait(.5)
    F.fromVertical{side = "bottom", mode = pos1, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist1}
    F.fromVertical{side = "bottom", mode = pos2, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist2}
    LM.wait(.5)
    F.fromVertical{side = "bottom", mode = pos1, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist1}
    F.fromVertical{side = "bottom", mode = pos2, number = 6, speed_m = 1, enemy = {GlB}, ind_mode = false, enemy_x_margin = dist2}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.turret{x = -60, y = -60, t_x = ORIGINAL_WINDOW_WIDTH/3, t_y = ORIGINAL_WINDOW_HEIGHT/3, enemy = SB, number = 2, life = 30, duration = 28, start_angle = 0, rot_angle = math.pi, fps = .3}
    F.turret{x = ORIGINAL_WINDOW_WIDTH + 60, y = -60, t_x = 2*ORIGINAL_WINDOW_WIDTH/3, t_y = ORIGINAL_WINDOW_HEIGHT/3, enemy = SB, number = 2, life = 30, duration = 28, start_angle = math.pi/2, rot_angle = math.pi, fps = .3}
    F.turret{x = ORIGINAL_WINDOW_WIDTH + 60, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = 2*ORIGINAL_WINDOW_WIDTH/3, t_y = 2*ORIGINAL_WINDOW_HEIGHT/3, enemy = SB, number = 2, life = 30, duration = 28, start_angle = 0, rot_angle = math.pi, fps = .3}
    F.turret{x = -60, y = ORIGINAL_WINDOW_HEIGHT + 60, t_x = ORIGINAL_WINDOW_WIDTH/3, t_y = 2*ORIGINAL_WINDOW_HEIGHT/3, enemy = SB, number = 2, life = 30, duration = 28, start_angle = math.pi/2, rot_angle = math.pi, fps = .3}
    LM.wait(6)

    INDICATOR_DEFAULT = 2
    F.fromVertical{side = "top", mode = "center", number = 6, enemy = {GrB}, speed_m = 1.3}
    F.fromVertical{side = "bottom", mode = "center", number = 6, enemy = {GrB}, speed_m = 1.3}
    LM.wait(5)
    INDICATOR_DEFAULT = 2.5
    F.fromHorizontal{side = "left", mode = "top", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromHorizontal{side = "left", mode = "bottom", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromHorizontal{side = "right", mode = "top", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromHorizontal{side = "right", mode = "bottom", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromVertical{side = "top", mode = "left", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromVertical{side = "top", mode = "right", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromVertical{side = "bottom", mode = "left", number = 5, enemy = {DB}, speed_m = 1.3}
    F.fromVertical{side = "bottom", mode = "right", number = 5, enemy = {DB}, speed_m = 1.3}
    LM.wait(6)
    F.fromVertical{side = "top", mode = "center", number = 6, enemy = {GrB}, speed_m = 1.3}
    F.fromVertical{side = "bottom", mode = "center", number = 6, enemy = {GrB}, speed_m = 1.3}
    F.fromHorizontal{side = "left", mode = "center", number = 5, enemy = {GrB}, speed_m = 1.3}
    F.fromHorizontal{side = "right", mode = "center", number = 5, enemy = {GrB}, speed_m = 1.3}
    LM.wait(6)

    INDICATOR_DEFAULT = 4
    F.fromVertical{side = "top", mode = "center", number = 6, enemy = {SB}, speed_m = .9}
    F.fromVertical{side = "bottom", mode = "center", number = 6, enemy = {SB}, speed_m = .9}
    F.fromHorizontal{side = "left", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    F.fromHorizontal{side = "right", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    F.fromHorizontal{side = "left", mode = "top", number = 5, enemy = {DB,SB}, speed_m = .9}
    F.fromHorizontal{side = "left", mode = "bottom", number = 5, enemy = {DB,SB}, speed_m = .9}
    F.fromHorizontal{side = "right", mode = "top", number = 5, enemy = {DB,SB}, speed_m = .9}
    F.fromHorizontal{side = "right", mode = "bottom", number = 5, enemy = {DB,SB}, speed_m = .9}
    LM.wait("noenemies")

    --Manzo's Pyramid Adaptation (original "pyramid" idea by manzo)

    local spaceship = --The big spaceship made of enemies, that will later be translated from text to an enemy table
    {
        "rrrrrrrrrdsrrrrrrrr",
        "rrrrrrrrrdsrrrrrrrr",
        "rdddddddddsssrrsssr",
        "rddrrrrrrrrrssssrsr",
        "rdddddddrrrrrrrrrsr",
        "rrrrrrddrrrsssssssr",
        "rrrdddddrrrsrrrrrrr",
        "rrrddrrrrrrsrsssssr",
        "rrrdddddddrsrsrrrsr",
        "rrrrrrrrddrsrsrsrsr",
        "rrrrrdddddrsrsrsrsr",
        "rddddddrrrrsssrsrsr",
        "rddrrrrrrrrrrrrsrsr",
        "rddddddddrssssssssr",
        "rrrrrrrddrsrrrrrrrr",
        "rrdddddddrsssssssrr",
        "rrdddddddrrrrrrrsrr",
        "rrddrrrrrrsssssssrr",
        "rrdddddddrsrrrrrrrr",
        "rrdddddddrsrsssssrr",
        "rrrrrrrddrsrsrrssrr",
        "rrrrdddddrsrsrrssrr",
        "rrrrddrrrrsrsrsssrr",
        "rrrrddrrrrsrsrsrrrr",
        "rrrrddrrrrsssrsrrrr",
        " rrrddddrrrrrrsrrr ",
        "  rrrrddrrrrrrsrr  ",
        "   rrrddrrrssssr   ",
        "    rrdddsssrrr    ",
        "     rrrrsrrrr     ",
        "      rrrsrrr      ",
        "       rrsrr       ",
        "        rsr        ",
        "         s         ",

    }

    --Create spaceship
    for i = Util.tableLen(spaceship), 1, -1 do
        local enemy_table

        enemy_table = LM.textToEnemies(spaceship[i])

        LM.wait(1.8)
        F.fromVertical{side = "bottom", mode = "center", speed_m = .1, enemy_x_margin = 52, number = Util.tableLen(enemy_table), enemy = enemy_table, ind_duration = 8, ind_side = 30}
    end

    LM.wait(10)
    INDICATOR_DEFAULT = 1
    --After spaceship
    for j = 1, 26 do
        local m

        if j%2 == 0 then m = 0 else m = 30 end

        F.fromHorizontal{side = "left", mode = "bottom", number = j/2, enemy = {SB}, screen_margin = m, enemy_y_margin = 60, speed_m = .4}
        F.fromHorizontal{side = "right", mode = "bottom", number = j/2, enemy = {SB}, screen_margin = m, enemy_y_margin = 60, speed_m = .4}
        LM.wait(1)
    end
    LM.wait("noenemies")
    LM.giveLives(5, "finished part")

    LM.stop()
    LM.start(level_functions.part_4)

end

--Part 4 - Violent Love with Friends
function level_functions.part_4()
    local p

    p = Util.findId("psycho")

    LM.level_part("Part 4 - Violent Love with Friends")
    LM.wait(3)

    LM.text(300, 260, "he's running away!!", 1, 150)
    LM.wait(2)
    LM.text(500, 460, "go get him!!", 1, 150)
    LM.wait(3)

    --Penguin shooter adaptation (original idea by yan)
    INDICATOR_DEFAULT = 1.25
    local all = 2*ORIGINAL_WINDOW_WIDTH+2*ORIGINAL_WINDOW_HEIGHT
    for i = 1, 60 do
        local _x, _y = LM.outsidePosition(all * i / 60)
        local en = {SB, DB}
        local p = (i % 2) + 1
        F.single{enemy = en[p], x = _x, y = _y, dir_follow = true, speed_m = 3, ind_side = 25, score_mul = 2}
        _x, _y = LM.outsidePosition(all * (60 - i) / 60)
        F.single{enemy = en[3 - p], x = _x, y = _y, dir_follow = true, speed_m = 3, ind_side = 25, score_mul = 2}
        LM.wait(.8)
    end

    LM.wait("noenemies")
    LM.wait(1)
    LM.text(600, 260, "nevermind", 1, 150)
    LM.wait(2)
    LM.text(ORIGINAL_WINDOW_WIDTH/2 - 70, ORIGINAL_WINDOW_HEIGHT/2 - 10, "I'LL GET HIM", 1.5, 230, GUI_MEDPLUS)
    LM.wait(3)
    Boss.create()

    LM.wait(10)
    LM.wait("nobosses")
    print("end of level")
    LM.stop()

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("LOST IN DARKNESS")
    Audio.playBGM(BGM_LEVEL_2)

end


function level_functions.startPositions()
    local x, y

    x, y = 404, 321 --'O' of "Lost"

    return x,y
end

--Return level function
return level_functions
