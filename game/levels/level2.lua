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
    LM.level_title("END OF LEVEL  U DA BEST")

    --2-1: Cool level
    LM.level_part("Part 1 - Cool level")

    LM.wait(7)
    LM.wait("noenemies")
    LM.stop()

end

--Return level function
return script
