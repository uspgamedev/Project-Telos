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

--3-2: //
function level_functions.part_2()
    local w, h = WINDOW_WIDTH, WINDOW_HEIGHT

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    local p = Util.findId("psycho")

    LM.level_part("Part 2 - They came and then they left")

    LM.wait(3.5)
    --[[
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
    F.snake{segments = 9, positions = {{w/2,-100},{w/2,70},{w-70, 70},{w-70,h/2},{-100,h/2}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 18, positions = {{w+100,h/2},{w-70,h/2},{w-70, h-70},{70,h-70},{70,70},{w/2,70},{w/2,h+100}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 9, positions = {{w/2,h+100},{w/2,h-70},{70,h-70},{70,70},{w-70,70},{w-70,h-70},{70,h-70},{70,h/2},{w+100,h/2}}, speed_m = .8, ind_side = 70, e_life = 2,e_radius = 40, score_mul = 2}
    F.snake{segments = 9, positions = {{-100,h/2},{70,h/2},{70,70},{w-70,70},{w-70,h-70},{70,h-70},{70,70},{w-70,70},{w-70,h-70},{w/2,h-70},{w/2,-100}}, speed_m = .8, ind_side = 50, e_life = 2,e_radius = 40, score_mul = 2}

    LM.wait(4)
    F.circle{radius = 640, number = 20, enemy = {SB}, ind_duration = 2, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 20, enemy = {SB,DB}, ind_duration = 1.5, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 20, enemy = {DB}, ind_duration = 1.5, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 21, enemy = {SB,DB,GlB}, ind_duration = 1.5, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 20, enemy = {DB,GlB}, ind_duration = 1.5, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 21, enemy = {DB,GlB,DB}, ind_duration = 1.5, ind_side = 35,speed_m = .9}
    LM.wait(3.5)
    F.circle{radius = 640, number = 15, enemy = {GlB}, ind_duration = 1, ind_side = 35,speed_m = .9}
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

    ]]--
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
    local sn = F.snake{segments = 62, positions = pos, speed_m = .7, ind_mode = false, e_life = 5, e_radius = 25}

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
    local t1 = F.turret{x = -100, y = 100, t_x = 100, t_y = 100, enemy = GlB, number = 24, life = 18, duration = 81, start_angle = 0, rot_angle = math.pi/10, speed_m = 2, ind_mode = false, e_speed_m = .3, fps = 6, score_mul = .3}
    local t2 = F.turret{x = w+100, y = 100, t_x = w-100, t_y = 100, enemy = GlB, number = 24, life = 18, duration = 81, start_angle = -math.pi/2, rot_angle = math.pi/10, speed_m = 2, ind_mode = false, e_speed_m = .3, fps = 6, score_mul = .3}
    local t3 = F.turret{x = -100, y = h-100, t_x = 100, t_y = h-100, enemy = GlB, number = 24, life = 18, duration = 81, start_angle = math.pi, rot_angle = -math.pi/10, speed_m = 2, ind_mode = false, e_speed_m = .3, fps = 6, score_mul = .3}
    local t4 = F.turret{x = w+100, y = h-100, t_x = w-100, t_y = h-100, enemy = GlB, number = 24, life = 18, duration = 81, start_angle = -math.pi, rot_angle = math.pi/10, speed_m = 2, ind_mode = false, e_speed_m = .3, fps = 6, score_mul = .3}

    local _y = -50
    while true do
        --Update turrets fps
        t1.shoot_fps = math.max(t1.shoot_fps - .15,.5)
        t2.shoot_fps = math.max(t2.shoot_fps - .15,.5)
        t3.shoot_fps = math.max(t3.shoot_fps - .15,.5)
        t4.shoot_fps = math.max(t4.shoot_fps - .15,.5)

        --If all turrets are dead, remove snake
        if t1.death == true and t2.death == true and t3.death == true and t4.death == true then
            local head = sn:getHead()
            if head.pos.y <= 250 then
                sn:putPosAsNext(w/2,-100)
            elseif head.pos.y >= h-250 then
                sn:putPosAsNext(w/2,h+100)
            elseif head.pos.x <= 250 then
                sn:putPosAsNext(-100,h/2)
            else
                sn:putPosAsNext(w+100,h/2)
            end
            sn:setSpeedMult(2)
            break
        end

        --Shoot alterning "bullets"
        if _y == -50 then
            _y = h+50
        else
            _y = -50
        end
        F.single{enemy = SB, x = w/2, y = _y, dir_follow = true, speed_m = 2.7, ind_side = 40, score_mul = 1.5, ind_duration = 1.2}

        LM.wait(1)
    end
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
