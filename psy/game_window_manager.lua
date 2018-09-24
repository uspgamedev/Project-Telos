local funcs = {}

-------------------------
--GAME WINDOW FUNCTIONS--
-------------------------

--Checks if a given point (x,y) is inside given window
function funcs.isPointInWin(win_idx, x, y)
    local win = GAME_WINDOWS[win_idx]
    return (x >= win.x and x <= win.x + win.w and
            y >= win.y and y <= win.y + win.h)
end

--Return which game window given point (x,y) is.
--Returns false if point isn't in any game window
--Ps: only considers active windows

function funcs.winAtPoint(x,y)
    for i, win in ipairs(GAME_WINDOWS) do
        if win.active and funcs.isPointInWin(i,x,y) then
            return i
        end
    end
    return false
end

return funcs
