local Util = require "util"
local Txt = require "classes.text"

local level_manager = {}
local Level_Handle1, Level_Handle2, Level_Handle3
--------------------
--SCRIPT FUNCTIONS--
--------------------

--Starts a coroutine with a level script
function level_manager.start(level_script)

    COROUTINE = coroutine.create(level_script)

    level_manager.resume()

end

--Stop current coroutine
function level_manager.stop()

    COROUTINE = nil

    if COROUTINE_HANDLE then LEVEL_TIMER:cancel(COROUTINE_HANDLE) end
    if Level_Handle1 then LEVEL_TIMER:cancel(Level_Handle1) end
    if Level_Handle2 then LEVEL_TIMER:cancel(Level_Handle2) end
    if Level_Handle3 then LEVEL_TIMER:cancel(Level_Handle3) end

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

        if COROUTINE_HANDLE then
            LEVEL_TIMER:cancel(COROUTINE_HANDLE)
        end

        COROUTINE_HANDLE = LEVEL_TIMER:every(.02,
            function()
                if Util.tableEmpty(SUBTP_TABLE["enemies"]) then
                    LEVEL_TIMER:cancel(COROUTINE_HANDLE)
                    level_manager.resume()
                end
            end
        )

    --Waits arg seconds
    elseif type(arg) == "number" then

        if COROUTINE_HANDLE then
            LEVEL_TIMER:cancel(COROUTINE_HANDLE)
        end

        COROUTINE_HANDLE = LEVEL_TIMER:after(arg, level_manager.resume)
    end
end

-------------------
--OTHER FUNCTIONS--
-------------------

--Changes the level part text
function level_manager.level_part(name)
    Util.findId("level_part").text = name
end

--Create a centralized level title, that fades out after 3 seconds
function level_manager.level_title(name)
    local txt, fx, fy, x, y, font, limit

    font = GUI_GAME_TITLE
    limit = 4*ORIGINAL_WINDOW_WIDTH/5

    --Get position so that the text is centralized on screen
    fx = math.min(font:getWidth(name),limit) --Width of text
    fy = font:getHeight(name)*  math.ceil(font:getWidth(name)/fx) --Height of text
    x = ORIGINAL_WINDOW_WIDTH/2 - fx/2
    y = ORIGINAL_WINDOW_HEIGHT/2 - fy/2
    --Create level title
    txt = Txt.create_gui(x, y, name, GUI_GAME_TITLE, nil, "format", nil, "game_title", "center", limit)
    --in the future, make a "PAAAM" sound here

    --After two seconds, fades-out the title
    Level_Handle1 = LEVEL_TIMER:after(2,
        function()
            Level_Handle2 = LEVEL_TIMER:tween(1, Util.findId("game_title"), {alpha = 0}, 'in-linear')
            Level_Handle3 = LEVEL_TIMER:after(1,
                function()
                    Util.findId("game_title").death = true
                end
            )
        end
    )

end

--Return functions
return level_manager
