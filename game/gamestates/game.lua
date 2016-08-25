local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"

--MODULE FOR THE GAMESTATE: GAME--

--BUTTON FUNCTIONS--

local but1 = require "buttons.renato_button"

local state = {}
local p --Psycho
function state:enter()
    local b

    p = Psy(100, 100)
    p:addElement(DRAW_TABLE.L3)

end

function state:leave()

    Util.clearAllTables()

end


function state:update(dt)

    p:update(dt)

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    p:keypressed(key) --Key handling of psycho
    Util.defaultKeyPressed(key)

end

function state:keyreleased(key)

    p:keyreleased(key) --Key handling of psycho

end

--Return state functions
return state
