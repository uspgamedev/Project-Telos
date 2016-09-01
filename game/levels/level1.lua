local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

--Level script
function script()
    --Start Level
    LM.wait(4)
    Formation.fromRight("distribute", SB, 5)
    Formation.fromLeft("distribute", SB, 7)
    LM.wait(5)
    Formation.fromRight("top", SB, 7, 5)
    Formation.fromLeft("bottom", SB, 12, 8)
    LM.wait(5)
    Formation.fromLeft("top", SB, 7, 5)
    Formation.fromRight("bottom", SB, 12, 8)
    LM.wait(5)
    Formation.fromLeft("center", SB, 7, 5, 10)
    Formation.fromRight("distribute", SB, 12)
    LM.wait("noenemies")

    print("end of level")

    LM.stop()

end

--Return level function
return script
