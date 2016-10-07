local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"
local Audio = require "audio"

--Enemies
local SB = require "classes.enemies.simple_ball"
local DB = require "classes.enemies.double_ball"

local level_functions = {}

--Boss
local Boss = require "classes.bosses.boss1"

--Levels
local level2 = require "levels.level2"

--LEVEL 1--

--Level script
function level_functions.script()
    local t
    --Start Level
    LM.level_title("I - THE FALL OF PSYCHO")
    Audio.playBGM(BGM_LEVEL_1)

    --1-1: The Start of the End
    LM.level_part("Part 1 - The Start of the End")


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
    LM.giveLives(2)

    --1-2: Circle madness
    LM.level_part("Part 2 - Circle Madness")

    LM.wait(1.5)
    F.circle{enemy = {SB}, number = 10, radius = 640, ind_duration = 2.5, ind_side = 25}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.circle{enemy = {SB,DB}, number = 20, radius = 640}
    LM.wait(6)

    F.circle{enemy = {SB}, number = 12, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {SB}, number = 12, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait(6.3)

    F.circle{enemy = {SB,DB,SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait(5.5)

    F.circle{enemy = {SB}, number = 15, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {DB,SB,DB}, number = 15, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait(5.5)

    F.circle{enemy = {SB, DB}, number = 18, radius = 800, enemy_margin = 0, x_center = 300}
    F.circle{enemy = {DB, SB}, number = 18, radius = 800, enemy_margin = 0, x_center = 700}
    LM.wait("noenemies")

    F.circle{enemy = {SB}, number = 90, radius = 640, enemy_margin = 100, speed_m = 2, ind_mode = "first", ind_duration = 3, ind_side = 35}
    LM.wait(5)
    F.circle{enemy = {SB, DB}, number = 80, radius = 640, enemy_margin = 100, speed_m = 2, ind_mode = "first", ind_duration = 2, ind_side = 35}
    LM.wait(6)

    INDICATOR_DEFAULT = 1.2
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

    F.circle{enemy = {SB}, number = 28, radius = 640, ind_duration = 2.5}
    LM.wait(2.5)
    INDICATOR_DEFAULT = 1.5
    F.circle{enemy = {SB,DB}, number = 28, radius = 640}
    LM.wait(1.5)
    F.circle{enemy = {DB}, number = 28, radius = 640}
    LM.wait("noenemies")
    LM.giveLives(3)

    --1-3: The Betrayal
    LM.level_part("Part 3 - The Betrayal")

    LM.wait(2)
    F.circle{enemy = {SB}, number = 15, radius = 640, ind_duration = 9, dir_follow = true, ind_side = 40}
    --Create aims for indicators
    for aim in pairs(Util.findSbTp("enemy_indicator")) do
        aim:create_aim()
    end
    LM.wait("noenemies")

    F.fromVertical{side = "top", mode = "center", enemy = {DB}, number = 21, enemy_x_margin = 40, enemy_y_margin = 40}
    F.fromVertical{side = "bottom", mode = "center", enemy = {SB}, number = 21, enemy_x_margin = 40, enemy_y_margin = 40}
    LM.wait(1)
    F.fromHorizontal{side = "right", mode = "distribute", number = 15, ind_duration = 4, dir_follow = true, enemy = {SB}, speed_m = 1.5}
    F.fromHorizontal{side = "left", mode = "distribute", number = 15, ind_duration = 4, dir_follow = true, enemy = {DB}, speed_m = 1.5}
    LM.wait(6)

    F.line{ x = -25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = ORIGINAL_WINDOW_WIDTH/2 , y = -25, dy = 1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = ORIGINAL_WINDOW_WIDTH/2 , y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = -25 , y = -25, dx = 1, dy = 1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = ORIGINAL_WINDOW_WIDTH + 25 , y = -25, dx = -1, dy = 1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = ORIGINAL_WINDOW_WIDTH + 25 , y = ORIGINAL_WINDOW_HEIGHT + 25, dx = -1, dy = -1, number = 40, enemy = {DB}, speed_m = .8}
    F.line{ x = - 25 , y = ORIGINAL_WINDOW_HEIGHT + 25, dx = 1, dy = -1, number = 40, enemy = {DB}, speed_m = .8}
    LM.wait(4)
    F.fromHorizontal{side = "left", mode = "center", enemy = {SB}, number = 20, enemy_x_margin = 60, enemy_y_margin = 40, speed_m = .6}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "center", enemy = {SB}, number = 20, enemy_x_margin = 60, enemy_y_margin = 40, speed_m = .6}
    LM.wait(1)
    F.fromHorizontal{side = "left", mode = "center", enemy = {SB}, number = 20, enemy_x_margin = 60, enemy_y_margin = 40, speed_m = .6}
    LM.wait("noenemies")

    F.circle{enemy = {SB,DB}, number = 190, radius = 640, enemy_margin = 40, speed_m = .9, ind_mode = "first", ind_duration = 2, ind_side = 35}

    LM.wait(3)
    F.fromHorizontal{side = "left", mode = "top", number = 6, enemy = {DB}, speed_m = 1.5}
    F.fromVertical{side = "top", mode = "left", number = 6, enemy = {DB}, speed_m = 1.5}
    LM.wait(3)
    F.fromHorizontal{side = "right", mode = "top", number = 6, enemy = {DB}, speed_m = 1.5}
    F.fromVertical{side = "top", mode = "right", number = 6, enemy = {DB}, speed_m = 1.5}
    LM.wait(3)
    F.fromHorizontal{side = "right", mode = "bottom", number = 6, enemy = {DB}, speed_m = 1.5}
    F.fromVertical{side = "bottom", mode = "right", number = 6, enemy = {DB}, speed_m = 1.5}
    LM.wait(3)
    F.fromHorizontal{side = "left", mode = "bottom", number = 6, enemy = {DB}, speed_m = 1.5}
    F.fromVertical{side = "bottom", mode = "left", number = 6, enemy = {DB}, speed_m = 1.5}

    LM.wait(4)
    F.fromHorizontal{side = "left", mode = "top", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    F.fromVertical{side = "top", mode = "left", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    LM.wait(2)
    F.fromHorizontal{side = "right", mode = "top", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    F.fromVertical{side = "top", mode = "right", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    LM.wait(2)
    F.fromHorizontal{side = "right", mode = "bottom", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    F.fromVertical{side = "bottom", mode = "right", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    LM.wait(2)
    F.fromHorizontal{side = "left", mode = "bottom", number = 8, enemy = {DB,SB}, speed_m = 1.2}
    F.fromVertical{side = "bottom", mode = "left", number = 8, enemy = {DB,SB}, speed_m = 1.2}

    LM.wait(4)
    F.fromHorizontal{side = "left", mode = "top", number = 10, enemy = {SB}}
    F.fromVertical{side = "top", mode = "left", number = 10, enemy = {SB}}
    F.fromHorizontal{side = "right", mode = "bottom", number = 10, enemy = {SB}}
    F.fromVertical{side = "bottom", mode = "right", number = 10, enemy = {SB}}
    LM.wait(4)
    F.fromHorizontal{side = "right", mode = "top", number = 10, enemy = {SB}}
    F.fromVertical{side = "top", mode = "right", number = 10, enemy = {SB}}
    F.fromHorizontal{side = "left", mode = "bottom", number = 10, enemy = {SB}}
    F.fromVertical{side = "bottom", mode = "left", number = 10, enemy = {SB}}
    LM.wait(2)
    LM.wait("noenemies")

    F.line{x = -25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, number = 190, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = ORIGINAL_WINDOW_WIDTH + 25, y = ORIGINAL_WINDOW_HEIGHT/2, dx = -1, number = 170, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = ORIGINAL_WINDOW_WIDTH/2 , y = -25, dy = 1, number = 150, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = ORIGINAL_WINDOW_WIDTH/2 , y = ORIGINAL_WINDOW_HEIGHT + 25, dy = -1, number = 130, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = -25 , y = -25, dx = 1, dy = 1, number = 110, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = ORIGINAL_WINDOW_WIDTH + 25 , y = -25, dx = -1, dy = 1, number = 90, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = ORIGINAL_WINDOW_WIDTH + 25 , y = ORIGINAL_WINDOW_HEIGHT + 25, dx = -1, dy = -1, number = 70, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = - 25 , y = ORIGINAL_WINDOW_HEIGHT + 25, dx = 1, dy = -1, number = 50, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(6)
    F.fromVertical{side = "bottom", mode = "center", number = 20, ind_duration = 2, enemy = {SB}, speed_m = .6}
    LM.wait(.2)
    F.fromVertical{side = "bottom", mode = "center", number = 20, ind_duration = 2, enemy = {SB}, speed_m = .6}
    LM.wait(4)
    F.fromVertical{side = "bottom", mode = "center", number = 20, ind_duration = 2, speed_m = .5, enemy = {DB}}
    LM.wait(.3)
    F.fromVertical{side = "bottom", mode = "center", number = 20, ind_duration = 2, speed_m = .5, enemy = {DB}}
    LM.wait("noenemies")

    LM.wait(1)
    for i= 1, 30 do
        local _x, _y = LM.outsidePosition(love.math.random(2*ORIGINAL_WINDOW_WIDTH+2*ORIGINAL_WINDOW_HEIGHT+1)-1)
        if i == 1 then
            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 5, ind_side = 35, ind_duration = 2.5}
            LM.wait(3)
        elseif i <= 4 then
            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 5, ind_side = 35}
            LM.wait(3)
        elseif i <= 15 then
            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 6, ind_side = 35}
            LM.wait(1)
        elseif i <= 20 then
            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 7, ind_side = 35}
            LM.wait(.8)
        else
            F.single{enemy = SB, x = _x, y = _y, dir_follow = true, speed_m = 8, ind_side = 35}
            LM.wait(.6)
        end
    end
    LM.wait("noenemies")
    LM.giveLives(5)

    --1-4: The Big One
    LM.level_part("Part 4 - The Big One")

    LM.wait(2)
    Boss.create()
    LM.wait(20)
    LM.wait("nobosses")
    LM.wait(2)
    LM.giveLives(5)
    LM.stop()
    LM.start(level2.script)

end

function level_functions.startPositions()
    local x, y

    if love.math.random() >= .9 then
        x, y = 787, 321 --'O' of "Of"
    else
        x, y = 662, 424 --'O' of "Psycho"
    end

    return x,y
end

--Return level function
return level_functions
