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
    local txt, p

    LM.level_part("Learning the ropes")

    p = Util.findId("psycho")
    p.can_ultra = false --Disable ultrablast

    --Make gui invisible here
    Util.findId("lives_counter").alpha = 0
    Util.findId("ultrablast_counter_text").alpha = 0
    Util.findId("score_counter").alpha = 0
    Util.findId("separator_1").alpha = 0
    Util.findId("level_part").alpha = 0
    Util.findId("fps_counter").alpha = 0

    LM.wait(4)
    LM.text(310, 260, "I guess there is no going back now", 3, 200)
    LM.wait(5)
    LM.text(300, 560, "I should move with WASD or the arrow keys...", 6, 200)
    LM.wait(3)
    LM.text(320, 590, "...if that makes any sense", 3, 200)
    LM.wait(5)
    LM.text(400, 460, "I can't trust anyone", 2, 100)
    LM.wait(4)
    LM.text(100, 50, "everyone wants me dead", 3, 200)
    LM.wait(2)

    --Turn lives counter visible
    txt = Util.findId("lives_counter")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    LM.wait(4)
    LM.text(300, 260, "I have to kill them", 2, 100)
    LM.wait(4)
    LM.text(250, 560, "holding the left mouse button should do the trick", 6, 200)
    LM.wait(2)

    F.single{enemy = SB, x = -20, y = ORIGINAL_WINDOW_HEIGHT/2, dx = 1, dy = 0, speed_m = .8, e_radius = 30, score_mul = 0, ind_duration = 3, ind_side = 40}

    LM.wait("noenemies")
    LM.wait(3)

    LM.text(270, 260, "if there is more enemies than I can handle...", 6, 200)
    LM.wait(2)
    LM.text(280, 290, "... I could use a more powerful attack", 4, 200)
    LM.wait(6)
    LM.text(100, 165, "too bad I can't use them a lot...", 7, 200)
    LM.wait(1)

    --Turn ultrablast counter visible
    txt = Util.findId("ultrablast_counter_text")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    LM.wait(2)
    LM.text(135, 195, "...but they do make me invulnerable for a short time", 4, 200)
    LM.wait(6)
    LM.text(170, 560, "the spacebar or right mouse button should unleash the powerful ultrablast", 6, 200)
    p.can_ultra = true --Enable ultrablast
    LM.wait(2)

    F.circle{enemy = {SB}, number = 20, radius = 630, speed_m = .8, score_mul = 0, ind_duration = 4, ind_side = 35}

    LM.wait("noenemies")
    LM.wait(2)

    LM.text(470, 260, "but sometimes fighting them is useless...", 3, 200)
    LM.wait(5)
    LM.text(270, 560, "...sometimes is best to run", 3, 100)
    LM.wait(5)
    LM.text(275, 260, "I can enter focus mode and move more carefully", 4, 200)
    LM.wait(6)

    LM.text(150, 560, "when in a tight spot, I should hold the shift key to enter focus mode", 8, 200)
    LM.wait(1)

    F.fromHorizontal{side = "right", mode = "top", number = 7, enemy = {GrB}, ind_duration = 4, ind_side = 35, speed_m = .8, enemy_y_margin = 55, e_radius = 23}
    F.fromHorizontal{side = "right", mode = "bottom", number = 6, enemy = {GrB}, ind_duration = 4, ind_side = 35, speed_m = .8, enemy_y_margin = 55, e_radius = 23}

    LM.wait("noenemies")
    LM.wait(2)

    LM.text(410, 260, "I'm ready.", 6, 200)
    LM.wait(3)
    LM.text(510, 260, "I think", 3, 200)
    LM.wait(1)

    --Turn score counter visible
    txt = Util.findId("score_counter")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    --Turn fps counter visible
    txt = Util.findId("fps_counter")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    --Turn separator visible
    txt = Util.findId("separator_1")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    --Turn level part visible
    txt = Util.findId("level_part")
    txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

    LM.wait(4)
    LM.text(300, 560, "may the devil have mercy on my soul", 2, 100)
    LM.wait(5)

    LM.stop()
    TUTORIAL = false

    --G if FIRST_TIME then
        FIRST_TIME = false
        level1.setup() --Make title and start BGM
        LM.start(level1.part_1)
    --[[else
        LM.stop()
        LM.level_title("END OF TUTORIAL")
        LM.text(360, 560, "press p to pause and leave", 120, 180)
    end]]

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
