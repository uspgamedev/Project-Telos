local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

--Level script
function script()
    --Start Level
    LM.wait(2)
    Formation.fromVertical("t", "center", SB, 3, 50, 10)
    LM.wait(2)
    Formation.fromVertical("b", "center", SB, 3, 50, 10)
    LM.wait(2)
    Formation.fromVertical("t", "center", SB, 3, 50)
    LM.wait(2)
    Formation.fromVertical("b", "center", SB, 3, 50)
    LM.wait(2)
    Formation.fromVertical("t", "left", SB, 5, 50, 10)
    LM.wait(2)
    Formation.fromVertical("b", "right", SB, 5, 50, 10)
    LM.wait(2)
    Formation.fromVertical("t", "left", SB, 5, 50)
    LM.wait(2)
    Formation.fromVertical("b", "right", SB, 5, 50)
    LM.wait("noenemies")
    Formation.circle(SB, 20, 700)
    print("end of level")

    LM.stop()

end

--Return level function
return script
