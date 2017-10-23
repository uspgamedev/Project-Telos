local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Util = require "util"

local level_functions = {}

--LEVEL 2--

--2-1: A Cross the Planes
function level_functions.part_1()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    LM.level_part("-- to be continued --")

    LM.wait(3)

    p = Util.findId("psycho")
    if p then
        p.lives = 1
        p:kill()
    end

    LM.stop()


end


---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("TO BE CONTINUED")
    Audio.playBGM(BGM.level_2)

end


function level_functions.startPositions()
    local x, y

    x, y = 404, 321

    return x,y
end

--Return level function
return level_functions
