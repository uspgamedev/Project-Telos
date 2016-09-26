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
    local b

    --GUI--

    --Play Button
    b = Circle_Button(500, 300, 100, Color.purple(),
            function()
                SWITCH = "GAME"
            end,
        "Play", GUI_BIG, Color.black())
    b:addElement(DRAW_TABLE.GUI, "gui")
    
    --AUDIO--
    Audio.playBGM(MENU)

end

function state:leave()

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        SWITCH = nil
        Gamestate.switch(GS.GAME)
    end

    Util.updateTimers(dt)

    Util.updateFPS()

    Util.killAll()
    
    Audio.loopBGM()

end

function state:draw()

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
