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
    if not level_part then return end

    local off = 40
    level_part.level_handles["up"] = LEVEL_TIMER:tween(.8, level_part.pos, {y = level_part.pos.y - off}, 'in-out-quad',
      function()
        level_part.text = name --Update text
        level_part.pos.x = WINDOW_WIDTH/2 - level_part.font:getWidth(name)/2 --Update position
        level_part.level_handles["down"] = LEVEL_TIMER:tween(.8, level_part.pos, {y = level_part.pos.y + off}, 'in-out-quad')
      end
    )
end

--Create a centralized level title, that fades out after 3 seconds
function level_manager.level_title(chapter_name, chapter_upper_text)
    local fx, fy, x, y

    --Create texts and separator

    local chapter_name_font = GUI_LEVEL_TITLE
    local chapter_upper_text_font = GUI_MEDPLUS
    local separator_font = GUI_MEDPLUS


    local limit = 4*WINDOW_WIDTH/5

    --Get position so that the text is centralized on screen
    fx = math.min(chapter_name_font:getWidth(chapter_name),limit) --Width of text
    fy = chapter_name_font:getHeight(chapter_name)*  math.ceil(chapter_name_font:getWidth(chapter_name)/fx) --Height of text
    x = WINDOW_WIDTH/2 - fx/2
    y = WINDOW_HEIGHT/2 - fy/2
    --Create level title
    local name_txt = Txt.create_game_gui(x, y, chapter_name, chapter_name_font, nil, "format", nil, "game_title", "center", fx)
    name_txt.alpha = 0
    name_txt.use_stencil = true


    --Create separator between upper text and chapter name
    local string = ""
    while separator_font:getWidth(string) <= chapter_upper_text_font:getWidth(chapter_upper_text) + 10 do
      string = string .. "—"
    end
    fx = separator_font:getWidth(string)
    x = WINDOW_WIDTH/2 - fx/2
    y = y - 25
    --Create separator
    local separator_txt = Txt.create_game_gui(x, y, string, separator_font, nil, nil, nil, "game_title_separator")
    separator_txt.alpha = 0



    --Get position so that the text is centralized on screen and above chapter name
    fx = chapter_upper_text_font:getWidth(chapter_upper_text)
    fy = chapter_upper_text_font:getHeight(chapter_upper_text)
    x = WINDOW_WIDTH/2 - fx/2
    y = y - fy/2 - 5
    --Create upper text
    local upper_txt = Txt.create_game_gui(x, y, chapter_upper_text, chapter_upper_text_font, nil, nil, nil, "game_upper_title")
    upper_txt.alpha = 0

    --Start animation

    --Fade in first part
    upper_txt.level_handles["fade-in"] = LEVEL_TIMER:tween(1, upper_txt, {alpha = 255}, 'in-linear')
    separator_txt.level_handles["fade-in"] = LEVEL_TIMER:tween(1, separator_txt, {alpha = 255}, 'in-linear')

    --Fade-in second part
    name_txt.level_handles["fade-in-wait"] = LEVEL_TIMER:after(1.5,
        function()
            name_txt.level_handles["fade-in"] = LEVEL_TIMER:tween(1, name_txt, {alpha = 255}, 'in-linear')
        end
    )

    --Fade everything out
    upper_txt.level_handles["fade-out-wait"] = LEVEL_TIMER:after(4,
      function()
        upper_txt.level_handles["fade-out"] = LEVEL_TIMER:tween(1, upper_txt, {alpha = 0}, 'in-linear',
          function()
            upper_txt.death = true
          end
        )
      end
    )

    separator_txt.level_handles["fade-out-wait"] = LEVEL_TIMER:after(4,
      function()
        separator_txt.level_handles["fade-out"] = LEVEL_TIMER:tween(1, separator_txt, {alpha = 0}, 'in-linear',
          function()
            separator_txt.death = true
          end
        )
      end
    )

    name_txt.level_handles["fade-out-wait"] = LEVEL_TIMER:after(4,
      function()
        name_txt.level_handles["fade-out"] = LEVEL_TIMER:tween(1, name_txt, {alpha = 0}, 'in-linear',
          function()
            name_txt.death = true
          end
        )
      end
    )

end

--Create a centralized on top of screen boss title, that fades out after 3 seconds
function level_manager.boss_title(name)
    local txt, fx, fy, x, y, font, limit

    font = GUI_BOSS_TITLE
    limit = WINDOW_WIDTH

    --Get position so that the text is centralized on screen
    fx = math.min(font:getWidth(name),limit) --Width of text
    fy = font:getHeight(name)*  math.ceil(font:getWidth(name)/fx) --Height of text
    x = WINDOW_WIDTH/2 - fx/2
    y = WINDOW_HEIGHT/5 - fy/2

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
    x = WINDOW_WIDTH/2
    y = WINDOW_HEIGHT/2

    if dist >= 0 and dist <= WINDOW_WIDTH then
        x = dist
        y = -25
    elseif dist <= WINDOW_WIDTH + WINDOW_HEIGHT then
        x = WINDOW_WIDTH + 25
        y = dist - WINDOW_WIDTH
    elseif dist <= WINDOW_WIDTH + WINDOW_HEIGHT + WINDOW_WIDTH then
        x = 2*WINDOW_WIDTH - dist + WINDOW_HEIGHT
        y = WINDOW_HEIGHT + 25
    elseif dist <= 2*WINDOW_WIDTH + 2*WINDOW_HEIGHT then
        x = -25
        y = 2*WINDOW_HEIGHT - dist + 2*WINDOW_WIDTH
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

    if number > 0 then signal = "+" else signal = "" end --Get correct sign
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
    counter:giveScore(number, text)

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

