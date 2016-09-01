local Formation = require "formation"
local SB = require "classes.enemies.simple_ball"
local LM = require "level_manager"

--LEVEL 1--

function script()
    --Start Level
    Formation.fromLeft(SB, 1, 10, "center")
    print("1")
    LM.wait("noenemies")

    Formation.fromLeft(SB, 2, 10, "center")
    print("2")
    LM.wait("noenemies")

    Formation.fromLeft(SB, 3, 10, "center")
    print("3")
    LM.wait("noenemies")

    Formation.fromLeft(SB, 4, 10, "center")
    print("4")
    LM.wait("noenemies")

    Formation.fromLeft(SB, 8, 10, "center")
    print("5")

end

--Return level function
return script
