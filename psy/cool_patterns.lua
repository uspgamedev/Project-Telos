--PATTERNS NAO USADOS AINDA

--PENGUIN - SHOOTER by yan
LM.wait(2)
INDICATOR_DEFAULT = 1.25
local all = 2*WINDOW_WIDTH+2*WINDOW_HEIGHT
for i = 1, 60 do
    local _x, _y = LM.outsidePosition(all * i / 60)
    local en = {SB, DB}
    local p = (i % 2) + 1
    F.single{enemy = en[p], x = _x, y = _y, dir_follow = true, speed_m = 5, ind_side = 25}
    _x, _y = LM.outsidePosition(all * (60 - i) / 60)
    F.single{enemy = en[3 - p], x = _x, y = _y, dir_follow = true, speed_m = 4, ind_side = 25}
    LM.wait(.3)
end
