local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Txt = require "classes.text"
--MODULE FOR THE GAMESTATE: PAUSE--

--BUTTON FUNCTIONS--

--------------------

local state = {}

function state:enter()
    local t, b, func

    --Blur gamescreen
    USE_BLUR_CANVAS = true

    --GUI--

    --Main pause text
    Txt.create_gui(440, 300, "Pause", GUI_BIG)

    --Unpause button
    func = function() SWITCH = "GAME" end
    Button.create_inv_gui(140, 650, func, "un(p)ause", GUI_MED, nil, nil, "pause_gui")

    --"Go back" button
    func = function() SWITCH = "MENU" end
    local b = Button.create_inv_gui(340, 650, func, "(b)ack to menu", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "pause_gui")

    --AUDIO--
    Audio.pauseSFX()

    --Decrease current bgm volume
    local bgm = Audio.getCurrentBGM()
    if bgm then
        Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL/5,.3,false,true)
    end

    love.mouse.setVisible(true) --Make cursor visible
    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    --Stop using blur
    USE_BLUR_CANVAS = false
    BLUR_CANVAS_1 = nil
    BLUR_CANVAS_2 = nil

    Psycho.updateSpeed(Psycho.get())

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

    Audio.resumeSFX()

    --Return current bgm volume to normal
    local bgm = Audio.getCurrentBGM()
    if bgm then
        Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL,.3,false,true)
    end

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
        CAM.rot = 0 --Reset camera rotation
        CAM.scale = 1 --Reset camera zoom

        BLACK_WHITE_SHADER_FACTOR = 0 --Reset grey factor

        Audio.stopSFX()

        SFX.back_button:play()

        if TUTORIAL then
            TUTORIAL = false
            FIRST_TIME = false

            DONT_ENABLE_SHOOTING_AFTER_DEATH = false
            DONT_ENABLE_ULTRA_AFTER_DEATH = false
            DONT_ENABLE_MOVING_AFTER_DEATH = false

            --Turn fps counter visible
            txt = Util.findId("fps_counter")
            txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

        end

        --Stop indicators batch from spawning enemies
        if SUBTP_TABLE["enemy_indicator_batch"] then
            for batch in pairs(SUBTP_TABLE["enemy_indicator_batch"]) do
                batch.spawn = false
            end
        end

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
