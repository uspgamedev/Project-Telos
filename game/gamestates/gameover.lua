local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"


--MODULE FOR THE GAMESTATE: PAUSE--

--BUTTON FUNCTIONS--

local but1 = require "buttons.renato_button"

--------------------

local state = {}
local switch = nil --What state to go next

function state:enter()
    local t, b

    --Main gameover text
    t = Text(400, 300, "GAMEOVER", GUI_BIG, Color.orange())
    t:addElement(DRAW_TABLE.GUI, "gui")

    --Restart button
    b = Inv_Button(140, 650,
        function()
            SWITCH = "GAME"
        end,
        "(r)estart", GUI_MED, Color.orange())
    b:addElement(DRAW_TABLE.GUI, "gui")

end

function state:leave()

    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        SWITCH = nil
        Gamestate.switch(GS.GAME)
    end

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    if key == 'r' then
        SWITCH = "GAME"
    else
        Util.defaultKeyPressed(key)
    end

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

--Return state functions
return state
