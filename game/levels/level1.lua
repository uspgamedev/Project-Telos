local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"

--Enemies
local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

--Level

local level2 = require "levels.level2"

--LEVEL 1--

--Level script
function script()
    local t
    --Start Level
    LM.level_title("I - THE FALL OF PSYCHO")

    --1-1: The Start of the End
    LM.level_part("Part 1 - The Start of the End")

    LM.wait(3)

    F.single{enemy = SB, x = -25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0}
    LM.wait("noenemies+")

    F.single{enemy = SB, x = -25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0}
    F.single{enemy = SB, x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, dy = 0}
    LM.wait("noenemies+")

    F.circle{enemy = {SB}, number = 4, radius = 640}
    LM.wait("noenemies+")

    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(1.5)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(1.4)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(1.3)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(1.2)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 2}
    LM.wait("noenemies+")

    F.fromHorizontal{side = "right", mode = "distribute", number = 16, enemy = {SB}, speed_m = 1.5}
    LM.wait("noenemies+")

    F.fromVertical{side = "bottom", mode = "left", number = 9, enemy = {SB}}
    F.fromVertical{side = "bottom", mode = "right", number = 9, enemy = {SB}}
    F.fromVertical{side = "top", mode = "left", number = 9, enemy = {SB}}
    F.fromVertical{side = "top", mode = "right", number = 9, enemy = {SB}}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "center", number = 11, enemy = {SB}}
    F.fromHorizontal{side = "right", mode = "center", number = 11, enemy = {SB}}
    F.fromVertical{side = "top", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    F.fromVertical{side = "bottom", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    LM.wait("noenemies")

    --MAKE BIGGER
    LM.wait(1)
    F.single{enemy = DB, x = ORIGINAL_WINDOW_WIDTH/2, y = -25, dy = 1}
    LM.wait("noenemies")

    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 20}
    LM.wait("noenemies")

    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2 - 200, y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, number = 36}
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2 + 200, y = - 25, dy = 1, number = 36}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "distribute", number = 9, enemy = {SB}}
    F.fromVertical{side = "bottom", mode = "distribute", number = 9, enemy = {SB}}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "distribute", number = 14, enemy = {SB, DB}}
    F.fromVertical{side = "bottom", mode = "distribute", number = 14, enemy = {SB, DB}}
    LM.wait("noenemies+")

    --1-2: Circle madness
    LM.level_part("Part 2 - Circle Madness")

    LM.wait(2)
    F.circle{enemy = {SB}, number = 10, radius = 640}
    LM.wait("noenemies")

    F.circle{enemy = {SB,DB}, number = 20, radius = 640}
    LM.wait("noenemies")

    F.circle{enemy = {SB}, number = 12, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {SB}, number = 12, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")

    F.circle{enemy = {SB,DB,SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")

    F.circle{enemy = {SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {DB,SB,DB}, number = 15, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")

    F.circle{enemy = {SB, DB}, number = 16, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {DB, SB}, number = 16, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")

    F.circle{enemy = {SB}, number = 80, radius = 640, enemy_margin = 100, speed_m = 2}
    LM.wait(5)
    F.circle{enemy = {SB, DB}, number = 70, radius = 640, enemy_margin = 100, speed_m = 2}
    LM.wait(6)
    F.fromHorizontal{side = "left", mode = "distribute", enemy = {SB}, number = 9, speed_m = 1.4}
    LM.wait(3.5)
    F.fromHorizontal{side = "right", mode = "distribute", enemy = {SB}, number = 9, speed_m = 1.4}
    LM.wait(4)
    F.fromHorizontal{side = "left", mode = "top", enemy = {SB,DB}, number = 9, enemy_x_margin = 0, enemy_y_margin = 40, screen_margin = 40, speed_m = 1.4}
    F.fromHorizontal{side = "right", mode = "bottom", enemy = {SB,DB}, number = 9, enemy_x_margin = 0, enemy_y_margin = 40, screen_margin = 40, speed_m = 1.4}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "center", enemy = {DB,SB}, number = 11, enemy_x_margin = 40, enemy_y_margin = 40, screen_margin = 0, speed_m = 1.4}
    F.fromVertical{side = "bottom", mode = "left", enemy = {SB}, number = 9, enemy_x_margin = 40, enemy_y_margin = 0, screen_margin = 0, speed_m = 1.4}
    F.fromVertical{side = "bottom", mode = "right", enemy = {SB}, number = 9, enemy_x_margin = 40, enemy_y_margin = 0, screen_margin = 0, speed_m = 1.4}
    LM.wait(.8)
    F.fromVertical{side = "top", mode = "center", enemy = {DB}, number = 11, enemy_x_margin = 40, enemy_y_margin = 40, screen_margin = 0, speed_m = 1.4}
    LM.wait("noenemies")

    F.circle{enemy = {SB}, number = 28, radius = 640}
    LM.wait(1.5)
    F.circle{enemy = {SB,DB}, number = 28, radius = 640}
    LM.wait(1.5)
    F.circle{enemy = {DB}, number = 28, radius = 640}
    LM.wait("noenemies")

    LM.wait(2)
    LM.stop()
    LM.start(level2)

end

--Return level function
return script
