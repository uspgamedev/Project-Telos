local Util = require "util"
local Draw = require "draw"
local Hsl  = require "classes.hsl"

--MODULE FOR THE GAMESTATE: GAME--

--BUTTON FUNCTION--

local but1 = require "buttons.renato_button"

local state = {}

function state:enter()
    local b

    b = But(300, 300, 50, Hsl.orange(), but1, "psycho guy", my_font)
    b:addElement(DRAW_TABLE.L1, "big_buttons", "renato_button")

end

function state:leave()

    Util.clearAllTables()

end


function state:update(dt)


end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)
    local i

    Util.defaultKeyPressed(key)


end

--Return state functions
return state
