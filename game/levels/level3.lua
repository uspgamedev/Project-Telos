local F = require "formation"
local LM = require "level_manager"
local Color = require "classes.color.color"
local Audio = require "audio"
local Util = require "util"

local level_functions = {}

--LEVEL 2--

--2-1: A Cross the Planes
function level_functions.part_1()
    local p

    CONTINUE = 3 --Setup continue variable to later continue from where you started

    LM.level_part("Part 1 - Boom shakalaka")

    LM.stop()

end


---------------------
--UTILITY FUNCTIONS--
---------------------

--Level setup
function level_functions.setup()

    --Start Level
    LM.level_title("CONGRATULATIONS, OMAR IS PROUD OF YOU")
    Audio.playBGM(BGM_LEVEL_2)

end


function level_functions.startPositions()
    local x, y

    x, y = 404, 321

    return x,y
end

--Return level function
return level_functions
