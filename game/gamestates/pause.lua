local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Txt = require "classes.text"
local Audio = require "audio"
--MODULE FOR THE GAMESTATE: PAUSE--

--BUTTON FUNCTIONS--

--------------------

local state = {}

function state:enter()
    local t, b, func

    USE_BLUR_CANVAS = true

    --GUI--

    --Main pause text
    Txt.create_gui(440, 300, "Pause", GUI_BIG)

    --Unpause button
    func = function() SWITCH = "GAME" end
    Button.create_inv_gui(140, 650, func, "un(p)ause", GUI_MED, nil, nil, "pause_gui")

    --"Go back" button
    func = function() SWITCH = "MENU" end
    Button.create_inv_gui(340, 650, func, "(b)ack to menu", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "pause_gui")

    --AUDIO--
    Audio.pauseSFX()

    love.mouse.setVisible(true) --Make cursor visible
    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    USE_BLUR_CANVAS = false
    BLUR_CANVAS_1 = nil
    BLUR_CANVAS_2 = nil

    Psycho.updateSpeed(Psycho.get())

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

    Audio.resumeSFX()

    love.mouse.setVisible(false) --Make cursor invisible
    love.mouse.setGrabbed(true) --Resume mouse capture

end


function state:update(dt)

    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Util.gameElementException()
        Gamestate.pop()

    elseif SWITCH == "MENU" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Util.clearTimerTable(DEATH_HANDLES, FX_TIMER)
        Gamestate.pop()
        Gamestate.switch(GS.MENU)
    end

    COLOR_TIMER:update(dt)
    AUDIO_TIMER:update(dt)

    Util.updateSubTp(dt, "pause_gui") --Update buttons on the gui

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

    if     key == 'p' or key == 'escape' then
        SWITCH = "GAME" --Unpause game
    elseif key == 'b' then
        SWITCH = "MENU" --Go back to menu
    else
        Util.defaultKeyPressed(key)
    end

end

function state:mousepressed(x, y, button)
    local scale

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

--Return state functions
return state
