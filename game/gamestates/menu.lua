local Button = require "classes.button"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
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

    Util.defaultKeyPressed(key)

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

--Return state functions
return state
