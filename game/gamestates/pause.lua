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
    local t, b

    --GUI--

    --Main pause text
    Txt.create_gui(440, 300, "Pause", GUI_BIG)

    --Unpause button
    b = Inv_Button(140, 650,
        function()
            SWITCH = "GAME"
        end,
        "un(p)ause", GUI_MED)
    b:addElement(DRAW_TABLE.GUI, "gui")

    --"Go back" button
    b = Inv_Button(340, 650,
        function()
            SWITCH = "MENU"
        end,
        "go (b)ack", GUI_MED)
    b:addElement(DRAW_TABLE.GUI, "gui")

end

function state:leave()

    Psycho.updateSpeed(Psycho.get())

    Util.addExceptionId("background")
    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        SWITCH = nil
        Util.gameElementException()
        Gamestate.pop()
    elseif SWITCH == "MENU" then
        SWITCH = nil
        Gamestate.pop()
        Gamestate.switch(GS.MENU)
    end

    COLOR_TIMER:update(dt)

end

function state:draw()

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
