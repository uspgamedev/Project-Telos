local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"

local level_functions = {}

--LEVEL 3--

--Boss
local Boss = require "classes.bosses.boss3"

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
    F.circle{radius = 640, number = 20, enemy = {SB, DB}, ind_duration = 2.5, ind_side = 56, dir_follow = true}
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
    F.turret{x = 300, y = -60, t_x = 300, t_y = 200, enemy = GlB, number = 10, life = 20, duration = 18, rot_angle = math.pi/5, speed_m = 1.5, fps = .7, score_mul = .5}
    F.turret{x = WINDOW_WIDTH - 300, y = -60, t_x = WINDOW_WIDTH - 300, t_y = 200, enemy = GlB, number = 10, life = 20, duration = 18, rot_angle = math.pi/5, speed_m = 1.5, fps = .7, score_mul = .5}
    F.turret{x = WINDOW_WIDTH/2, y = -60, t_x = WINDOW_WIDTH/2, t_y = 100, enemy = GlB, number = 12, life = 25, duration = 18, rot_angle = math.pi/6, speed_m = 1.5, fps = .7, score_mul = .5}
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

--3-2: They came and then they left
function level_functions.part_2()
    local w, h = WINDOW_WIDTH, WINDOW_HEIGHT

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    local p = Util.findId("psycho")

    LM.level_part("Part 2 - They came and then they left")

    LM.wait(3.5)

    F.snake{segments = 7, positions = {{w + 100,h/2},{-100,h/2}}, ind_duration = 3, speed_m = .6, e_radius = 25, ind_side = 50, e_life = 3}

    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    F.snake{segments = 40, positions = {{w-50,-100},{w-50,h/2-50},{-100, h/2-50}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 40, positions = {{50,h+100},{50,h/2+50},{w+100, h/2+50}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 30, positions = {{-100,50},{w/2-50,50},{w/2-50, h+100}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 30, positions = {{w+100,h-50},{w/2+50,h-50},{w/2+50, -100}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 20, positions = {{50,-100},{50,h-50},{w+100,h-50}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 20, positions = {{w-50,h+100},{w-50,50},{-100,50}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 10, positions = {{w+100,200},{200,200},{200,h+100}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}
    LM.wait(1)
    F.snake{segments = 10, positions = {{-100,h-200},{w-200,h-200},{w-200,-100}}, speed_m = 1.1, ind_side = 50, e_life = 2,e_radius = 30}

    LM.wait(6.5)

    F.snake{segments = 27, positions = {{w/2,-100},{w/2,70},{w-70, 70},{w-70,h/2},{-100,h/2}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 27, positions = {{w+100,h/2},{w-70,h/2},{w-70, h-70},{70,h-70},{70,70},{w/2,70},{w/2,h+100}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 27, positions = {{w/2,h+100},{w/2,h-70},{70,h-70},{70,70},{w-70,70},{w-70,h-70},{70,h-70},{70,h/2},{w+100,h/2}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 27, positions = {{-100,h/2},{70,h/2},{70,70},{w-70,70},{w-70,h-70},{70,h-70},{70,70},{w-70,70},{w-70,h-70},{w/2,h-70},{w/2,-100}}, speed_m = .8, ind_side = 50, e_life = 2,e_radius = 40, score_mul = 2}

    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {SB,DB}, ind_duration = 1.5, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {DB}, ind_duration = 1.5, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 21, enemy = {SB,DB,GlB}, ind_duration = 1.5, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {DB,GlB}, ind_duration = 1.5, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 21, enemy = {DB,GlB,DB}, ind_duration = 1.5, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    F.circle{radius = 640, number = 15, enemy = {GlB}, ind_duration = 1, ind_side = 35,speed_m = .7, enemy_margin = 30}
    LM.wait(4)
    local _x = 55
    local gap = 140
    for i = 1, 7 do
        F.snake{segments = 5, positions = {{_x,-100},{_x,h+100}}, speed_m = .8, ind_side = 50, e_life = 2,e_radius = 40}
        _x = _x + gap
    end

    LM.wait("noenemies")

    INDICATOR_DEFAULT = 1.5
    local pos = {{w-60,h+100}}
    local x = w-50
    local gap = 71
    for i = 1, 8 do
        table.insert(pos,{x,50})
        table.insert(pos,{x-gap,50})
        table.insert(pos,{x-gap,h-50})
        table.insert(pos,{x-2*gap,h-50})
        x = x-2*gap
    end

    F.snake{segments = 75, positions = pos, speed_m = .9, ind_side = 50, e_life = 3,e_radius = 35, ind_duration = 1.5, score_mul = 2}

    LM.wait(7)
    F.fromHorizontal{enemy = {SB}, side = "left", mode = "center" , number = 11, ind_duration = 2, ind_side = 40, speed_m = .9, e_radius = 25, enemy_y_margin = 72}
    LM.wait(7)
    F.fromHorizontal{enemy = {SB,DB}, side = "left", mode = "center" , number = 10, ind_duration = 2, ind_side = 40, speed_m = .9, e_radius = 25, enemy_y_margin = 72}
    LM.wait(7)
    F.fromHorizontal{enemy = {DB}, side = "left", mode = "center" , number = 10, ind_duration = 2, ind_side = 40, speed_m = .9, e_radius = 25, enemy_y_margin = 72}
    LM.wait(7)
    F.fromHorizontal{enemy = {SB,GlB}, side = "left", mode = "center" , number = 10, ind_duration = 3, ind_side = 40, speed_m = .9, e_radius = 25, enemy_y_margin = 72}
    LM.wait(7)
    F.fromHorizontal{enemy = {DB,GlB,GlB,SB,GlB,GlB}, side = "left", mode = "center" , number = 10, ind_duration = 3, ind_side = 40, speed_m = .9, e_radius = 25, enemy_y_margin = 72}
    LM.wait(7)
    F.fromHorizontal{enemy = {GlB}, side = "left", mode = "center" , number = 11, ind_duration = 3, ind_side = 40, speed_m = .6, e_radius = 25, enemy_x_margin = 115, enemy_y_margin = 67}
    LM.wait(7)
    F.fromHorizontal{enemy = {GlB}, side = "right", mode = "center" , number = 11, ind_duration = 3, ind_side = 40, speed_m = .8, e_radius = 25, enemy_x_margin = 115, enemy_y_margin = 67}
    LM.wait(1)
    F.fromHorizontal{enemy = {GlB}, side = "right", mode = "center" , number = 11, ind_duration = 3, ind_side = 40, speed_m = .8, e_radius = 25, enemy_x_margin = 115, enemy_y_margin = 67}
    LM.wait(1)
    F.fromHorizontal{enemy = {GlB}, side = "right", mode = "center" , number = 11, ind_duration = 3, ind_side = 40, speed_m = .8, e_radius = 25, enemy_x_margin = 115, enemy_y_margin = 67}
    LM.wait(10)

    local y = 50
    local gap = 60
    for i = 1, 7 do
        F.snake{segments = 20, positions = {{w+100,y},{w/2,y},{w/2,y+gap},{-100,y+gap}}, speed_m = 1.6, ind_side = 50, e_life = 1, e_radius = 25, ind_duration = 1.5}
        y = y + 100
    end
    LM.wait("noenemies")

    --In-between snakes--

    --Make psycho go to snake height
    F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_duration = 2, ind_side = 50, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
    F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_duration = 2, ind_side = 50, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
    LM.wait(2.5)
    for i = 1, 3 do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
        LM.wait(.5)
    end
    --Make psycho go to the left
    F.fromVertical{enemy = {GlB}, side = "bottom", mode = "right" , number = 11, ind_duration = 2, ind_side = 60, speed_m = 2.2, e_radius = 30, enemy_x_margin = 80, screen_margin = 20}
    for i = 1, 5 do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
        LM.wait(.5)
    end
    --Start spamming both waves for a while before snakes enter
    for i = 1, 4 do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
        F.fromVertical{enemy = {GlB}, side = "bottom", mode = "right" , number = 11, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_x_margin = 80, screen_margin = 20}
        LM.wait(.5)
    end
    --Create both snakes
    local snake1 = F.snake{ind_mode = false, ind_duration = 3, segments = 225, speed_m = .4, e_life = 20, e_radius = 15,
        positions = {
            {-100,200},
            {w-50,200},
            {w-50,h-50},
            {50,h-50},
            {50,50},
            {w+100,50}
        }
    }
    local snake2 = F.snake{ind_mode = false, ind_duration = 3, segments = 225, speed_m = .4, e_life = 20, e_radius = 15,
        positions = {
            {-100,300},
            {w-150,300},
            {w-150,h-150},
            {150,h-150},
            {150,150},
            {w+100,150}
        }
    }
    --Continue spamming
    for i = 1, 7 do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
        F.fromVertical{enemy = {GlB}, side = "bottom", mode = "right" , number = 11, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_x_margin = 80, screen_margin = 20}
        LM.wait(.5)
    end
    --Create center snake
    F.snake{id = "center_snake", ind_size = 40, ind_duration = 3, segments = 35, speed_m = .28, e_life = 6, e_radius = 20, score_mul = 3,
        positions = {
            {-100,250},
            {w-100,250},
            {w-100,h-100},
            {100,h-100},
            {100,100},
            {w+100,100}
        }
    }
    --Slowly reduces vertical wave
    local turret
    local n = 11
    for i = 1, 35 do
        if i >= 9 and i%3 == 0 then
            n = n - 1
        end
        if i == 35 then
            turret = F.turret{x = w+100, y = h-100, t_x = w-100, t_y = h-100, enemy = GlB, number = 2, life = 20, duration = 20, start_angle = -math.pi/2, rot_angle = -math.pi/2, speed_m = 3, ind_mode = false, e_speed_m = 2, fps = 1.5, score_mul = 2}
        end
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 5, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 40}
        F.fromVertical{enemy = {GlB}, side = "bottom", mode = "right" , number = n, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_x_margin = 80, screen_margin = 20}
        LM.wait(.5)
    end

    --Only  horizontal, slow-down center snake and create turret
    local center_snake = Util.findId("center_snake")
    center_snake:setSpeedMult(.13)
    while not turret.death do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 4, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 76, screen_margin = 150}
        LM.wait(.8)
    end

    --Speed up snake, create line of simple balls on the path and instanciate turrets to block down path
    local t0,t1,t2,t3,t4,t5,t6,t7,t8
    center_snake:setSpeedMult(.28)
    F.line{x = w-100, y = h+50, dy = -1, number = 35, enemy = {SB}, ind_mode = false, e_speed_m = 1.3}
    local cont = 2
    for i = 1, 28 do
        if i >= 6 and i%3 == 0 and cont < 7 then
            cont = cont + 1
        end
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = cont, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}

        if i == 3 then
            t0 = F.turret{x = -100, y = h/2, t_x = w-210, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t1 = F.turret{x = -100, y = h/2, t_x = w-280, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t2 = F.turret{x = -100, y = h/2, t_x = w-350, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t3 = F.turret{x = -100, y = h/2, t_x = w-420, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t4 = F.turret{x = -100, y = h/2, t_x = w-490, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t5 = F.turret{x = -100, y = h/2, t_x = w-560, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t6 = F.turret{x = -100, y = h/2, t_x = w-630, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t7 = F.turret{x = -100, y = h/2, t_x = w-700, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 4, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            t8 = F.turret{x = -100, y = h/2, t_x = w-770, t_y = h/2, enemy = GlB, number = 1, life = 40, duration = 20, start_angle = 0, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 1}
            --Static turrets
            F.turret{x = w-490, y = h+100, t_x = w-490, t_y = h-100, enemy = GlB, number = 1, life = 30, duration = 20, start_angle = -math.pi/2, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 1, score_mul = 10}
            F.turret{x = -100, y = h+100, t_x = w-770, t_y = h-100, enemy = GlB, number = 1, life = 32, duration = 20, start_angle = -math.pi/2, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 1, score_mul = 10}
        elseif i == 4 then
            t1.shoot_tick = 0
            t3.shoot_tick = 0
            t5.shoot_tick = 0
            t7.shoot_tick = 0
            t0.shoot_tick = 1
            t2.shoot_tick = 1
            t4.shoot_tick = 1
            t6.shoot_tick = 1
            t8.shoot_tick = 1
        elseif i == 6 then
            center_snake:setSpeedMult(.2)
        elseif i == 27 then
            --Put turrets blocking left path
            t0 = F.turret{x = 100, y = -100, t_x = 100, t_y = 100, enemy = GlB, number = 1, life = 10, duration = 30, start_angle = -math.pi/2, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 10}
            F.turret{x = 100, y = -100, t_x = 100, t_y = 350, enemy = GlB, number = 1, life = 9, duration = 30, start_angle = math.pi, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 10}
            F.turret{x = 100, y = -100, t_x = 100, t_y = 420, enemy = GlB, number = 1, life = 9, duration = 30, start_angle = math.pi, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 10}
            F.turret{x = 100, y = -100, t_x = 100, t_y = 490, enemy = GlB, number = 1, life = 9, duration = 30, start_angle = math.pi, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 10}
            F.turret{x = 100, y = -100, t_x = 100, t_y = 560, enemy = GlB, number = 1, life = 7, duration = 30, start_angle = math.pi, rot_angle = 0, speed_m = 2, ind_mode = false, e_speed_m = 3, fps = 2, score_mul = 10}
        end
        LM.wait(.8)
    end

    --Slightly speeds up snake and continue start spamming top horizontal and center/right vertical
    center_snake:setSpeedMult(.22)
    local i = 1
    while not t0.death do
        F.fromHorizontal{enemy = {GlB}, side = "right", mode = "top" , number = 2, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        F.fromVertical{enemy = {GlB}, side = "bottom", mode = "right" , number = 10, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_x_margin = 80, screen_margin = 35}
        if i == 10 then
            center_snake:setSpeedMult(.17)
        end
        LM.wait(.8)
        i = i + 1
    end
    --Spams simple at the very top, glitch at the rest, speeds up snake
    center_snake:setSpeedMult(.19)
    snake1:setSpeedMult(.2)
    snake2:setSpeedMult(.2)
    local i = 1
    while not center_snake.death do
        if i%3 == 0 then
            F.single{enemy = SB, x = w/2, y = -50, dir_follow = true, speed_m = 3, ind_side = 50, score_mul = 2, ind_duration = 1}
        end
        F.fromHorizontal{enemy = {SB}, side = "right", mode = "top" , number = 1, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 75}
        if i >= 6 then
            F.fromHorizontal{enemy = {GlB}, side = "right", mode = "bottom" , number = 7, ind_mode = false, speed_m = 2.2, e_radius = 30, enemy_y_margin = 80, screen_margin = 35}
        end
        i = i + 1
        LM.wait(.8)
    end
    snake1:setSpeedMult(3)
    snake2:setSpeedMult(3)
    LM.wait("noenemies")

    --Turrets protected by snake--

    local pos = {{200,-100}}
    for i = 1, 5 do
        table.insert(pos,{200,50})
        table.insert(pos,{w-200,50})
        table.insert(pos,{w-200,200})
        table.insert(pos,{w-50,200})
        table.insert(pos,{w-50,h-200})
        table.insert(pos,{w-200,h-200})
        table.insert(pos,{w-200,h-50})
        table.insert(pos,{200,h-50})
        table.insert(pos,{200,h-200})
        table.insert(pos,{50,h-200})
        table.insert(pos,{50,200})
        table.insert(pos,{200,200})
    end
    table.insert(pos,{200,-100})
    local sn = F.snake{segments = 62, positions = pos, speed_m = .7, ind_mode = false, e_life = 4, e_radius = 25}

    LM.wait(3)
    local _y = -50
    for i = 1, 16 do
        if _y == -50 then
            _y = h+50
        else
            _y = -50
        end
        F.single{enemy = SB, x = w/2, y = _y, dir_follow = true, speed_m = 3, ind_side = 50, score_mul = 2, ind_duration = 1}
        LM.wait(1)
    end
    local alive_turrets = {true,true,true,true}
    local t1 = F.turret{x = -100, y = 100, t_x = 100, t_y = 100, enemy = GlB, number = 16, life = 20, duration = 81, start_angle = 0, rot_angle = math.pi/8, speed_m = 2, ind_mode = false, e_speed_m = .2, fps = 6, score_mul = .3}
    local t2 = F.turret{x = w+100, y = 100, t_x = w-100, t_y = 100, enemy = GlB, number = 16, life = 20, duration = 81, start_angle = -math.pi/2, rot_angle = math.pi/8, speed_m = 2, ind_mode = false, e_speed_m = .2, fps = 6, score_mul = .3}
    local t3 = F.turret{x = -100, y = h-100, t_x = 100, t_y = h-100, enemy = GlB, number = 16, life = 20, duration = 81, start_angle = math.pi, rot_angle = -math.pi/8, speed_m = 2, ind_mode = false, e_speed_m = .2, fps = 6, score_mul = .3}
    local t4 = F.turret{x = w+100, y = h-100, t_x = w-100, t_y = h-100, enemy = GlB, number = 16, life = 20, duration = 81, start_angle = -math.pi, rot_angle = math.pi/8, speed_m = 2, ind_mode = false, e_speed_m = .2, fps = 6, score_mul = .3}

    local _y = -50
    local cont = 0
    while true do
        --Increase turrets enemy spawning by 2
        if cont >= 12 then
            t1.rotation_angle = (math.pi*t1.rotation_angle)/(math.pi + t1.rotation_angle)
            t1.number = t1.number+2
            t2.rotation_angle = (math.pi*t2.rotation_angle)/(math.pi + t2.rotation_angle)
            t2.number = t2.number+2
            t3.rotation_angle = (math.pi*t3.rotation_angle)/(math.pi + t1.rotation_angle)
            t3.number = t3.number+2
            t4.rotation_angle = (math.pi*t4.rotation_angle)/(math.pi + t1.rotation_angle)
            t4.number = t4.number+2
            cont = 0
        end

        --If all turrets are dead, remove snake
        if t1.death == true and t2.death == true and t3.death == true and t4.death == true then
            if sn and not sn.death then
                local head = sn:getHead()
                if head then
                    if head.pos.y <= 250 then
                        sn:putPosAsNext(w/2,-100)
                    elseif head.pos.y >= h-250 then
                        sn:putPosAsNext(w/2,h+100)
                    elseif head.pos.x <= 250 then
                        sn:putPosAsNext(-100,h/2)
                    else
                        sn:putPosAsNext(w+100,h/2)
                    end
                end
                sn:setSpeedMult(2)
            end
            break
        end

        --Shoot alterning "bullets"
        if _y == -50 then
            _y = h+50
        else
            _y = -50
        end
        F.single{enemy = SB, x = w/2, y = _y, dir_follow = true, speed_m = 2, ind_side = 40, score_mul = 1.5, ind_duration = 1.2}

        LM.wait(1)
        cont = cont + 1
    end
    LM.wait(4)
    F.fromHorizontal{enemy = {SB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {SB,DB,DB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {GrB,SB,GrB,SB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {SB,GrB,DB,GrB,SB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {GrB,GrB,SB,SB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {SB,SB,GrB,GrB}, side = "right", mode = "center" , number = 9, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 6, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 130}
    LM.wait(1)
    F.fromHorizontal{enemy = {SB,GrB,GrB,GrB,SB}, side = "right", mode = "center" , number = 6, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait(1)
    F.fromHorizontal{enemy = {DB,GrB,DB,GrB,DB}, side = "right", mode = "center" , number = 6, ind_duration = 2, ind_side = 40, speed_m = 1.4, e_radius = 25, enemy_y_margin = 80}
    LM.wait("noenemies")
    LM.giveScore(2000, "finished part")

    LM.stop()
    LM.start(level_functions.part_3)
end

--3-3: Multitasking
function level_functions.part_3()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started
    LM.level_part("Part 3 - Multitasking")

    LM.wait(5.5)

    local x1, y1, w1, h1 = 20, 40, WINDOW_WIDTH/2 - 40, WINDOW_HEIGHT - 80
    local x2, y2, w2, h2 = WINDOW_WIDTH/2, 40, WINDOW_WIDTH/2 - 40,WINDOW_HEIGHT - 80
    local gm_idx = LM.createNewWindow(1, {x1, y1, w1, h1}, {x2, y2, w2, h2}, 4)

    LM.wait(7)

    F.single{enemy = SB, x = x1+w1/2, y = y1+h1+50, speed_m = .8, ind_side = 50, score_mul = 2, ind_duration = 3.5, game_win = 1, dy = -1}
    F.single{enemy = SB, x = x2+w2/2, y = y2+h2+50, speed_m = .8, ind_side = 50, score_mul = 2, ind_duration = 3.5, dy = -1, game_win = gm_idx}

    LM.wait("noenemies")
    LM.wait(.5)

    F.fromHorizontal{enemy = {SB}, side = "right", mode = "distribute" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = 1, e_radius = 25, game_win = 1}
    LM.wait("noenemies")
    F.fromHorizontal{enemy = {SB}, side = "left", mode = "distribute" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = 1, e_radius = 25, game_win = gm_idx}
    LM.wait("noenemies")
    F.fromVertical{enemy = {SB}, side = "bottom", mode = "distribute" , number = 5, ind_duration = 1.8, ind_side = 40, speed_m = 1, e_radius = 25, game_win = 1}
    LM.wait("noenemies")
    F.fromVertical{enemy = {SB}, side = "top", mode = "distribute" , number = 5, ind_duration = 1.8, ind_side = 40, speed_m = 1, e_radius = 25, game_win = gm_idx}
    LM.wait("noenemies")
    F.fromVertical{enemy = {SB}, side = "top", mode = "distribute" , number = 5, ind_duration = 1.8, ind_side = 40, speed_m = .9, e_radius = 25, game_win = 1}
    F.fromVertical{enemy = {SB}, side = "bottom", mode = "distribute" , number = 5, ind_duration = 1.8, ind_side = 40, speed_m = .9, e_radius = 25, game_win = gm_idx}
    LM.wait("noenemies")
    F.fromHorizontal{enemy = {SB}, side = "right", mode = "distribute" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
    F.fromHorizontal{enemy = {SB}, side = "left", mode = "distribute" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = gm_idx}
    LM.wait("noenemies")
    for i = 1, 8 do
        if i <= 4 then
            F.fromVertical{enemy = {DB}, side = "top", mode = "distribute" , number = 5, ind_duration = .8, ind_side = 40, speed_m = .35, e_radius = 25, game_win = 1}
        end
        if i > 4 then
            F.fromVertical{enemy = {DB}, side = "bottom", mode = "distribute" , number = 5, ind_duration = .8, ind_side = 40, speed_m = .35, e_radius = 25, game_win = gm_idx}
        end
        LM.wait(.8)
    end
    LM.wait("noenemies")
    for i = 1, 4 do
        if i <= 2 then
            F.fromHorizontal{enemy = {DB}, side = "left", mode = "distribute" , number = 8, ind_duration = .8, ind_side = 40, speed_m = .35, e_radius = 25, game_win = 1}
        end
        if i > 2 then
            F.fromHorizontal{enemy = {DB}, side = "right", mode = "distribute" , number = 8, ind_duration = .8, ind_side = 40, speed_m = .35, e_radius = 25, game_win = gm_idx}
        end
        LM.wait(.8)
    end

    LM.wait("noenemies")

    --Circles at both windows, increasing variation
    F.circle{radius = 640, number = 15, enemy = {SB}, ind_duration = 1.5, ind_side = 40, game_win = gm_idx, speed_m = .45}
    F.circle{radius = 640, number = 15, enemy = {SB}, ind_duration = 1.5, ind_side = 40, game_win = 1, speed_m = .45}
    LM.wait("noenemies")
    F.circle{radius = 640, number = 15, enemy = {SB,SB,GrB}, ind_duration = 1.5, ind_side = 40, game_win = gm_idx, speed_m = .45}
    F.circle{radius = 640, number = 15, enemy = {SB}, ind_duration = 1.5, ind_side = 40, game_win = 1, speed_m = .45}
    LM.wait("noenemies")
    F.circle{radius = 640, number = 15, enemy = {SB}, ind_duration = 1.5, ind_side = 40, game_win = gm_idx, speed_m = .45}
    F.circle{radius = 640, number = 15, enemy = {SB,GrB,SB}, ind_duration = 1.5, ind_side = 40, game_win = 1, speed_m = .45}
    LM.wait("noenemies")
    F.circle{radius = 640, number = 15, enemy = {SB,GrB,SB}, ind_duration = 1.5, ind_side = 40, game_win = gm_idx, speed_m = .45}
    F.circle{radius = 640, number = 15, enemy = {SB,SB,GrB}, ind_duration = 1.5, ind_side = 40, game_win = 1, speed_m = .45}

    LM.wait("noenemies")

    F.circle{radius = 640, number = 32, enemy = {SB}, ind_duration = 3, ind_side = 40, enemy_margin = 40, game_win = gm_idx, speed_m = .8}

    LM.wait(5)
    for i = 1, 11 do
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 4, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "top" , number = 4, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "bottom" , number = 4, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromVertical{enemy = {GrB}, side = "bottom", mode = "right" , number = 4, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromVertical{enemy = {GrB}, side = "bottom", mode = "left" , number = 4, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "top" , number = 5, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "bottom" , number = 5, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromHorizontal{enemy = {GrB}, side = "right", mode = "center" , number = 7, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromVertical{enemy = {GrB}, side = "bottom", mode = "left" , number = 6, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 40, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(3)
    for i = 1, 11 do
        F.fromVertical{enemy = {GrB}, side = "bottom", mode = "right" , number = 6, ind_duration = 2.7, ind_side = 50, speed_m = 1, e_radius = 23, game_win = 1}
        if i == 11 then
            F.circle{radius = 640, number = 110, enemy = {SB}, enemy_margin = 40, game_win = gm_idx, speed_m = .8, ind_mode = false}
        end
        LM.wait(.4)
    end
    LM.wait(5)
    F.circle{radius = 640, number = 10, enemy = {GrB}, enemy_margin = 0, game_win = 1, speed_m = .3, ind_duration = 3, ind_side = 40, e_radius = 18, y_center = y1 + h1/3}
    F.circle{radius = 640, number = 10, enemy = {GrB}, enemy_margin = 0, game_win = 1, speed_m = .3, ind_duration = 3, ind_side = 40, e_radius = 18, y_center = y1 + 2*h1/3}

    LM.wait("noenemies")
    local mod = 0
    for i = 1, 48 do
        --Spawn grey at right window
        if i%4 == 0 then
            F.fromVertical{enemy = {GrB}, side = "top", mode = "left" , number = 4, ind_duration = 1, ind_side = 40, speed_m = .2, e_radius = 18, game_win = gm_idx, enemy_x_margin = 140, screen_margin = 0}
        elseif i%4 == 2 then
            F.fromVertical{enemy = {GrB}, side = "top", mode = "center" , number = 3, ind_duration = 1, ind_side = 40, speed_m = .2, e_radius = 18, game_win = gm_idx, enemy_x_margin = 140}
        end

        --Spawn formation on the left window
        if i == 4 then
            F.fromVertical{enemy = {SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
        elseif i == 6 then
            F.fromVertical{enemy = {SB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
        elseif i == 8 then
            F.fromVertical{enemy = {SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
        elseif i == 10 then
            F.fromVertical{enemy = {SB,DB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
        elseif i == 12 then
            F.fromVertical{enemy = {DB,SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .8, e_radius = 25, game_win = 1}
        elseif i == 14 then
            F.fromVertical{enemy = {SB,SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
            F.fromVertical{enemy = {SB,SB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
        elseif i == 16 then
            F.fromVertical{enemy = {SB,SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
            F.fromVertical{enemy = {SB,SB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
        elseif i == 18 then
            F.fromVertical{enemy = {SB,SB}, side = "top", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
            F.fromVertical{enemy = {SB,SB}, side = "bottom", mode = "center" , number = 7, ind_duration = 1.8, ind_side = 40, speed_m = .7, e_radius = 25, game_win = 1}
        elseif i == 20 then
            mod = .2
            F.fromHorizontal{enemy = {SB,GlB,SB}, side = "left", mode = "center" , number = 10, ind_duration = 2, ind_side = 40, speed_m = .5, e_radius = 25, game_win = 1}
        elseif i == 23 then
            F.fromHorizontal{enemy = {GlB,SB,SB}, side = "right", mode = "center" , number = 10, ind_duration = 2, ind_side = 40, speed_m = .5, e_radius = 25, game_win = 1}
        elseif i == 26 then
            F.fromHorizontal{enemy = {SB,SB,GlB}, side = "left", mode = "center" , number = 10, ind_duration = 2, ind_side = 40, speed_m = .5, e_radius = 25, game_win = 1}
        elseif i == 29 then
            F.fromHorizontal{enemy = {SB,GlB,SB}, side = "left", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
            F.fromHorizontal{enemy = {SB,GlB,SB}, side = "right", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
        elseif i == 32 then
            F.fromHorizontal{enemy = {GlB,SB,SB}, side = "left", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
            F.fromHorizontal{enemy = {GlB,SB,SB}, side = "right", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
        elseif i == 35 then
            F.fromHorizontal{enemy = {SB,SB,GlB}, side = "left", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
            F.fromHorizontal{enemy = {SB,SB,GlB}, side = "right", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
        elseif i == 38 then
            F.fromVertical{enemy = {SB,SB,GlB,GlB}, side = "top", mode = "center" , number = 6, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
            F.fromVertical{enemy = {GlB,GlB,SB,SB}, side = "bottom", mode = "center" , number = 6, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
        elseif i == 42 then
            F.fromVertical{enemy = {GlB,GlB,SB,SB}, side = "top", mode = "center" , number = 6, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
            F.fromVertical{enemy = {SB,SB,GlB,GlB}, side = "bottom", mode = "center" , number = 6, ind_duration = 2.5, ind_side = 40, speed_m = .4, e_radius = 25, game_win = 1}
        elseif i == 47 then
            F.fromHorizontal{enemy = {SB,GlB,SB}, side = "left", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .3, e_radius = 25, game_win = 1}
            F.fromHorizontal{enemy = {GlB,SB,SB}, side = "right", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .3, e_radius = 25, game_win = 1}
        end

        LM.wait(1.5-mod)
    end
    LM.wait(2.5)

    --Continue creating formations on the left until all right balls are gone
    F.fromHorizontal{enemy = {SB,SB,GlB}, side = "left", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .3, e_radius = 25, game_win = 1}
    F.fromHorizontal{enemy = {SB,GlB,SB}, side = "right", mode = "center" , number = 10, ind_duration = 2.5, ind_side = 40, speed_m = .3, e_radius = 25, game_win = 1}

    LM.wait("noenemies")

    LM.wait(1.5)
    LM.destroyWindow(gm_idx, 1, {0,0,WINDOW_WIDTH,WINDOW_HEIGHT}, 3)
    LM.wait(4)
    LM.giveScore(3000, "finished part")
    LM.wait(2)

    LM.stop()
    LM.start(level_functions.part_4)
end

--3-4: Boss
function level_functions.part_4()

    CONTINUE = 3 --Setup continue variable to later continue from where you started
    LM.level_part("Part 4 - Boss")

    LM.wait(1)
    Boss.create()
    LM.wait(20)
    LM.wait("nobosses")
    LM.wait(1)
    LM.giveScore(8000, "finished level")
    LM.wait(3)

    LM.stop()
    --level4.setup()
    --LM.start(level4.part_1)

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("MADNESS ALL AROUND", "Chapter III")
    Audio.playBGM(BGM.level_3)

    LM.resetGameWindow()

end


function level_functions.startPositions()
    local x, y

    x, y = 460, 424.5

    return x,y
end

--Return level function
return level_functions
