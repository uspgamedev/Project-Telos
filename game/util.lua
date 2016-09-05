local FreeRes = require "FreeRes"

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
        for o in pairs do
            SUBTP_TABLE[subtp][o]:destroy()
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

--Add exception to not remove game elements:
function util.gameElementException(mode)

    if util.findSbTp("player_bullet") then
        util.addExceptionSubtype("player_bullet")
    end

    if util.findSbTp("enemies") then
        util.addExceptionSubtype("enemies")
    end

    if mode ~= "GAMEOVER" then
        util.addExceptionId("psycho")
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
        o:update(dt)
    end

end

--Update all objects with a subtype sb
function util.updateSubTp(dt, sb)
    util.updateTable(dt, SUBTP_TABLE[sb])
end

function util.updateTimers(dt)
    GAME_TIMER:update(dt)
    FX_TIMER:update(dt)
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

--Exit program
function util.quit()

    love.event.quit()

end

--Toggles debug mode
function util.toggleDebug()

    DEBUG = not DEBUG

end

--Toggles fullscreen
function util.toggleFullscreen()

    --Update global vars
    if love.window.getFullscreen() then
        --Go back to previous window configuration
        love.window.setFullscreen(false)
        WINDOW_WIDTH = PREVIOUS_WINDOW_WIDTH
        WINDOW_HEIGHT = PREVIOUS_WINDOW_HEIGHT
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true})
        FreeRes.setScreen(1)
    else
        --Go to fullscreen mode, saving last configuration for eventual return
        PREVIOUS_WINDOW_WIDTH = WINDOW_WIDTH
        PREVIOUS_WINDOW_HEIGHT = WINDOW_HEIGHT
        love.window.setFullscreen(true)
        WINDOW_WIDTH = love.graphics.getWidth()
        WINDOW_HEIGHT = love.graphics.getHeight()
        FreeRes.setScreen(1)
    end


end

--Get any key that is pressed and checks for generic events
function util.defaultKeyPressed(key)

    if  key == 'x' then
        util.quit()
    elseif key == 'f6' then
        util.toggleFullscreen()
    elseif key == 'b' then
        util.toggleDebug()
    end

end

--Return functions
return util
