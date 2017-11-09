local Button = require "classes.button"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
local Logo = require "classes.logo"
--MODULE FOR THE GAMESTATE: MENU--

--BUTTON FUNCTIONS--

--------------------

local state = {}

function state:enter()
    local b, func, offset

    --GUI--

    --------------------
    --MAIN MENU SCREEN--
    --------------------

    offset = 0


    if CONTINUE then
        offset = 105 --Move "Tutorial" button to the right

        --Continue Button
        func = function() SWITCH = "GAME" end
        b = Button.create_circle_gui(430, 590, 75, func, "Continue", GUI_BIGLESSLESS, "main_menu_buttons", "menu_continue_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0

    end

    --Play Button
    func = require "buttons.play_button"
    b = Button.create_circle_gui(528, 340, 140, func, "New Game", GUI_BIGLESS, "main_menu_buttons", "menu_play_button")
    b.sfx = SFX.play_button
    b.ring_growth_speed = b.ring_growth_speed
    b.alpha_mod_v = 1.5
    b.alpha_modifier = 0

    if not FIRST_TIME then

        --Tutorial Button
        func = function() SWITCH = "GAME"; TUTORIAL = true end
        b = Button.create_circle_gui(525+offset, 590, 75, func, "Tutorial", GUI_BIGLESSLESS, "main_menu_buttons", "menu_tutorial_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0

        --"Go to Highscore Menu Screen" button
        local func = require "buttons.highscore_button"
        b = Button.create_circle_gui(880, 650, 90, func, "Highscores", GUI_BIGLESSLESS, "main_menu_buttons", "menu_go2highscore_button")
        b.sfx = SFX.generic_button
        b.alpha_modifier = 0

    end


    --Create main menu logo
    local logo = Logo.create()

    -------------------------
    --HIGHSCORE MENU SCREEN--
    -------------------------

    HS.draw(nil, ORIGINAL_WINDOW_WIDTH, 0) --Create highscore table "one screen to the right"

    --"Go to Main Menu Screen" button
    func = require "buttons.highscore_back_button"
    b = Button.create_circle_gui(ORIGINAL_WINDOW_WIDTH + 110, 680, 55, func, "Back", GUI_BIGLESSLESS, "highscore_menu_buttons", "menu_go2main_button")
    b.sfx = SFX.back_button

    --AUDIO--
    Audio.playBGM(BGM.menu)

    --SHAKE--
    if SHAKE_HANDLE then
        LEVEL_TIMER:cancel(SHAKE_HANDLE)
    end

    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.switch(GS.GAME)
    end

    Util.updateSubTp(dt, "gui")
    Util.updateSubTp(dt, "main_menu_buttons")
    Util.updateSubTp(dt, "highscore_menu_buttons")
    Util.updateSubTp(dt, "decaying_particle")
    Util.updateId(dt, "logo")

    Util.updateTimers(dt)

    Util.updateFPS()

    Util.killAll()

end

function state:draw()

    --Stop using canvas
    if USE_CANVAS then
        USE_CANVAS = false
        SCREEN_CANVAS = nil
        love.graphics.clear()
    end

    Draw.allTables()

end

function state:keypressed(key)

    Util.defaultKeyPressed(key)

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

--Return state functions
return state