-------------------------
--GAME WINDOW FUNCTIONS--
-------------------------

--[[Utility functions that manipulate in-game windows]]--

--Disable all game windows except first, and make it occupy the whole screen
--This assumes the game has at least one game window
function level_manager.resetGameWindow()
    --Sets up first game window to appropriate parameters
    if WINM.getNumWin() >= 1 then
        local win = WINM.getWin(1)
        win.x = 0
        win.y = 0
        win.w = WINDOW_WIDTH
        win.h = WINDOW_HEIGHT
        win.active = true
    else
        WINM.new(0,0,WINDOW_WIDTH,WINDOW_HEIGHT,true)
    end

    --Deletes all other windows
    for i = WINM.getNumWin(),2,-1 do
        WINM.delete(i)
    end
end

--[[
    Creates a new window, given a window to base the effect on,
    what attributes the old window {x,y,w,h} and attributes the new
    window {x,y,w,h} will have after the effects. You also provide the time the first
    part of the effect will take.
    Function will return the new window index.
]]--
function level_manager.createNewWindow(from_win_idx, from_win_attributes, new_win_attributes, dur)
    local new_att = new_win_attributes --Reduce variable name
    local from_att = from_win_attributes --Reduce variable name

    local old_win = WINM.getWin(from_win_idx)

    --Create new window above given window
    local new_idx = WINM.new(old_win.x,old_win.y,old_win.w,old_win.h,true)

    --Start shaking this new window
    local str = .1
    local str_speed = 3
    local d = dur or 4
    local orig_x = old_win.x
    local orig_y = old_win.y
    local elastic_dur = 1.5
    FX.shake(d-.1, 1)
    LEVEL_TIMER:during(d,
        function()
            WINM.setWinPos(new_idx,
                           orig_x + love.math.random(-str,str),
                           orig_y + love.math.random(-str,str))
            str = str + love.timer.getDelta()*str_speed
        end,
        --Start moving each window to its final position
        function()
            --Correct position
            WINM.setWinPos(new_idx, orig_x, orig_y)

            --Blink screen
            FX.blink_screen(.1, .1)

            LEVEL_TIMER:after(elastic_dur/5, function() FX.shake(.1, 6) end)
            WINM.tweenWin(new_idx, new_att[1], new_att[2], new_att[3], new_att[4],
                          "out-elastic", elastic_dur,
                          function()
                              WINM.setWinPos(new_idx, new_att[1], new_att[2])
                              WINM.setWinSize(new_idx, new_att[3], new_att[4])
                          end
            )
            WINM.tweenWin(from_win_idx, from_att[1], from_att[2], from_att[3], from_att[4],
                          "out-elastic", elastic_dur,
                          function()
                              WINM.setWinPos(from_win_idx, from_att[1], from_att[2])
                              WINM.setWinSize(from_win_idx, from_att[3], from_att[4])
                          end)
        end
    )

    return new_idx
end

--[[
    Destroys a given window, given its index and index of target window to make it
    "combine" with. You also provide what will be the new attribute of the combined window,
    and the duration for the first part of the effect.
    Function will return the id of combined window
]]--
function level_manager.destroyWindow(destroyed_win_idx, combined_win_idx, new_att, dur)
    local des_win = WINM.getWin(destroyed_win_idx)
    local com_win = WINM.getWin(combined_win_idx)

    --Get the halfway position between the two windows
    local halfway_pos = Vector((des_win.x + com_win.x)/2, (des_win.y + com_win.y)/2)
    local combine_dur = .1 --Duration for screens merging effect

    local str = .1
    local str_speed = 10
    local d = dur or 4
    local des_orig_x = des_win.x
    local des_orig_y = des_win.y
    local com_orig_x = com_win.x
    local com_orig_y = com_win.y
    --Shake the screen for a while, and make both screens tweak
    FX.shake(dur, 2)
    LEVEL_TIMER:during(dur,
        function()
            WINM.setWinPos(destroyed_win_idx,
                           des_orig_x + love.math.random(-str,str),
                           des_orig_y + love.math.random(-str,str))
            WINM.setWinPos(combined_win_idx,
                           com_orig_x + love.math.random(-str,str),
                           com_orig_y + love.math.random(-str,str))
            str = str + love.timer.getDelta()*str_speed
        end,
        function()
            --Correct positions
            WINM.setWinPos(combined_win_idx, com_orig_x, com_orig_y)
            WINM.setWinPos(destroyed_win_idx, des_orig_x, des_orig_y)

            FX.shake(combine_dur, 10)
            --Make both windows go to the halway position and then adjusting to the desired size
            WINM.tweenWin(destroyed_win_idx, halfway_pos.x, halfway_pos.y,
                          des_win.w, des_win.h, "in-quad", combine_dur,
                          function()
                              WINM.setWinStatus(destroyed_win_idx, false)
                          end
            )
            WINM.tweenWin(combined_win_idx, halfway_pos.x, halfway_pos.y,
                        com_win.w, com_win.h, "in-quad", combine_dur,
                        function()
                            FX.blink_screen(.1, .2)
                            FX.shake(.15, 6)
                            WINM.tweenWin(combined_win_idx, new_att[1], new_att[2], new_att[3], new_att[4],
                                          "out-elastic", 1,
                                          function()
                                              WINM.setWinPos(combined_win_idx, new_att[1], new_att[2])
                                              WINM.setWinSize(combined_win_idx, new_att[3], new_att[4])
                                          end
                            )
                        end
            )
        end
    )
end

--Return functions
return level_manager
