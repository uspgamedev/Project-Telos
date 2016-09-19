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

    LM.wait(6)
    print("end of level 2")
    LM.stop()

end

--Return level function
return script
