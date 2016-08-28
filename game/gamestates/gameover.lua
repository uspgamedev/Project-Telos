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



end

function state:leave()

    Util.clearAllTables("remove")

end


function state:update(dt)

    if SWITCH == "GAME" then
        SWITCH = nil
        Gamestate.switch(GS.GAMEOVER)
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
