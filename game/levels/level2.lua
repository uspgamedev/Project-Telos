local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Audio = require "audio"

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
    LM.level_part("Part 1 - A Cross the Goroba")

    LM.wait(3)
    INDICATOR_DEFAULT = 1.5
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2, y =  -20, dy = 1, number = 120, ind_duration = 2.5, speed_m = 1.3, ind_side = 35}
    F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, ind_duration = 2.5, speed_m = 1.3, ind_side = 35}
    LM.wait(9)
    F.line{enemy = {SB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 38, ind_mode = false, speed_m = 1.3, enemy_margin = 60}
    LM.wait(2)
    F.fromHorizontal{enemy = {SB}, side = "right", mode = "top" , number = 7, ind_duration = 6}
    LM.wait(6.2)
    for i = 1,9 do
        if i == 4 then
            F.line{enemy = {DB}, x = - 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 76, ind_duration = 2.5, speed_m = 1.3, ind_side = 35}            
        end
        F.fromHorizontal{enemy = {DB}, side = "right", mode = "top" , number = 7, ind_mode = false, ind_mode = false}
        LM.wait(.2)
    end
    LM.wait(2)
    LM.wait("noenemies")
    print("end of level")

    LM.stop()

end

--Return level function
return script
