--MODULE TO CREATE ENEMY FORMATIONS--

local formation = {}

--Formation of a line of enemies coming from the left or right, with several modes:
--center (default): place enemies from the center of the screen, spaced with enemy margin and can be moved with screen_margin
--distribute: place balls equally distributed on the screen side
--top: start placing from the top , with an optional screen margin
--bottom: start placing from the bottom, with an optional screen margin
function formation.fromHorizontal(side, mode, enemy, number, enemy_x_margin, enemy_y_margin, screen_margin)
    local x, y, d, r, dir, half
    r = enemy.radius()

    if side == "left" or side == "l" then
        dir = Vector(1,0)
        x = -5 -r
    elseif side == "right" or side == "r" then
        dir = Vector(-1,0)
        x = ORIGINAL_WINDOW_WIDTH + 5 + r
    end

    --Default values
    screen_margin = screen_margin or 0
    enemy_x_margin = enemy_x_margin or 10
    enemy_y_margin = enemy_y_margin or 0
    number = number or 3

    --Center mode
    if     mode == "center" then
        half = math.floor(number/2)
        d = enemy_x_margin + 2*r
        y = ORIGINAL_WINDOW_HEIGHT/2 - (number-1)/2 *d + screen_margin
        --Placing from the center
        for i=1, number do
            enemy.create(x - math.abs(i-half-1)*(enemy_y_margin + 2*r)*dir.x, y, dir)
            y = y + d
        end
    --Distribute mode
    elseif mode == "distribute" then
        for i=1, number do
            y = i* (ORIGINAL_WINDOW_HEIGHT/(number+1))
            enemy.create(x, y, dir)
        end

    --Top mode
    elseif mode == "top" then
        y = screen_margin + r
        for i=1, number do
            enemy.create(x, y, dir)
            y = y + enemy_margin + 2*r
        end

    --Bottom mode
    elseif mode == "bottom" then
        y = ORIGINAL_WINDOW_HEIGHT - screen_margin - r
        for i=1, number do
            enemy.create(x, y, dir)
            y = y - enemy_margin - 2*r
        end
    end
end

--Formation of a line of enemies coming from the top or bottom, with several modes:
--center (default): place enemies from the center of the screen, spaced with enemy_margin
--distribute: place balls equally distributed on the screen side
--left: start placing from the left , with an optional screen margin
--right: start placing from the right, with an optional screen margin
function formation.fromVertical(side, mode, enemy, number, enemy_x_margin, enemy_y_margin, screen_margin)
    local x, y, d, r, dir
    r = enemy.radius()

    if side == "top" or side == "t" then
        dir = Vector(0,1)
        y = -5 -r
    elseif side == "bottom" or side == "b" then
        dir = Vector(0,-1)
        y = ORIGINAL_WINDOW_HEIGHT + 5 + r
    end

    --Default values
    screen_margin = screen_margin or 0
    enemy_margin = enemy_margin or 10
    number = number or 3

    --Center mode
    if     mode == "center" then
        d = enemy_margin + 2*r
        x = ORIGINAL_WINDOW_WIDTH/2 - (number-1)/2 *d
        --Placing from the center
        for i=1, number do
            enemy.create(x, y, dir)
            x = x + d
        end
    --Distribute mode
    elseif mode == "distribute" then
        for i=1, number do
            x = i* (ORIGINAL_WINDOW_WIDTH/(number+1))
            enemy.create(x, y, dir)
        end

    --Left mode
elseif mode == "left" then
        x = screen_margin + r
        for i=1, number do
            enemy.create(x, y, dir)
            x = x + enemy_margin + 2*r
        end

    --Right mode
elseif mode == "right" then
        x = ORIGINAL_WINDOW_WIDTH - screen_margin - r
        for i=1, number do
            enemy.create(x, y, dir)
            x = x - enemy_margin - 2*r
        end
    end
end

--Create an evenly distributed circle of enemies, with a specific radius
function formation.circle(enemy, number, radius)
    local a, x, y, dir
    a = 2*math.pi/number --Divides the circunference
    for i=1, number do
        x, y = radius*math.cos(i*a), radius*math.sin(i*a) --Get position in circle with radius and center (0,0)
        dir = Vector(-x,-y) --Get direction pointing to center
        x, y = ORIGINAL_WINDOW_WIDTH/2+ x, ORIGINAL_WINDOW_HEIGHT/2+ y
        enemy.create(x, y, dir)
    end
end

--Return functions
return formation
