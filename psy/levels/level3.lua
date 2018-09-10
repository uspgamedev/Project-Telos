local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"

local level_functions = {}

--LEVEL 2--

--3-1: Freedom Lost
function level_functions.part_1()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    LM.level_part("Part 1 - Freedom Lost")

    LM.wait(5.5)

    F.fromHorizontal{enemy = {GrB}, side = "left", mode = "center" , number = 7, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 7, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromVertical{enemy = {GrB}, side = "top", mode = "center" , number = 7, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    F.fromVertical{enemy = {GrB}, side = "bottom", mode = "center" , number = 7, ind_duration = 3, ind_side = 40, speed_m = 2.2, e_radius = 25, enemy_x_margin = 50, enemy_y_margin = 50}
    LM.wait(5)


    local cage = F.cage{radius = 180, speed_radius = 400}

    LM.wait(3)

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
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2, enemy = DB, number = 8, life = 20, duration = 15, rot_angle = math.pi/4, speed_m = 2, ind_duration = 2, e_speed_m = .8, ind_side = 35}
    LM.wait("noenemies")
    F.turret{x = WINDOW_WIDTH + 60, y = WINDOW_HEIGHT/2 - 100, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2 - 100, enemy = SB, number = 10, life = 15, duration = 15, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5, fps = 1.2, e_speed_m = .7}
    F.turret{x = WINDOW_WIDTH + 60, y = WINDOW_HEIGHT/2 + 100, t_x = WINDOW_WIDTH/2, t_y = WINDOW_HEIGHT/2 + 100, enemy = SB, number = 10, life = 15, duration = 15, rot_angle = math.pi/5, speed_m = 2, ind_duration = 1.5, fps = 1.2, e_speed_m = .7}
    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1

    F.turret{x = -60, y = 300, t_x = 100, t_y = 300, enemy = SB, number = 10, life = 10, duration = 28, rot_angle = math.pi/6, speed_m = 1.6}
    F.turret{x = WINDOW_WIDTH + 60, y = 300, t_x = WINDOW_WIDTH - 100, t_y = 300, enemy = SB, number = 12, life = 10, duration = 28, rot_angle = math.pi/6, speed_m = 1.6}
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = 100, enemy = DB, number = 10, life = 20, duration = 28, rot_angle = math.pi/5, speed_m = 2}
    LM.wait(8)
    cage:goTo(WINDOW_WIDTH/2, 100, 50)
    LM.wait(5)
    F.turret{x = -60, y = WINDOW_HEIGHT - 200, t_x = 100, t_y = WINDOW_HEIGHT - 200, enemy = GlB, number = 1, life = 8, duration = 15, start_angle = math.pi/2, speed_m = 2, fps = .5, e_speed = 1}
    F.turret{x = WINDOW_WIDTH+60, y = WINDOW_HEIGHT - 200, t_x = WINDOW_WIDTH - 100, t_y = WINDOW_HEIGHT - 200, enemy = GlB, number = 1, life = 8, duration = 15, start_angle = -math.pi/2, speed_m = 2, fps = .5, e_speed = 1}
    LM.wait(3)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT)
    F.turret{x = -60, y = WINDOW_HEIGHT - 50, t_x = 100, t_y = WINDOW_HEIGHT - 50, enemy = SB, number = 10, life = 12, duration = 12, rot_angle = math.pi/5, speed_m = 1.2}
    F.turret{x = WINDOW_WIDTH + 60, y = WINDOW_HEIGHT - 50, t_x = WINDOW_WIDTH - 100, t_y = WINDOW_HEIGHT - 50, enemy = SB, number = 12, life = 10, duration = 12, rot_angle = math.pi/5, speed_m = 1.2}
    LM.wait(14)
    F.turret{x = 300, y = -60, t_x = 300, t_y = 200, enemy = GlB, number = 10, life = 20, duration = 18, rot_angle = math.pi/5, speed_m = 1.5, fps = .7}
    F.turret{x = WINDOW_WIDTH - 300, y = -60, t_x = WINDOW_WIDTH - 300, t_y = 200, enemy = GlB, number = 10, life = 20, duration = 18, rot_angle = math.pi/5, speed_m = 1.5, fps = .7}
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = 100, enemy = GlB, number = 12, life = 25, duration = 18, rot_angle = math.pi/6, speed_m = 1.5, fps = .7}
    LM.wait(2)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 24)
    LM.wait("noenemies")
    F.fromVertical{enemy = {GrB}, side = "bottom", mode = "center" , number = 7, ind_duration = 2, ind_side = 40, speed_m = .3}

    LM.wait(6)
    cage:resize(260, 50)

    LM.wait(3)
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:goTo(100, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 20, enemy = {SB,DB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(1)
    cage:resize(100, 100)
    LM.wait(3)
    F.circle{radius = 640, number = 20, enemy = {DB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(260)
    cage:goTo(WINDOW_WIDTH - 100, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 21, enemy = {SB, SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(100)
    F.circle{radius = 640, number = 20, enemy = {DB, DB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(260)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 20, enemy = {SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .6}
    LM.wait(4)

    cage:resize(90, 50)
    F.line{x = -25, y = WINDOW_HEIGHT/2, dx = 1, number = 126, enemy = {GlB}, ind_duration = 2, ind_side = 40}

    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(3)
    cage:resize(260,100)
    LM.wait(1)
    cage:goTo(100, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 20, enemy = {SB,DB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(1)
    cage:resize(100)
    LM.wait(3)
    F.circle{radius = 640, number = 20, enemy = {DB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(260)
    cage:goTo(WINDOW_WIDTH - 100, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 18, enemy = {SB, SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(100)
    F.circle{radius = 640, number = 21, enemy = {DB, DB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .8}
    LM.wait(4)
    cage:resize(260)
    cage:goTo(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 140)
    F.circle{radius = 640, number = 20, enemy = {SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .6}
    LM.wait(4)

    cage:resize(115,50)
    F.line{x = WINDOW_WIDTH/2, y = -25, dy = 1, number = 150, enemy = {GlB}, ind_duration = 1, ind_side = 40}
    LM.wait(2)
    F.line{x = -25, y = WINDOW_HEIGHT/2, dx = 1, number = 145, enemy = {GlB}, ind_mode = false, ind_side = 40}

    LM.wait(3)
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2, ind_side = 35, e_speed_m = .6}
    LM.wait(3)
    cage:resize(260,100)
    LM.wait(1)
    cage:move(-80, 0, 35)
    F.circle{radius = 640, number = 20, enemy = {SB,DB}, ind_duration = 2, ind_side = 35, e_speed_m = .3}
    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {DB, DB, SB}, ind_duration = 2, ind_side = 35, e_speed_m = .3}
    LM.wait(4)
    cage:move(160, 0, 35)
    F.circle{radius = 640, number = 21, enemy = {SB, SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .3}
    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {SB, DB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .3}
    LM.wait(4)
    cage:move(-80, 0, 35)
    F.circle{radius = 640, number = 20, enemy = {SB, GlB}, ind_duration = 2, ind_side = 35, e_speed_m = .3}
    LM.wait(5)

    cage:resize(93, 38)
    LM.wait(4.3)
    cage:kill()

    LM.wait("noenemies")
    LM.giveScore(1000, "finished part")

    LM.stop()
    LM.start(level_functions.part_2)
end

--3-2: //
function level_functions.part_2()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    p = Util.findId("psycho")

    LM.level_part("Part 2 - //")
    LM.wait(1)

    F.snake{segments = 7, positions = {{-100,200},{700,200},{100,100},{100,-200}}, ind_duration = 2, speed_m = .5, e_radius = 30, ind_side = 50, e_life = 1}

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
