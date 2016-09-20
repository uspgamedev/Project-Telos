local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"

--Enemies
local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

--LEVEL 2--

--Level script
function script()

    --Start Level
    LM.level_title("II - THERE AND BACK AGAIN")

    --2-1: Cool level
    LM.level_part("Part 1 - Cool level")

    --LM.wait(4)
    F.line{enemy = {DB, SB}, x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 20, ind_mode = "first", ind_duration = 4, dir_follow = true}
    LM.wait(7)
    LM.wait("noenemies")
    LM.stop()

end

--Return level function
return script
