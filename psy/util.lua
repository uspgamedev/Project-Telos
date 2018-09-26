local ResManager = require "res_manager"
--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

---------------------
--UTILITIES FUNCTIONS
---------------------

--Counts how many entries are on table T
function util.tableLen(T)
  local count = 0
  if not T then return count end
  for _ in pairs(T) do count = count + 1 end
  return count
end

--Chcks if a tale is empty (true if it doesn't exist)
function util.tableEmpty(T)
  if not T then return true end
  return not next(T)
end

--Clear a single table T with an optional argument mode:
--  mode == "force": clear all elements, ignoring exceptions
--  mode == "remove": apply all exceptions, but removes them afterwards
--  else, just apply exceptions normally and keep them as they are
function util.clearTable(T, mode)
    local exc --Element exception

    if not T then return end --If table is empty
    --Clear T table
    for o in pairs (T) do
        if mode == "force" or not o.exception then --Don't erase exceptions
            o:destroy()
        end
        if o and o.exception and mode == "remove" then
            o.exception = false
        end
    end

end

--Clear all Drawable Tables (and respective Id/Subtype tables) with an optional argument mode:
--  mode == "force": clear all tables, ignoring exceptions
--  mode == "remove": apply all exceptions, but removes them afterwards
--  else, just apply exceptions normally and keep them as they are
function util.clearAllTables(mode)

    for _, T in pairs(DRAW_TABLE) do
        util.clearTable(T, mode)
    end

end

function util.clearTimerTable(T, TIMER)

    if not T then return end --If table is empty
    --Clear T table
    for _,o in pairs (T) do
        TIMER:cancel(o)
    end

end

--Return a random element from a given table.
--You can give an optional table argument 'tp', so it only returns elements that share a type with the table strings
--Obs: if you provide a tp table, and there isn't any suitable element available, the program will be trapped here forever (FIX THIS SOMETIME)
function util.randomElement(T, tp)
    local e

    while not e do
        e = T[love.math.random(util.tableLen(T))] --Get random element

        --If tp table isn't empty, compare
        if not util.tableEmpty(tp) then
            for i, k in pairs(tp) do
                if k == e.tp then
                    return e
                end
            end
            e = nil
        end
    end

    return e
end

--------------
--FIND OBJECTS
--------------

--Find an object based on an id
function util.findId(id)
    return ID_TABLE[id]
end

--Find a set of objects based on a subtype
function util.findSbTp(subtp)
    return SUBTP_TABLE[subtp]
end

-----------------
--DESTROY OBJECTS
-----------------

--Delete an object based on an id
function util.destroyId(id)
    if ID_TABLE[id] then ID_TABLE[id]:destroy() end
end

--Delete a set of objects based on a subtype
function util.destroySubtype(subtp)
    if SUBTP_TABLE[subtp] then
        for o in pairs(SUBTP_TABLE[subtp]) do
            o:destroy()
        end
    end
end

---------------------------
--APPLY EXCEPTION FUNCTIONS
---------------------------

--Adds exceptions to all elements in a given table
function util.addExceptionTable(T)
  for o in pairs(T) do
    o.exception = true
  end
end

--Adds exceptions to an element with a given id
function util.addExceptionId(id)

    if ID_TABLE[id] then
        ID_TABLE[id].exception = true
    else
        print ("Id not found:",id)
    end

end

--Adds exceptions to all elements with a subtype st
function util.addExceptionSubtype(st)
    if SUBTP_TABLE[st] then
        for o in pairs(SUBTP_TABLE[st]) do
            o.exception = true
        end
    else
        print("Subtype not found", st)
    end
end

--Removes exception in all elements in a given table
function util.rmvExceptionTable(T)
  for o in pairs(T) do
    o.exception = false
  end
end

--Removes exception in an element with a given id
function util.rmvExceptionId(id)
  for o in pairs(ID_TABLE) do
    if o.id == id then
      o.exception = false
      return
    end
  end
end

--Removes exception in all elements with a subtype st
function util.rmvExceptionSubtype(st)
  for o in pairs(SUBTP_TABLE[st]) do
    o.exception = false
  end
end

--Add exception to not remove game and gui elements:
function util.gameElementException(mode)

    --GAME ELEMENTS

    if mode ~= "GAMEOVER" then
        util.addExceptionId("psycho")
    end

    if util.findSbTp("player_bullet") then
        util.addExceptionSubtype("player_bullet")
    end

    if util.findSbTp("enemies") then
        util.addExceptionSubtype("enemies")
    end

    if util.findSbTp("cages") then
        util.addExceptionSubtype("cages")
    end

    if util.findSbTp("bosses") then
        util.addExceptionSubtype("bosses")
    end

    if util.findSbTp("decaying_particle") then
        util.addExceptionSubtype("decaying_particle")
    end

    if util.findSbTp("growing_circle") then
        util.addExceptionSubtype("growing_circle")
    end

    if util.findId("psycho_aim") then
        util.addExceptionId("psycho_aim")
    end

    if util.findSbTp("boss_effect") then
        util.addExceptionSubtype("boss_effect")
    end

    if util.findSbTp("indicator_aim") then
        util.addExceptionSubtype("indicator_aim")
    end

    if util.findSbTp("psycho_explosion") then
        util.addExceptionSubtype("psycho_explosion")
    end

    if util.findSbTp("ultrablast") then
        util.addExceptionSubtype("ultrablast")
    end

    if util.findSbTp("enemy_indicator") then
        util.addExceptionSubtype("enemy_indicator")
    end

    if util.findSbTp("enemy_indicator_batch") then
        util.addExceptionSubtype("enemy_indicator_batch")
    end

    if util.findSbTp("rotating_indicator") then
        util.addExceptionSubtype("rotating_indicator")
    end

    if util.findSbTp("tutorial_icon") then
        util.addExceptionSubtype("tutorial_icon")
    end

    --GUI ELEMENTS

    if util.findSbTp("game_gui") then
        util.addExceptionSubtype("game_gui")
    end

    if util.findSbTp("in-game_text") then
        util.addExceptionSubtype("in-game_text")
    end

    if util.findId("boss_title") then
        util.addExceptionId("boss_title")
    end

end

---------------------------
--APPLY INVISIBLE FUNCTIONS
---------------------------

--Adds exceptions to all elements in a given table
function util.addInvisibleTable(T)
  for o in pairs(T) do
    o.invisible = true
  end
end

--Adds invisibles to an element with a given id
function util.addInvisibleId(id)
  for o in pairs(ID_TABLE) do
    if o.id == id then
      o.invisible = true
      return
    end
  end
end

--Adds invisibles to all elements with a subtype st
function util.addInvisibleSubtype(st)
  for o in pairs(SUBTP_TABLE[st]) do
    o.invisible = true
  end
end

--Removes invisible in all elements in a given table
function util.rmvInvisibleTable(T)
  for o in pairs(T) do
    o.invisible = false
  end
end

--Removes invisible in an element with a given id
function util.rmvInvisibleId(id)
  for o in pairs(ID_TABLE) do
    if o.id == id then
      o.invisible = false
      return
    end
  end
end

--Removes invisible in all elements with a subtype st
function util.rmvInvisibleSubtype(st)

  for o in pairs(SUBTP_TABLE[st]) do
    o.invisible = false
  end

end

--------------------
--UPDATE FUNCTIONS
--------------------

--Update all objects in a table
function util.updateTable(dt, T)

    if not T then return end
    for o in pairs(T) do
        if o.update then
            o:update(dt)
        end
    end

end

--Update all objects with a subtype sb
function util.updateSubTp(dt, sb)
    util.updateTable(dt, SUBTP_TABLE[sb])
end

--Update an object with an id
function util.updateId(dt, id)
    local o

    o = util.findId(id)

    if not o then return end

    o:update(dt)

end

--Update all timers
function util.updateTimers(dt)
    local m_dt

    m_dt = dt
    if SLOWMO then
        m_dt = dt*SLOWMO_M
    end

    LEVEL_TIMER:update(m_dt)
    FX_TIMER:update(dt)
    COLOR_TIMER:update(dt)
    AUDIO_TIMER:update(dt)

end

--Update the fps counter
function util.updateFPS()
    util.findId("fps_counter").var = love.timer.getFPS()
end

----------------
--KILL FUNCTIONS
----------------

--Iterate through a table and destroys any element with the death flag on
function util.killTable(T)

    if not T then return end
    for o in pairs(T) do
        if o.death then o:destroy() end
    end

end

--Iterate through all elements with a subtype sb and destroy anything with the death flag on
function util.killSubTp(sb)

    util.killTable(SUBTP_TABLE[sb])

end

function util.killAll()

    for T in pairs(SUBTP_TABLE) do
        util.killSubTp(T)
    end

    for o in pairs(ID_TABLE) do
        util.killId(o)
    end

end

--Destroys a single element if his death flag is on
function util.killId(id)
    local o

    o = ID_TABLE[id]
    if o and o.death then
         o:destroy()
    end

end

--------------------
--GLOBAL FUNCTIONS
--------------------

--Makes all collisions
function util.checkCollision()
    local p, cont, arg, col

    p = util.findId("psycho")

    if SUBTP_TABLE["enemies"] then
        for e in pairs(SUBTP_TABLE["enemies"]) do
            if e.enter then

                --Checking ultrablast collision
                if SUBTP_TABLE["ultrablast"] then
                    for ultra in pairs(SUBTP_TABLE["ultrablast"]) do
                        if not ultra.death and e.tp ~= "grey_ball" and e.tp ~= "glitch_ball" and e.tp ~= "turret" and e.tp ~= "snake" and not e.death and e.game_win == ultra.game_win and ultra:collides(e) then
                            e:kill(false) --Don't give score if enemy is killed by ultrablast
                            ultra:takeHit()
                        end
                    end
                end

                --Checking player bullet collision
                if SUBTP_TABLE["player_bullet"] then
                    for bullet in pairs(SUBTP_TABLE["player_bullet"]) do
                        if not bullet.death and e.tp ~= "glitch_ball" and e:collides(bullet) then
                            if e.tp ~= "grey_ball" then --Don't kill enemy if its grey or glitch ball
                                e:kill()
                            end
                            bullet:kill()
                        end
                    end
                end

                --Colliding with psycho
                if p and not p.death and not p.invincible and e:collides(p) then
                    p:kill()
                end

            end
        end
    end

    --Colliding player bullets with bosses
    if SUBTP_TABLE["player_bullet"] then
        for bullet in pairs(SUBTP_TABLE["player_bullet"]) do
            if SUBTP_TABLE["bosses"] then
                for boss in pairs(SUBTP_TABLE["bosses"]) do
                    if not bullet.death then
                        col, arg = boss:collides(bullet)
                        if col then
                            bullet:kill()
                            if not boss.invincible then boss:getHit(arg) end
                        end
                    end
                end
            end
        end
    end

    --Colliding bosses with psycho
    if SUBTP_TABLE["bosses"] then
        for boss in pairs(SUBTP_TABLE["bosses"]) do
            --Colliding with psycho
            if p and not p.death and not p.invincible and boss:collides(p) then
                p:kill()
            end
        end
    end

end

--Exit program
function util.quit()

    love.event.quit()

end

--Toggle debug mode
function util.toggleDebug()

    DEBUG = not DEBUG
    print("DEBUG is", DEBUG)

end

--Toggle GODMODE
function util.toggleGODMODE()

    GODMODE = not GODMODE
    print("GODMODE is", GODMODE)

end

--Count all elements being drawn
function util.countDrawables()
    local cont

    cont = 0
    cont = cont + util.tableLen(DRAW_TABLE.L4)

    print("number of elements in draw table", cont)
end

--Toggles fullscreen
function util.toggleFullscreen()

    --Update global vars
    if love.window.getFullscreen() then
        --Go back to previous window configuration
        love.window.setFullscreen(false)
        love.window.setMode(PREVIOUS_WINDOW_WIDTH, PREVIOUS_WINDOW_HEIGHT, {resizable = true, minwidth = 800, minheight = 600})
        --This isn't called automatically
        love.resize(PREVIOUS_WINDOW_WIDTH, PREVIOUS_WINDOW_HEIGHT)

    else
        --Go to fullscreen mode, saving last configuration for eventual return
        PREVIOUS_WINDOW_WIDTH = ResManager.getRealWidth()
        PREVIOUS_WINDOW_HEIGHT = ResManager.getRealHeight()
        love.window.setFullscreen(true)

    end

end

--Get any key that is pressed and checks for generic events
function util.defaultKeyPressed(key)
    local p

    if  key == 'f1' then
      util.quit()
    elseif key == "f2" then
      print("JOYSTICK_AUTO_SHOOT is ",JOYSTICK_AUTO_SHOOT)
    elseif key == "f3" then
      HS.reset()
    elseif key == 'f4' then
      print("Closing the game without saving")
      os.exit()
    elseif key == "f5" then
      USE_ANTI_ALIASING = not USE_ANTI_ALIASING
    elseif key == 'f11' then
      util.toggleFullscreen()
    elseif key == 'f9' then
      util.toggleDebug()
    elseif key == "tab" then
      local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
      love.mouse.setGrabbed(state)
      print("MOUSE CAPTURE IS", state)
    end


end

--Return functions
return util
