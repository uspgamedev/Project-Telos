local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"

--MODULE FOR THE GAMESTATE: GAME--

--BUTTON FUNCTIONS--

--------------------

local state = {}

local p --Psycho
local switch = nil --What state to go next

function state:enter()

    p = Psy(100, 100)
    p:addElement(DRAW_TABLE.L4)

end

function state:leave()

    Util.clearAllTables()

end


function state:update(dt)

    p:update(dt)
    Util.updateSubTp(dt, "player_bullet")

    Util.killSubTp("player_bullet")

    if SWITCH == "PAUSE" then
        SWITCH = nil
        Gamestate.push(GS.PAUSE)
    end

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    p:keypressed(key) --Key handling of psycho

    if key == 'p' then --Pause game
        SWITCH = "PAUSE"
    else
        Util.defaultKeyPressed(key)
    end

end

function state:keyreleased(key)

    p:keyreleased(key) --Key handling of psycho

end

function state:mousepressed(x, y, button)
    if button == 1 then
        p:shoot(x, y)
    end
end

--Return state functions
return state
