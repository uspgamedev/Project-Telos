local Util = require "util"
local Txt = require "classes.text"

local level_manager = {}

--------------------
--SCRIPT FUNCTIONS--
--------------------
--[[Functions to manipulate level script]]

--Starts a coroutine with a level script
function level_manager.start(level_script)

    COROUTINE = coroutine.create(level_script)

    level_manager.resume()

end

--Stop current coroutine
function level_manager.stop()

    COROUTINE = nil

    if COROUTINE_HANDLE then LEVEL_TIMER:cancel(COROUTINE_HANDLE) end
    if not Util.tableEmpty(INDICATOR_HANDLES) then
        for _,h in pairs(INDICATOR_HANDLES) do
            LEVEL_TIMER:cancel(h)
        end
    end
    Util.destroySubtype("enemy_indicator_batch")


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

------------------
--TEXT FUNCTIONS--
------------------
--[[Utility functions that create or manipulate text in-game]]--

--Changes the level part text
function level_manager.level_part(name)
    local level_part = Util.findId("level_part")
    level_part.text = name --Update text
    level_part.pos.x = ORIGINAL_WINDOW_WIDTH/2 - level_part.font:getWidth(name)/2 --Update position
end

--Create a centralized level title, that fades out after 3 seconds
function level_manager.level_title(name)
    local txt, fx, fy, x, y, font, limit

    font = GUI_LEVEL_TITLE
    limit = 4*ORIGINAL_WINDOW_WIDTH/5

    --Get position so that the text is centralized on screen
    fx = math.min(font:getWidth(name),limit) --Width of text
    fy = font:getHeight(name)*  math.ceil(font:getWidth(name)/fx) --Height of text
    x = ORIGINAL_WINDOW_WIDTH/2 - fx/2
    y = ORIGINAL_WINDOW_HEIGHT/2 - fy/2
    --Create level title
    txt = Txt.create_game_gui(x, y, name, GUI_LEVEL_TITLE, nil, "format", nil, "game_title", "center", fx)
    --in the future, make a "PAAAM" sound here

    --After two seconds, fades-out the title
    txt.level_handles["fade-in"] = LEVEL_TIMER:after(2,
        function()
            txt.level_handles["fade-in"] = LEVEL_TIMER:tween(1, Util.findId("game_title"), {alpha = 0}, 'in-linear',
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

    --After two seconds, fades-out the title
    txt.level_handles["fade-in"] = LEVEL_TIMER:after(2,
        function()
            txt.level_handles["fade-in"] = LEVEL_TIMER:tween(1, Util.findId("boss_title"), {alpha = 0}, 'in-linear',
                function()
                    Util.findId("boss_title").death = true
                end
            )
        end
    )

end

--Create a text in position (x,y), that fades in, and then fades out after d seconds
function level_manager.text(x, y, text, d, max_alpha, font)
    local txt

    d = d or 3
    max_alpha = max_alpha or 255

    font = font or GUI_MED

    --Create text
    txt = Txt.create_text(x, y, text, font, "in-game_text")

    txt.alpha = 0

    --After two seconds, fades-out the text
    txt.level_handles["fade-in"] = LEVEL_TIMER:tween(.3, txt, {alpha = max_alpha}, 'in-linear',
        function()
            txt.level_handles["stay_effect"] = LEVEL_TIMER:after(d,
                function()
                    txt.level_handles["fade-out"] = LEVEL_TIMER:tween(1, txt, {alpha = 0}, 'in-linear',
                        function()
                            txt.death = true
                        end
                    )
                end
            )
        end
    )

end

---------------------
--UTILITY FUNCTIONS--
---------------------
--[[Utility functions to help creating cool formations]]--

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

--[[
Function receives a text, and returns a translated enemy table represening the text for each char in order
Translations:
    's': Simple Ball
    'd': Double Ball
    'r': Grey Ball
    'l': Glitch Ball
    Other characters, such as spaces, are just ignored
]]--
function level_manager.textToEnemies(text)
    local t, char, enemy

    t = {} --Our table containing the enemies

    for i = 1, string.len(text) do
        char = string.sub(text,i,i)

        if char == 's' then
            table.insert(t, SB)
        elseif char == 'd' then
            table.insert(t, DB)
        elseif char == 'r' then
            table.insert(t, GrB)
        elseif char == 'l' then
            table.insert(t, GlB)
        end

    end

    return t
end

--------------------
--PSYCHO FUNCTIONS--
--------------------
--[[Functions to manipulate psycho stats in-game]]--

--Increase psycho's lives
function level_manager.giveLives(number, text)
    local p, t, counter, signal, handle

    p = Util.findId("psycho")

    if not p  or number == 0 then return end

    p.lives = p.lives + number

    t = Util.findId("lives_change")
    counter = Util.findId("life_counter")

    counter:update(0)

    if number >= 0 then signal = "+" else signal = "" end --Get correct sign
    if text then separator = " " else separator = "" end
    text = text or '' --Correct text
    local full_text = signal..number..separator..text
    local font = GUI_MED

    local x = counter:getStartXPosition() + counter:getWidth() + 15 --Get distance to draw the indicator
    local y = counter:getStartYPosition() + counter:getHeight()/2 - font:getHeight(full_text)/2

    --Create indicator, if there isn't one
    if not t then
        t = Txt.create_game_gui(x, y, full_text, font, nil, "right", nil, "lives_change")
    --Else update the one already existing
    else
        --Remove previous effect
        if t.level_handles["effect"] then
            LEVEL_TIMER:cancel(t.level_handles["effect"])
            t.level_handles["effect"] = nil
        end
        t.alpha = 255
        t.text = full_text
    end
    --Make text stay still for a while, then fade-out
    t.level_handles["effect"] = LEVEL_TIMER:after(1,
                function()
                    local handle
                    t.level_handles["effect"] = LEVEL_TIMER:tween(1, t, {alpha = 0}, 'in-linear',
                                function()
                                    t.death = true
                                end
                            )
                end
            )
end

--Increase psycho's score by 'value'
function level_manager.giveScore(number, text)
    local p, t, counter, handle, signal

    p = Util.findId("psycho")

    if not p or number == 0 then return end

    --Makes sure score is an integer
    assert(number - math.floor(number) == 0, "Score received is not an integer")

    --Update main score
    p.score = p.score + number

    --Update life score
    p.life_score = p.life_score + number
    while p.life_score >= p.life_score_target do
        p.life_score = p.life_score - p.life_score_target
        level_manager.giveLives(1, "score bonus")
    end

    --Update Score Counter
    counter = Util.findId("score_counter")
    counter:giveScore(number)

end

--Increase psycho's ultrablast
function level_manager.giveUltrablast(number)
    local p, t, counter, dist, signal, handle

    p = Util.findId("psycho")

    if not p then return end

    number = math.min(number, MAX_ULTRABLAST-p.ultrablast_counter)

    if number > 1 then
      level_manager.giveUltrablast(number - 1)
      number = 1
    elseif number < -1 then
      level_manager.giveUltrablast(number + 1)
      number = -1
     end


    p.ultrablast_counter = p.ultrablast_counter + number

    counter = Util.findId("ultrablast_counter")
    if not counter then return end
    if number > 0 then
       counter:ultraGained()
    else
       counter:ultraUsed()
    end
end

--Return functions
return level_manager
