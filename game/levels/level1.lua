local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

--Level script
function script()
    --Start Level
    Formation.line(SB, 10, 400, -40, 2, 10, 60)
    LM.wait("noenemies")
    print("end of level")

    LM.stop()

end

--Return level function
return script
