local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
local Audio = require "audio"
--MODULE FOR THE GAMESTATE: PAUSE--

--LOCAL FUNCTIONS--

local chooseDeathMessage

--------------------

local state = {}

function state:enter()
    local t, b

    --Main gameover text
    t = Txt.create_gui(400, 300, "GAMEOVER", GUI_BOSS_TITLE, nil, "format", nil, "gameover_text", "center")

    chooseDeathMessage(t)

    --Restart button
    func = function() SWITCH = "GAME"; CONTINUE = false end
    Button.create_inv_gui(140, 650, func, "(r)estart", GUI_MED, "start a new game", GUI_MEDLESS, "gameover_gui")

    if CONTINUE then

        --Continue button
        func = function() SWITCH = "GAME" end
        Button.create_inv_gui(340, 650, func, "(c)ontinue", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "gameover_gui")

    end

    --Back to menu button
    func = function() SWITCH = "MENU" end
    Button.create_inv_gui(540, 650, func, "(b)ack to menu", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "gameover_gui")

    --Add slowmotion effect
    SLOWMO_M = .2

    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)
    local m_dt

    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.switch(GS.GAME)
    elseif SWITCH == "MENU" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.switch(GS.MENU)
    end

    Util.updateTimers(dt)

    Util.updateFPS()

    --Update objects position in slowmo
    m_dt = dt*SLOWMO_M

    Util.updateSubTp(m_dt, "player_bullet")
    Util.updateSubTp(m_dt, "enemies")
    Util.updateSubTp(m_dt, "bosses")
    Util.updateSubTp(m_dt, "decaying_particle")
    Util.updateSubTp(m_dt, "particle_batch")
    Util.updateSubTp(m_dt, "enemy_indicator_batch")
    Util.updateSubTp(m_dt, "growing_circle")
    Util.updateSubTp(m_dt, "enemy_indicator")
    Util.updateSubTp(m_dt, "ultrablast")
    Util.updateSubTp(m_dt, "rotating_indicator")
    Util.updateSubTp(dt, "gameover_gui") --Update buttons on the gui
    Util.checkCollision()

    --Kill dead objects
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

    if     key == 'r' then
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == 'c' and CONTINUE then
        SWITCH = "GAME"
    elseif key == 'b' then
        SWITCH = "MENU"
    else
        Util.defaultKeyPressed(key)
    end

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

------------------
--LOCAL FUNCIONS--
------------------

--Create a centralized level title, that fades out after 3 seconds
function chooseDeathMessage(t)
    local message, fx, fy, x, y, font, limit

    message = Util.randomElement(DEATH_TEXTS) --Get a random death message

    limit = ORIGINAL_WINDOW_WIDTH/2

    --Get position so that the text is centralized on screen
    fx = math.min(t.font:getWidth(message),limit) --Width of text
    fy = t.font:getHeight(message)*  math.ceil(t.font:getWidth(message)/fx) --Height of text
    x = ORIGINAL_WINDOW_WIDTH/2 - fx/2
    y = ORIGINAL_WINDOW_HEIGHT/2 - fy/2

    --Update gameover text, position and limit
    t.pos = Vector(x, y)
    t.text = message
    t.limit = fx

    return message
end

--Return state functions
return state
