local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Audio = require "audio"
local Util = require "util"

--Enemies
local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

--LEVEL 2--

--Level script
function script()
    local p

    p = Util.findId("psycho")

    --Start Level
    LM.level_title("THERE AND BACK AGAIN")
    Audio.playBGM(BGM_LEVEL_2)

    --2-1: A Cross the Planes
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

    print("end of level")

    LM.stop()

end

--Return level function
return script
