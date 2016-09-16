local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"

--Enemies
local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

--LEVEL 1--

--Level script
function script()
    local t
    --Start Level
    LM.level_title("I - THE FALL OF PSYCHO")
    --1-2: Circle madness
    LM.level_part("Part 2 - Circle Madness")

    LM.wait(4)
    F.single{enemy = DB, x = -10, y = ORIGINAL_WINDOW_HEIGHT/2, speed_m = 2, dir_follow = true}
    LM.wait("noenemies")
    F.circle{enemy = SB, number = 10, radius = 640, dir_follow = true}
    LM.wait("noenemies")
    F.circle({enemy = DB, number = 20, radius = 640})
    LM.wait("noenemies")
    F.circle{enemy = DB, number = 20, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = SB, number = 20, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")
    F.circle{enemy = SB, number = 20, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = DB, number = 20, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")
    F.circle{enemy = SB, number = 80, radius = 640, enemy_margin = 100, speed_m = 2}
    LM.wait(5)
    F.circle{enemy = DB, number = 70, radius = 640, enemy_margin = 100, speed_m = 2}
    LM.wait(6)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = SB, number = 9, speed_m = 1.5}
    LM.wait(3.5)
    F.fromHorizontal{side = "right", mode = "distribute", enemy = SB, number = 9, speed_m = 1.5}
    LM.wait(4)
    F.fromHorizontal{side = "left", mode = "top", enemy = DB, number = 9, enemy_x_margin = 0, enemy_y_margin = 40, screen_margin = 40, speed_m = 1.5}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = DB, number = 9, enemy_x_margin = 0, enemy_y_margin = 40, screen_margin = 40, speed_m = 1.5}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "center", enemy = SB, number = 11, enemy_x_margin = 40, enemy_y_margin = 40, screen_margin = 0, speed_m = 1.5}
    F.fromVertical{side = "bottom", mode = "left", enemy = SB, number = 9, enemy_x_margin = 40, enemy_y_margin = 0, screen_margin = 0, speed_m = 1.5}
    F.fromVertical{side = "bottom", mode = "right", enemy = SB, number = 9, enemy_x_margin = 40, enemy_y_margin = 0, screen_margin = 0, speed_m = 1.5}
    LM.wait(.8)
    F.fromVertical{side = "top", mode = "center", enemy = DB, number = 11, enemy_x_margin = 40, enemy_y_margin = 40, screen_margin = 0, speed_m = 1.5}
    LM.wait("noenemies")
    F.circle{enemy = DB, number = 50, radius = 640}
    LM.wait(1.5)
    F.circle{enemy = SB, number = 50, radius = 640}
    LM.wait(1.5)
    F.circle{enemy = DB, number = 50, radius = 640}
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
