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

    if COROUTINE_HANDLE then LEVEL_TIMER:cancel(COROUTINE_HANDLE) end

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
        --Checks every .02 seconds how many enemies there are
        COROUTINE_HANDLE = LEVEL_TIMER:every(.02,
        function()
            if Util.tableEmpty(SUBTP_TABLE["enemies"]) then
                LEVEL_TIMER:cancel(COROUTINE_HANDLE)
                level_manager.resume()
            end
        end)
    --Waits arg seconds
    elseif type(arg) == "number" then
        COROUTINE_HANDLE = LEVEL_TIMER:after(arg, level_manager.resume)
    end
end
--Return functions
return level_manager
