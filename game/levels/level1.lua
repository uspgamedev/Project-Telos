local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

--Level script
function script()
    --Start Level
    LM.wait(2)
    Formation.fromHorizontal("left", "center", SB, 3, 10, 5)
    LM.wait(2)
    Formation.fromHorizontal("left", "center", SB, 4, 10, 5)
    LM.wait(2)
    Formation.fromHorizontal("left", "center", SB, 5, 10, 5)
    LM.wait(2)
    Formation.fromHorizontal("left", "center", SB, 6, 10, 5)
    LM.wait("noenemies")
    Formation.circle(SB, 20, 700)
    print("end of level")

    LM.stop()

end

--Return level function
return script
