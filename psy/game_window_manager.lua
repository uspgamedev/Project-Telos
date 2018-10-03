local funcs = {}

local timers = {}

-------------------------
--GAME WINDOW FUNCTIONS--
-------------------------

--Creates a new game window and returns its index
function funcs.new(x,y,w,h,active)
    local win = {
        x = x,
        y = y,
        w = w,
        h = h,
        active = active
    }
    table.insert(GAME_WINDOWS,win)
    return #GAME_WINDOWS
end


--Return how many game windows there are
function funcs.getNumWin()
    return #GAME_WINDOWS
end

--Get a game window given its index
function funcs.getWin(win_idx)
    return GAME_WINDOWS[win_idx]
end

--Enable or disable given game window
function funcs.setWinStatus(win, status)
    GAME_WINDOWS[win_idx].active = status
end

--Checks if a given point (x,y) is inside given window
function funcs.isPointInWin(win_idx, x, y)
    local win = funcs.getWin(win_idx)
    return (x >= win.x and x <= win.x + win.w and
            y >= win.y and y <= win.y + win.h)
end

--Return which game window given point (x,y) is.
--Returns false if point isn't in any game window
--Ps: only considers active windows
function funcs.winAtPoint(x,y)
    for i, win in ipairs(GAME_WINDOWS) do
        if win.active and funcs.isPointInWin(i,x,y) then
            return win
        end
    end
    return false
end

-----------------------------
--Manipulating Game Windows--
-----------------------------

function funcs.setWinPos(idx, x, y)
    local win = GAME_WINDOWS[idx]
    assert(win ~= nil)
    win.x = x
    win.y = y
end

--Tween all attributes of a given window to given values
function funcs.tweenWin(idx, x, y, w, h, tween_func, d)
    local win = GAME_WINDOWS[idx]
    assert(win ~= nil)
    return LEVEL_TIMER:tween(d, win, {x = x, y = y, w = w, h = h}, tween_func)
end

return funcs
