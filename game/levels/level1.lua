local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

--Level script
function script()
    --Start Level
    Formation.fromLeft("distribute", SB, 5)
    LM.wait(4)
    Formation.fromLeft("distribute", SB, 7)
    LM.wait("noenemies")

    print("end of level")

    LM.stop()

end

--Return level function
return script
