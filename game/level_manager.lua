local Util = require "util"

local level_manager = {}

--Starts a coroutine with a level script
function level_manager.start(level_script)

    COROUTINE = coroutine.create(level_script)

    level_manager.resume()

end

--Stop current coroutine
function level_manager.stop()

    COROUTINE = nil

    if COROUTINE_HANDLE then GAME_TIMER:cancel(COROUTINE_HANDLE) end

end

--Yield coroutine
function level_manager.wait(arg)
    coroutine.yield(arg)
end


--Keeps playing the level
function level_manager.resume()
    local arg, status

    --If level has stopped, end coroutine
    if not COROUTINE then return end

    --Get yield argument
    status, arg = coroutine.resume(COROUTINE)

    --Resumes coroutine only when there aren't any enemies on screen
    if arg == "noenemies" then
        --Checks every 2 seconds how many enemies there are
        COROUTINE_HANDLE = GAME_TIMER:every(2,
        function()
            if Util.tableLen(SUBTP_TABLE["enemies"]) == 0 then
                GAME_TIMER:cancel(COROUTINE_HANDLE)
                level_manager.resume()
            end
        end)
    --Waits arg seconds
    elseif type(arg) == "number" then
        COROUTINE_HANDLE = GAME_TIMER:after(arg, level_manager.resume)
    end
end
--Return functions
return level_manager
