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

    --Start Level
    LM.level_title("THERE AND BACK AGAIN")
    Audio.playBGM(BGM_LEVEL_2)

    --2-1: Cool level
    LM.level_part("Part 1 - A Cross the Planes")

    LM.wait(.1)
    INDICATOR_DEFAULT = 1.5
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 200, ind_duration = 2.5, speed_m = 1.5, ind_side = 35}
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, ind_duration = 2.5, speed_m = 1.5, ind_side = 35}

    LM.wait(8.15)
    --Make traverse easy
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, ind_mode = false, speed_m = 1.5, enemy_margin = 70}
    LM.wait(2)

    --Choose mode based on psycho position
    local chosen_mode
    if Util.findId("psycho").pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_mode = "top"
    else
        chosen_mode = "bottom"
    end

    F.fromHorizontal{enemy = {DB}, side = "right", mode = chosen_mode , number = 7, ind_duration = 5.1, ind_side = 40, speed_m = 1.5}
    LM.wait(4.55)
    --Make traverse difficult
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 48, speed_m = 1.5, ind_mode = false}
    LM.wait(.55)
    for i = 1,9 do
        LM.wait(.3)
        F.fromHorizontal{enemy = {DB}, side = "right", mode = chosen_mode , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
    end

    LM.wait(3.9)
    --Make traverse easy
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 20, ind_mode = false, speed_m = 1.5, enemy_margin = 70}
    LM.wait(1)

    --Choose mode based on psycho position
    if Util.findId("psycho").pos.y < ORIGINAL_WINDOW_HEIGHT/2 then
        chosen_mode = "top"
    else
        chosen_mode = "bottom"
    end

    F.fromHorizontal{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_duration = 2.5, ind_side = 40, speed_m = 1.5}
    LM.wait(2.45)
    --Make traverse difficult
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 120, speed_m = 1.5, ind_mode = false}
    LM.wait(.2)
    for i = 1,9 do
        LM.wait(.3)
        F.fromHorizontal{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
    end


    LM.wait(1)
    --Make traverse easy
    F.line{enemy = {SB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 20, ind_duration = 2.5, speed_m = 1.5, ind_side = 35}
    LM.wait(3)
    --Make traverse difficult
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 60, ind_duration = 2.5, speed_m = 1.5, ind_side = 35}

    --Choose mode based on psycho position
    if Util.findId("psycho").pos.x < ORIGINAL_WINDOW_WIDTH/2 then
        chosen_mode = "left"
    else
        chosen_mode = "right"
    end

    F.fromHorizontal{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_duration = 2.5, ind_side = 40, speed_m = 1.5}
    for i = 1,9 do
        LM.wait(.3)
        F.fromVertical{enemy = {DB}, side = "left", mode = chosen_mode , number = 7, ind_mode = false, ind_mode = false, speed_m = 1.5}
    end


    LM.wait("noenemies")
    print("end of level")

    LM.stop()

end

--Return level function
return script
