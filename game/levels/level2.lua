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

    LM.wait(2)
    F.circle{radius = 640, enemy = {DB}, number = 20, speed_m = .7}
    LM.wait(2)
    F.circle{radius = 640, enemy = {DB}, number = 20, speed_m = .7}
    LM.wait(2)
    F.fromVertical{side = "top", mode = "distribute", enemy = {DB, SB}, number = 20, speed_m = .7}
    LM.wait(2)
    F.fromVertical{side = "bottom", mode = "distribute", enemy = {DB, SB}, number = 20, speed_m = .7}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {DB, SB}, number = 16, speed_m = .7}
    LM.wait(1)
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {DB, SB}, number = 16, speed_m = .7}
    LM.wait("noenemies")
    print("end of level")

    LM.stop()

end

--Return level function
return script
