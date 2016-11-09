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

    offset = 0

    if CONTINUE then
        offset = 140 --Move "New Game" button to the left

        --Continue Button
        func = function() SWITCH = "GAME" end
        b = Button.create_circle_gui(640, 300, 110, func, "Continue", GUI_BIGLESS)

    end

    --Play Button
    func = function() SWITCH = "GAME"; CONTINUE = false end
    b = Button.create_circle_gui(500 - offset, 300, 110, func, "New Game", GUI_BIGLESS)

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
