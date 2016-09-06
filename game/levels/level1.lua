local F = require "formation"
local LM = require "level_manager"
--Enemies
local SB = require "classes.enemies.simple_ball"

--LEVEL 1--

--Level script
function script()
    --Start Level

    --1-2: Circle madness
    LM.wait(1)
    F.circle(SB, 20, 800, 0, 300, nil)
    LM.wait(1)
    F.circle(SB, 20, 800, 0, 700, nil)
    LM.wait(6)
    F.circle(SB, 20, 800, 0, 300, nil)
    F.circle(SB, 20, 800, 0, 700, nil)
    LM.wait("noenemies")
    F.circle(SB, 30, 800, 100, nil, nil, 2)
    LM.wait(8)
    F.circle(SB, 55, 800, 100, nil, nil, 1.8)
    LM.wait(3)
    F.fromHorizontal("left", "distribute", SB, 9, nil, nil, nil, 1.5)
    LM.wait(4)
    F.fromHorizontal("right", "distribute", SB, 9, nil, nil, nil, 1.5)
    LM.wait(4)
    F.fromHorizontal("left", "top", SB, 9, 0, 40, 40, 1.5)
    F.fromHorizontal("right", "bottom", SB, 9, 0, 40, 40, 1.5)
    LM.wait(3)
    F.fromVertical("top", "center", SB, 11, 40, 40, 0, 1.5)
    F.fromVertical("bottom", "left", SB, 9, 40, 0, 0, 1.5)
    F.fromVertical("bottom", "right", SB, 9, 40, 0, 0, 1.5)
    LM.wait("noenemies")
    print("end of level")

    LM.stop()

end

--Return level function
return script
