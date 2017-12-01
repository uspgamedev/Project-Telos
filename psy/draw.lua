--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    --Makes transformations regarding screen current size
    FreeRes.transform()

    --Start using canvas
    if not SCREEN_CANVAS and USE_CANVAS then
        SCREEN_CANVAS = love.graphics.newCanvas(ORIGINAL_WINDOW_WIDTH, ORIGINAL_WINDOW_HEIGHT) --Create canvas
        love.graphics.setCanvas(SCREEN_CANVAS)
        love.graphics.clear() --Clear previous stuff so Canvas won't draw
        love.graphics.setBlendMode("alpha") --Set alpha mode properly
    end

    if USE_BLUR_CANVAS then
        love.graphics.pop() --Stop tracking effects on screen transformations for the canvas

        if not BLUR_CANVAS_1 then
            BLUR_CANVAS_1 = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
        end
        love.graphics.setCanvas(BLUR_CANVAS_1)
        love.graphics.setBlendMode("alpha") --Set alpha mode properly

        FreeRes.transform() --Return transformations onscreen
    end

    DrawTable(DRAW_TABLE.BG) --Background

    MENU_CAM:attach() --Start tracking main menu camera

    CAM:attach() --Start tracking camera

    local old_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(BLACK_WHITE_CANVAS)
    love.graphics.clear()

    DrawTable(DRAW_TABLE.L1)  --Circle effect

    DrawTable(DRAW_TABLE.L2)  --Game particle effects and tutorial icons

    DrawTable(DRAW_TABLE.L3)  --Bullets, projectiles

    DrawTable(DRAW_TABLE.L4)  --Psycho, enemies and ultrablast

    DrawTable(DRAW_TABLE.L4u) --Above regular enemies and psycho

    DrawTable(DRAW_TABLE.BOSS) --Bosses

    DrawTable(DRAW_TABLE.BOSSu) --Bosses

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GAME_GUI) --Game GUI

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L5) --Indicators and aim circle

    DrawTable(DRAW_TABLE.L5u) --Shadows and other effects

    CAM:detach() --Stop tracking camera

    MENU_CAM:detach() --Start tracking main menu camera

    love.graphics.setCanvas(old_canvas)

    --Draw stuff (in black and white if needed)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBlendMode("alpha", 'premultiplied') --Set alpha mode properly
    Black_White_Shader:send("factor", BLACK_WHITE_SHADER_FACTOR)
    love.graphics.setShader(Black_White_Shader)
    love.graphics.draw(BLACK_WHITE_CANVAS)
    love.graphics.setShader()
    love.graphics.setBlendMode("alpha") --Set alpha mode properly

    if USE_BLUR_CANVAS then
        love.graphics.pop() --Stop tracking effects on screen transformations for the canvas

        --Draws the first canvas into the second, using horizontal blur shader
        if not BLUR_CANVAS_2 then
            BLUR_CANVAS_2 = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
        end
        love.graphics.setCanvas(BLUR_CANVAS_2)
        love.graphics.setShader(Horizontal_Blur_Shader)
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(BLUR_CANVAS_1)

        --Draws the second canvas into the scren or main canvas, using vertical blur shader
        love.graphics.setCanvas()
        if USE_CANVAS then
            love.graphics.setCanvas(SCREEN_CANVAS)
        end
        love.graphics.setShader(Vertical_Blur_Shader)
        love.graphics.draw(BLUR_CANVAS_2)
        love.graphics.setBlendMode("alpha") --Set alpha mode properly
        love.graphics.setShader()

        FreeRes.transform() --Return transformations onscreen
    end

    MENU_CAM:attach() --Start tracking main menu camera

    DrawTable(DRAW_TABLE.GUIl) --Behind Game GUI

    DrawTable(DRAW_TABLE.GUI) --Top GUI

    MENU_CAM:detach() --Start tracking main menu camera


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

    --Creates letterbox at the sides of the screen if needed
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
