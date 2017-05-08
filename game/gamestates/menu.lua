local Button = require "classes.button"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
local Audio = require "audio"
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
        offset = 140 --Move "New Game" button to the left

        --Continue Button
        func = function() SWITCH = "GAME" end
        b = Button.create_circle_gui(640, 300, 110, func, "Continue", GUI_BIGLESS, "main_menu_buttons", "menu_continue_button")

    end

    --Play Button
    func = function()
        SWITCH = "GAME"
        CONTINUE = false
        if FIRST_TIME then
            TUTORIAL = true
        end
    end
    b = Button.create_circle_gui(500 - offset, 300, 110, func, "New Game", GUI_BIGLESS, "main_menu_buttons", "menu_play_button")

    if not FIRST_TIME then

        --Tutorial Button
        func = function() SWITCH = "GAME"; TUTORIAL = true end
        b = Button.create_circle_gui(500, 480, 63, func, "Tutorial", GUI_BIGLESSLESS, "main_menu_buttons", "menu_tutorial_button")

    end

    --"Go to Highscore Menu Screen" button
    func = function()
        local objects_positions = {}
        local target_x_values = {}
        local handles_table = {}

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("main_menu_buttons")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x - ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
                ob.lock = true
            end
        end

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("highscore_menu_buttons")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x - ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
                ob.lock = false
            end
        end

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("highscore_screen_texts")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x - ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
            end
        end

        --Change x value of all menu objects
        FX.change_value_objects(objects_positions, "x", target_x_values, 1800, "moving_tween", handles_table, "out-back")

    end
    b = Button.create_circle_gui(880, 650, 80, func, "Highscores", GUI_BIGLESSLESS, "main_menu_buttons", "menu_go2highscore_button")

    --------------------
    --HIGHSCORE MENU SCREEN--
    --------------------

    HS.draw(nil, ORIGINAL_WINDOW_WIDTH, 0) --Create highscore table "one screen to the right"

    --"Go to Main Menu Screen" button
    func = function()
        local objects_positions = {}
        local target_x_values = {}
        local handles_table = {}

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("main_menu_buttons")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
                ob.lock = false
            end
        end

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("highscore_menu_buttons")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
                ob.lock = true
            end
        end

        --Iterate through all main menu buttons and add objects positions (and target values) to the tables
        local table_ = Util.findSbTp("highscore_screen_texts")
        if table_ then
            for ob in pairs(table_) do
                table.insert(objects_positions, ob.pos)
                table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the left
                table.insert(handles_table, ob.handles)
            end
        end

        --Change x value of all menu objects
        FX.change_value_objects(objects_positions, "x", target_x_values, 1800, "moving_tween", handles_table, "out-back")

    end
    b = Button.create_circle_gui(ORIGINAL_WINDOW_WIDTH + 110, 680, 55, func, "Back", GUI_BIGLESSLESS, "highscore_menu_buttons", "menu_go2main_button")


    --AUDIO--
    Audio.playBGM(BGM_MENU)

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

    SFX_PLAY_BUTTON:play()

end

--Return state functions
return state
