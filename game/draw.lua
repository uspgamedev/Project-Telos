--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    --Start using canvas
    if not SCREEN_CANVAS and USE_CANVAS then
        SCREEN_CANVAS = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT) --Create canvas
        love.graphics.setCanvas(SCREEN_CANVAS)
        love.graphics.clear() --Clear previous stuff so Canvas won't draw
        love.graphics.setBlendMode("alpha") --Set alpha mode properly
    end

    --Makes transformations regarding screen curretn size
    FreeRes.transform()

    DrawTable(DRAW_TABLE.BG) --Background

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L1) --Circle effect

    DrawTable(DRAW_TABLE.L2) --Game particle effects

    DrawTable(DRAW_TABLE.L3) --Bullets, projectiles

    DrawTable(DRAW_TABLE.L4) --Psycho, enemies and ultrablast

    DrawTable(DRAW_TABLE.BOSS) --Bosses

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GAME_GUI) --Game GUI

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L5) --Indicators

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI) --Top GUI

    --Stop using canvas
    if USE_CANVAS then
        love.graphics.setCanvas() -- Stop tracking canvas

        --Draw screen one time
        love.graphics.setColor(255, 255, 255, 255)
        -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(SCREEN_CANVAS)
        love.graphics.setBlendMode("alpha")
    end

    --Creates letterbox at the sides of the screenm if needed
    FreeRes.letterbox(color)

end

--Draw all the elements in a table
function DrawTable(t)

    for o in pairs(t) do
        if not o.invisible then
          love.graphics.setShader(o.shader) --Set object shader, if any
          o:draw() --Call the object respective draw function
          love.graphics.setShader() --Remove shader, if any
        end
    end

end

--Return functions
return draw
