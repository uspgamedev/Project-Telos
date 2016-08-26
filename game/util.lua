--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

---------------------
--UTILITIES FUNCTIONS
---------------------


--Clear a single table T with an optional argument mode:
--  mode == "force": clear all elements, ignoring exceptions
--  mode == "remove": apply all exceptions, but removes them afterwards
--  else, just apply exceptions normally and keep them as they are
function util.clearTable(T, mode)
    local exc --Element exception

    if not T then return end --If table is empty

    --Clear T table
    for o in pairs (T) do
        exc = o.exception
        if mode == "force" or not exc then --Don't erase exceptions
        	if exc ~= nil and mode == "remove" then exc = false end
            o:destroy()
        end
    end

end

--Clear all Drawable Tables (and respective Id/Subtype tables) with an optional argument mode:
--  mode == "force": clear all tables, ignoring exceptions
--  mode == "remove": apply all exceptions, but removes them afterwards
--  else, just apply exceptions normally and keep them as they are
function util.clearAllTables(mode)

    for _, t in pairs(DRAW_TABLE) do
        util.clearTable(t, mode)
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
function util.findSubtype(subtp)
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
function util.addExceptionTable(t)
  for o in pairs(t) do
    o.exception = true
  end
end

--Adds exceptions to an element with a given id
function util.addExceptionId(id)

    if ID_TABLE[id] then
        ID_TABLE[id].exception = true
    else
        print ("Id not found")
    end

end

--Adds exceptions to all elements with a subtype st
function util.addExceptionSubtype(st)
    if SUBTP_TABLE[st] then
        for o in pairs(SUBTP_TABLE[st]) do
            o.exception = true
        end
    end
end

--Removes exception in all elements in a given table
function util.rmvExceptionTable(t)
  for o in pairs(t) do
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

---------------------------
--APPLY INVISIBLE FUNCTIONS
---------------------------

--Adds exceptions to all elements in a given table
function util.addInvisibleTable(t)
  for o in pairs(t) do
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
function util.rmvInvisibleTable(t)
  for o in pairs(t) do
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
function util.updateTable(dt, t)

    if not t then return end
    for o in pairs(t) do
        o:update(dt)
    end

end

--Update all objects with a subtype sb
function util.updateSubTp(dt, sb)
    util.updateTable(dt, SUBTP_TABLE[sb])
end

--Iterate through a table and destroy any element with the death flag on
function util.killTable(t)

    if not t then return end
    for o in pairs(t) do
        if o.death then o:destroy() end
    end

end

--Iterate through all elements with a subtype sb and destroy anything with the death flag on
function util.killSubTp(sb)
    util.killTable(SUBTP_TABLE[sb])
end

--------------------
--GLOBAL FUNCTIONS
--------------------

--Exit program
function util.quit()

    love.event.quit()

end

--Toggles DEBUG
function util.toggleDebug()

    DEBUG = not DEBUG

end

--Get any key that is pressed and checks for generic events
function util.defaultKeyPressed(key)

    if key == 'escape' or key == 'x' then
        util.quit()
    elseif key == 'b' then
        util.toggleDebug()
    end

end


--Return functions
return util
