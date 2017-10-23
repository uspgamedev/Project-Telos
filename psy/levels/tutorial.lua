local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local TutIcon = require "classes.tutorial_icon"
local Util = require "util"

local level_functions = {}

--Levels
local level1 = require "levels.level1"

--TUTORIAL--

--Tutorial main part
function level_functions.part_1()
    local txt, p

    LM.level_part("Tutorial")

    p = Util.findId("psycho")
    p.can_ultra = false --Disable ultrablast
    p.can_move = false --Disable movement
    p.can_shoot = false --Disable shooting

    --Make gui invisible here
    Util.findId("life_counter").alpha = 0
    Util.findId("ultrablast_counter").alpha = 0
    Util.findId("score_counter").alpha = 0
    Util.findId("separator_1").alpha = 0
    Util.findId("level_part").alpha = 0
    Util.findId("fps_counter").alpha = 0

    LM.wait(4)

    DONT_ENABLE_SHOOTING_AFTER_DEATH = true
    DONT_ENABLE_ULTRA_AFTER_DEATH = true
    DONT_ENABLE_MOVING_AFTER_DEATH = true

    F.single{enemy = SB, x = ORIGINAL_WINDOW_WIDTH + 20, y = p.pos.y, dx = -11, dy = 0, speed_m = 1.8, e_radius = 20, score_mul = 0, ind_duration = 3.5, ind_side = 50}

    LM.wait(2)

    --Turn lives counter visible
    local counter = Util.findId("life_counter")
    counter.level_handles["become_visible"] = LEVEL_TIMER:tween(1, counter, {alpha = 255}, 'in-linear')

    LM.wait(3)
    LM.wait("noenemies")
    LM.wait(1.5)

    F.single{enemy = SB, x = ORIGINAL_WINDOW_WIDTH + 20, y = p.pos.y, dx = -11, dy = 0, speed_m = 1.8, e_radius = 20, score_mul = 0, ind_duration = 4, ind_side = 50}

    LM.wait(1.5)

    --Create tutorial icons for moving
    local w, h = TutIcon.dimensions("letter")
    local gap = 15
    TutIcon.create(p.pos.x - w/2, p.pos.y - p.r - gap - h, 'W', 5, true)
    TutIcon.create(p.pos.x + p.r + gap, p.pos.y - h/2, 'D', 5, true)
    TutIcon.create(p.pos.x - w/2, p.pos.y + p.r + gap, 'S', 5, true)
    TutIcon.create(p.pos.x - p.r - gap - w, p.pos.y - h/2, 'A', 5, true)
    LM.wait(.6)
    p.can_move = true
    DONT_ENABLE_MOVING_AFTER_DEATH = false

    LM.wait(6.5)

    --Turn ultrablast counter visible
    p.ultrablast_counter = 0
    p.can_ultra = true
    DONT_ENABLE_ULTRA_AFTER_DEATH = false
    local counter = Util.findId("ultrablast_counter")
    counter:reset()
    counter.charge_cooldown = 0
    counter.level_handles["become_visible"] = LEVEL_TIMER:tween(1, counter, {alpha = 255}, 'in-linear')
    local sep = Util.findId("separator_1")
    sep.level_handles["become_visible"] = LEVEL_TIMER:tween(1, sep, {alpha = 255}, 'in-linear')

    LM.wait(5.5)

    --Create tutorial icons for ultrablast
    local w, h = TutIcon.dimensions("space")
    local x, y = ORIGINAL_WINDOW_WIDTH/2 - w/2, ORIGINAL_WINDOW_HEIGHT/3 - 20
    TutIcon.create(x, y, 'space', 5)
    x, y = x + w/2 - 10, y + h + 20
    LM.text(x, y, "or", 5, 180)
    w, h = TutIcon.dimensions("right_mouse_button")
    x, y = x - w/2 + 8, y + 35
    TutIcon.create(x, y, 'right_mouse_button', 5)
    local font = GUI_MED
    local text = "for"
    x = ORIGINAL_WINDOW_WIDTH/2 - font:getWidth(text)/2
    y = y + h + 15
    LM.text(x, y, text, 5, 180, font)
    font = GUI_MEDPLUS
    text = "ULTRABLAST"
    x = ORIGINAL_WINDOW_WIDTH/2 - font:getWidth(text)/2
    y = y + 30
    LM.text(x, y, text, 5, 180, font)

    LM.wait(2)

    F.circle{enemy = {SB}, number = 18, radius = 630, speed_m = 1, score_mul = 0, ind_duration = 3, ind_side = 35}

    LM.wait("noenemies")
    LM.wait(3)

    --Fade-in psycho aim and tutorial for shooting
    p.can_shoot = true
    DONT_ENABLE_SHOOTING_AFTER_DEATH = false
    LEVEL_TIMER:tween(.3, p.aim, {alpha = 90}, 'in-linear')
    local w, h = TutIcon.dimensions("left_mouse_button")
    local x, y = ORIGINAL_WINDOW_WIDTH/2 - w/2, ORIGINAL_WINDOW_HEIGHT/2 - h/2
    TutIcon.create(x, y, 'left_mouse_button', 4.5)

    LM.wait(3.5)
    F.fromHorizontal{side = "right", mode = "center", number = 7, enemy = {SB}, ind_duration = 3, ind_side = 35, speed_m = 1.1, enemy_y_margin = 55, enemy_x_margin = 55, e_radius = 23}

    LM.wait(1.5)
    --Turn score counter visible
    counter = Util.findId("score_counter")
    counter.level_handles["become_visible"] = LEVEL_TIMER:tween(1, counter, {alpha = 255}, 'in-linear')

    LM.wait("noenemies")
    LM.wait(1)

    LM.text(ORIGINAL_WINDOW_WIDTH/2 - 50, ORIGINAL_WINDOW_HEIGHT/2, "good luck", 6, 170)
    LM.wait(3)

    --Turn fps counter visible
    txt = Util.findId("fps_counter")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    --Turn level part visible
    txt = Util.findId("level_part")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    LM.wait(3)
    --Reset psycho stats
    LM.giveScore(-p.score, "reset")
    p.life_score = 0
    LM.giveLives(p.default_lives-p.lives, "reset")
    LM.wait(5)

    LM.stop()
    TUTORIAL = false

    FIRST_TIME = false
    level1.setup() --Make title and start BGM
    LM.start(level1.part_1)

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("HELLO THERE...")
    --Make tutorial music play at the same position menu music was playing
    Audio.playBGM(BGM.tutorial, .5, .5, Audio.getCurrentBGM():tell())

end

function level_functions.startPositions()
    local x, y


    x, y = 412, 372 --'O' of "Hello"

    return x,y
end

--Return level function
return level_functions
