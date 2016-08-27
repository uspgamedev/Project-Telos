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
    local b

    b = Inv_Button(440, 300,
        function()
            SWITCH = "GAME"
        end,
        "Pause", GUI_BIG, Color.orange())
    b:addElement(DRAW_TABLE.GUI, "gui")

    --Add exception to not remove this elements:
    Util.addExceptionSubtype("player_bullet")
    Util.addExceptionSubtype("enemies")
    Util.addExceptionId("PSY")

end

function state:leave()

    Psycho.updateSpeed(Psycho.get())
    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        SWITCH = nil
        Gamestate.pop()
    end

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    if key == 'p' then
        SWITCH = "GAME" --Unpause game
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
