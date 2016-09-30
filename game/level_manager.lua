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
    if not Util.tableEmpty(INDICATOR_HANDLES) then
        for _,h in pairs(INDICATOR_HANDLES) do
            LEVEL_TIMER:cancel(h)
        end
    end

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
                if Util.tableEmpty(SUBTP_TABLE["enemies"]) and Util.tableEmpty(SUBTP_TABLE["enemy_indicator"]) then
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
    --Waits for all enemies to die, then wait .5 second more
    elseif arg == "nobosses" then
        --Checks every .02 seconds how many enemies there are

        if COROUTINE_HANDLE then
            LEVEL_TIMER:cancel(COROUTINE_HANDLE)
        end

        COROUTINE_HANDLE = LEVEL_TIMER:every(.02,
            function()
                if Util.tableEmpty(SUBTP_TABLE["bosses"]) and Util.tableEmpty(SUBTP_TABLE["enemy_indicator"]) then
                    LEVEL_TIMER:cancel(COROUTINE_HANDLE)
                    level_manager.resume()
                end
            end
        )

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
    txt = Txt.create_game_gui(x, y, name, GUI_GAME_TITLE, nil, "format", nil, "game_title", "center", fx)
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

--Create a centralized on top of screen boss title, that fades out after 3 seconds
function level_manager.boss_title(name)
    local txt, fx, fy, x, y, font, limit

    font = GUI_BOSS_TITLE
    limit = ORIGINAL_WINDOW_WIDTH

    --Get position so that the text is centralized on screen
    fx = math.min(font:getWidth(name),limit) --Width of text
    fy = font:getHeight(name)*  math.ceil(font:getWidth(name)/fx) --Height of text
    x = ORIGINAL_WINDOW_WIDTH/2 - fx/2
    y = ORIGINAL_WINDOW_HEIGHT/5 - fy/2
    --Create level title
    txt = Txt.create_gui(x, y, name, font, nil, "format", nil, "boss_title", "center", fx)
    --in the future, make a "PAAAM" sound here

    --After two seconds, fades-out the title
    Level_Handle1 = LEVEL_TIMER:after(2,
        function()
            Level_Handle2 = LEVEL_TIMER:tween(1, Util.findId("boss_title"), {alpha = 0}, 'in-linear')
            Level_Handle3 = LEVEL_TIMER:after(1,
                function()
                    Util.findId("boss_title").death = true
                end
            )
        end
    )

end

--Function takes a distance between [0 ,2*'screen_width'+2*'screen_height'] and returns a position x,y outside the screen.
--it cycles the screen going from the upmost left position to the screen and spins clockwise.
function level_manager.outsidePosition(dist)
    local x, y

    --For debugguing, but shouldn't happen
    x = ORIGINAL_WINDOW_WIDTH/2
    y = ORIGINAL_WINDOW_HEIGHT/2

    if dist >= 0 and dist <= ORIGINAL_WINDOW_WIDTH then
        x = dist
        y = -25
    elseif dist <= ORIGINAL_WINDOW_WIDTH + ORIGINAL_WINDOW_HEIGHT then
        x = ORIGINAL_WINDOW_WIDTH + 25
        y = dist - ORIGINAL_WINDOW_WIDTH
    elseif dist <= ORIGINAL_WINDOW_WIDTH + ORIGINAL_WINDOW_HEIGHT + ORIGINAL_WINDOW_WIDTH then
        x = 2*ORIGINAL_WINDOW_WIDTH - dist + ORIGINAL_WINDOW_HEIGHT
        y = ORIGINAL_WINDOW_HEIGHT + 25
    elseif dist <= 2*ORIGINAL_WINDOW_WIDTH + 2*ORIGINAL_WINDOW_HEIGHT then
        x = -25
        y = 2*ORIGINAL_WINDOW_HEIGHT - dist + 2*ORIGINAL_WINDOW_WIDTH
    end

    return x, y
end

--Increase psycho's lives
function level_manager.giveLives(number)
    local p

    p = Util.findId("psycho")

    p.lives = p.lives + number
    Util.findId("lives_counter").var = p.lives
end

--Increase psycho's score by 'value'
function level_manager.giveScore(value)
    local p

    p = Util.findId("psycho")

    --Update main score
    p.score = p.score + value
    Util.findId("score_counter").var = p.score

    --Update life score
    p.life_score = p.life_score + value
    while p.life_score >= p.life_score_target do
        p.life_score = p.life_score - p.life_score_target
        p.lives = p.lives + 1
        Util.findId("lives_counter").var = p.lives
    end

    --Update ultrablast score
    p.ultrablast_score = p.ultrablast_score + value
    while p.ultrablast_score >= p.ultrablast_score_target do
        p.ultrablast_score = p.ultrablast_score - p.ultrablast_score_target
        p.ultrablast_counter = p.ultrablast_counter + 1
        Util.findId("ultrablast_counter").var = p.ultrablast_counter
    end

end


--Return functions
return level_manager
