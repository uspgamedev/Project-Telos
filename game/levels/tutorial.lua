local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"
local Audio = require "audio"

local level_functions = {}

--Levels
local level1 = require "levels.level1"

--TUTORIAL--

--Tutorial main part
function level_functions.part_1()

    FIRST_TIME = false

    LM.level_part("Learning the ropes")

    LM.wait(4)
    INDICATOR_DEFAULT = 1.5
    F.single{enemy = SB, x = -20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0, e_radius = 28, ind_duration = 2, ind_side = 35}
    LM.wait("noenemies")

    F.single{enemy = SB, x = -20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0}
    F.single{enemy = SB, x = ORIGINAL_WINDOW_WIDTH + 20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, dy = 0}
    LM.wait(1.5)
    F.circle{enemy = {SB}, number = 4, radius = 610}
    LM.wait("noenemies")

    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(1)
    INDICATOR_DEFAULT = 1.2
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(.8)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(.6)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 1.5}
    LM.wait(.4)
    F.fromHorizontal{side = "left", mode = "center", number = 9, enemy_x_margin = 25, enemy_y_margin = 90, enemy = {SB}, speed_m = 2}
    LM.wait(1.5)
    F.fromHorizontal{side = "right", mode = "distribute", number = 16, enemy = {SB}, speed_m = 1.5}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.fromVertical{side = "bottom", mode = "left", number = 9, enemy = {SB}}
    F.fromVertical{side = "bottom", mode = "right", number = 9, enemy = {SB}}
    F.fromVertical{side = "top", mode = "left", number = 9, enemy = {SB}}
    F.fromVertical{side = "top", mode = "right", number = 9, enemy = {SB}}
    LM.wait(1)
    INDICATOR_DEFAULT = 1.2
    F.fromHorizontal{side = "left", mode = "center", number = 11, enemy = {SB}}
    F.fromHorizontal{side = "right", mode = "center", number = 11, enemy = {SB}}
    F.fromVertical{side = "top", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    F.fromVertical{side = "bottom", mode = "center", number = 5, enemy = {SB}, speed_m = .9}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.single{enemy = DB, x = ORIGINAL_WINDOW_WIDTH/2, y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, e_radius = 28}
    LM.wait("noenemies")

    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 36, ind_side = 35}
    LM.wait(5)
    F.fromVertical{side = "top", mode = "center", enemy = {DB}, number = 20, speed_m = .55}
    LM.wait(3)
    F.fromHorizontal{side = "left", mode = "center", enemy = {DB}, number = 14, speed_m = 1.2}
    LM.wait("noenemies")

    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2 - 200, y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, number = 56, ind_side = 35}
    F.line{enemy = {DB}, x = ORIGINAL_WINDOW_WIDTH/2 + 200, y = - 25, dy = 1, number = 56, ind_side = 35}
    LM.wait(4)
    INDICATOR_DEFAULT = 1.2
    F.fromVertical{side = "top", mode = "distribute", number = 9, enemy = {SB}, speed_m = 1.3}
    F.fromVertical{side = "bottom", mode = "distribute", number = 9, enemy = {SB}, speed_m = 1.3}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "distribute", number = 14, enemy = {SB, DB}, speed_m = 1.2}
    F.fromVertical{side = "bottom", mode = "distribute", number = 14, enemy = {SB, DB}, speed_m = 1.2}
    LM.wait(4)
    F.fromVertical{side = "top", mode = "distribute", number = 12, enemy = {DB}, speed_m = .9}
    F.fromVertical{side = "bottom", mode = "distribute", number = 12, enemy = {DB}, speed_m = .9}
    LM.wait("noenemies")
    LM.giveLives(2, "finished part")

    LM.stop()
    LM.start(level1.part_1)

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("WELCOME TO PSYCHO")
    Audio.playBGM(BGM_LEVEL_1)

end

function level_functions.startPositions()
    local x, y

    --if love.math.random() >= .9 then
    --    x, y = 787, 321 --'O' of "Welcome"
    --elseif love.math.random() >= .8 then
    --    x, y = 662, 424 --'O' of "To"
    --else
        x, y = 662, 424 --'O' of "Psycho"
    --end

    return x,y
end

--Return level function
return level_functions
