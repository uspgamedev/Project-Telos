require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--LEVEL 1--

local level = {}

--Level script
function level_script()
    --Start Level
    print("MY LEVEL")
    coroutine.yield()
    print("IS AWESOME")
end

--Start level (level manager)
function level.start()
    GAME_TIMER:script(function(wait)
        co = coroutine.create(level_script)

        --Start level
        coroutine.resume(co)
        wait(5)
        coroutine.resume(co)
    end)
end



--Return level function
return level
