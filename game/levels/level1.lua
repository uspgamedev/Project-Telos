local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"

--Enemies
local SB = require "classes.enemies.simple_ball"

--LEVEL 1--

--Level script
function script()
    local t
    --Start Level
    LM.level_title("I - THE FALL OF PSYCHO")
    --1-2: Circle madness
    LM.level_part("Part 2 - Circle Madness")

    LM.wait(6)
    F.circle(SB, 20, 800, 0, 300)
    LM.wait(1)
    F.circle(SB, 20, 800, 0, 700)
    LM.wait(6)
    F.circle(SB, 20, 800, 0, 300)
    F.circle(SB, 20, 800, 0, 700)
    LM.wait(5)
    F.circle(SB, 80, 800, 100, nil, nil, 2)
    LM.wait(5)
    F.circle(SB, 70, 800, 100, nil, nil, 2)
    LM.wait(6)
    F.fromHorizontal("left", "distribute", SB, 9, nil, nil, nil, 1.5)
    LM.wait(3.5)
    F.fromHorizontal("right", "distribute", SB, 9, nil, nil, nil, 1.5)
    LM.wait(4)
    F.fromHorizontal("left", "top", SB, 9, 0, 40, 40, 1.5)
    F.fromHorizontal("right", "bottom", SB, 9, 0, 40, 40, 1.5)
    LM.wait(4)
    F.fromVertical("top", "center", SB, 11, 40, 40, 0, 1.5)
    F.fromVertical("bottom", "left", SB, 9, 40, 0, 0, 1.5)
    F.fromVertical("bottom", "right", SB, 9, 40, 0, 0, 1.5)
    LM.wait(.8)
    F.fromVertical("top", "center", SB, 11, 40, 40, 0, 1.5)
    LM.wait("noenemies")
    F.circle(SB, 50, 800)
    LM.wait(1)
    F.circle(SB, 50, 800)
    LM.wait(1)
    F.circle(SB, 50, 800)
    LM.wait("noenemies")

    print("end of level")
    --[[t = Text(240, 200, "FELIZ ANIVERSARIO YAN", GUI_BIG, Color.red())
    t:addElement(DRAW_TABLE.GUI)
    t = Text(10, 300, "VOCE EH UM DOS MEUS MELHORES AMIGOS", GUI_BIG, Color.orange())
    t:addElement(DRAW_TABLE.GUI)
    t = Text(340, 400, "VALEU CARA <3", GUI_BIG, Color.pink())
    t:addElement(DRAW_TABLE.GUI)]]--

    LM.stop()

end

--Return level function
return script
