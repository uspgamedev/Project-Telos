--MODULE TO CREATE ENEMY FORMATIONS--

local formation = {}

--Formation of a line of enemies coming from the left, spaced with a margin
--mode:
--center (default): place enemies from the center of the screen, spaced with enemy_margin
--distribute: place balls equally distributed on the screen side
--top: start placing from the top , with an optional screen margin
--bottom: start placing from the bottom, with an optional screen margin
function formation.fromLeft(enemy, number, enemy_margin, mode, screen_margin)
    local x, y, d, r, dir
    r = enemy.radius()
    dir = Vector(1,0) --Going right
    x = -5 -r --Start at the left of screen

    --Center mode
    if not mode or mode == "center" then
        d = enemy_margin + 2*r
        y = WINDOW_HEIGHT/2 - (number-1)/2 *d
        --Placing from the center
        for i=1, number do
            enemy.create(x,y, dir)
            y = y + d
        end
    --Distribute mode
    elseif mode == "distribute" then
        for i=1, number do
            y = i* W/(n+1)
            enemy.create(x,y, dir)
        end

    --Top mode
    elseif mode == "top" then
        y = screen_margin or 0
        y = y + r
        for i=1, number do
            enemy.create(x,y, dir)
            y = y + enemy_margin + 2*r
        end

    --Bottom mode
    elseif mode == "bottom" then
        y = screen_margin or 0
        y = WINDOW_HEIGHT - y
        for i=1, number do
            enemy.create(x,y, dir)
            y = y - enemy_margin + 2*r
        end
    end
end

--Return functions
return formation
