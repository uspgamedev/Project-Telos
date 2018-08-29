local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"

local level_functions = {}

--LEVEL 2--

--2-1: A Cross the Planes
function level_functions.part_1()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    LM.level_part("Part 1 - Freedom Lost")
    --[[
    LM.wait(5.5)

    F.fromHorizontal{enemy = {GrB}, side = "left", mode = "center" , number = 8, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 8, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromVertical{enemy = {GrB}, side = "top", mode = "center" , number = 8, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromVertical{enemy = {GrB}, side = "bottom", mode = "center" , number = 8, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    LM.wait(5)
    ]]--

    local cage = F.cage{radius = 180, speed_radius = 400}

    LM.wait(3)
    --[[
    F.fromHorizontal{enemy = {SB}, side = "right", mode = "center" , number = 7, ind_duration = 3.2, ind_side = 40, speed_m = 1.5}
    LM.wait("noenemies")
    F.fromVertical{enemy = {DB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = 1.5}
    LM.wait("noenemies")
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2.5, ind_side = 35}
    LM.wait("noenemies")
    F.circle{radius = 640, number = 20, enemy = {SB, DB}, ind_duration = 2.5, ind_side = 35, dir_follow = true}
    LM.wait("noenemies")

    F.line{x = -25, y = WINDOW_HEIGHT/2, dx = 1, number = 107, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = WINDOW_WIDTH + 25, y = WINDOW_HEIGHT/2, dx = -1, number = 87, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = -25, y = WINDOW_HEIGHT/2, dx = 1, number = 70, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = WINDOW_WIDTH + 25, y = WINDOW_HEIGHT/2, dx = -1, number = 50, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = WINDOW_WIDTH/2 , y = WINDOW_HEIGHT+25, dy = -1, number = 30, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(4)
    F.line{x = WINDOW_WIDTH/2 , y = -25, dy = 1, number = 10, enemy = {DB,SB}, ind_duration = 2.5, dir_follow = true, ind_side = 40}
    LM.wait(8)

    F.fromVertical{enemy = {GrB}, side = "bottom", mode = "center" , number = 3, ind_duration = 2, ind_side = 40, speed_m = 1.6}
    LM.wait(2)
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "top" , number = 3, ind_duration = 1.5, ind_side = 40, speed_m = 1.4, screen_margin = 205}
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "bottom" , number = 3, ind_duration = 1.5, ind_side = 40, speed_m = 1.4, screen_margin = 205}
    LM.wait(3)
    F.fromVertical{enemy = {GrB,DB}, side = "top", mode = "center" , number = 7, ind_duration = 1.5, ind_side = 40, speed_m = 1.5}
    LM.wait(2.5)
    F.fromHorizontal{enemy = {GrB}, side = "left", mode = "center" , number = 7, ind_duration = 2, ind_side = 40, speed_m = .75, e_radius = 25, enemy_x_margin = 100, enemy_y_margin = 65}
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 7, ind_duration = 2, ind_side = 40, speed_m = .75, e_radius = 25, enemy_x_margin = 100, enemy_y_margin = 65}
    LM.wait(6)
    ]]--
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2, enemy = DB, number = 8, life = 20, duration = 15, rot_angle = math.pi/4, speed_m = 2, ind_duration = 2, e_speed_m = .8, ind_side = 35}
    LM.wait("noenemies")
    F.turret{x = WINDOW_WIDTH + 60, y = WINDOW_HEIGHT/2 - 100, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2 - 100, enemy = SB, number = 10, life = 15, duration = 15, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5, fps = 1.2, e_speed_m = .7}
    F.turret{x = WINDOW_WIDTH + 60, y = WINDOW_HEIGHT/2 + 100, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2 + 100, enemy = SB, number = 10, life = 15, duration = 15, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5, fps = 1.2, e_speed_m = .7}
    LM.wait("noenemies")
    F.turret{x = -60, y = 300, t_x = 100, t_y = 300, enemy = SB, number = 10, life = 10, duration = 30, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5}
    F.turret{x = WINDOW_WIDTH + 60, y = 300, t_x = WINDOW_WIDTH - 100, t_y = 300, enemy = SB, number = 10, life = 10, duration = 30, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5}
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = 100, enemy = DB, number = 10, life = 20, duration = 30, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5}
    LM.wait(8)
    cage:goTo(WINDOW_WIDTH/2, 100, 50)
    LM.wait(5)
    F.turret{x = -60, y = WINDOW_HEIGHT - 200, t_x = 100, t_y = WINDOW_HEIGHT - 200, enemy = GlB, number = 1, life = 10, duration = 14, start_angle = math.pi/2, speed_m = 2, ind_duration = 1.5, fps = .4, e_speed = 1}
    F.turret{x = WINDOW_WIDTH+60, y = WINDOW_HEIGHT - 200, t_x = WINDOW_WIDTH - 100, t_y = WINDOW_HEIGHT - 200, enemy = GlB, number = 1, life = 10, duration = 14, start_angle = -math.pi/2, speed_m = 2, ind_duration = 1.5, fps = .4, e_speed = 1}
    LM.wait(3)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT)
    LM.wait(2)
    --Stuff happens
    LM.wait(2)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT/2)
    LM.wait("noenemies")
    LM.stop()


end


---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("MADNESS ALL AROUND", "Chapter III")
    Audio.playBGM(BGM.level_3)

end


function level_functions.startPositions()
    local x, y

    x, y = 460, 425

    return x,y
end

--Return level function
return level_functions
