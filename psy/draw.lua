--MODULE FOR DRAWING STUFF--

local ResManager = require "res_manager"

local draw = {}

local mainCanvas, blurCanvas, blackAndWhiteCanvas

function draw.config()
    mainCanvas = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
    blurCanvas1 = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
    blurCanvas2 = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
    blackAndWhiteCanvas = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)

end

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--We need to take some extra care when drawing Canvas
local function drawCanvas(canvas)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(canvas)
    love.graphics.setBlendMode("alpha")

end


--Draws everything that may need to be in black and white
local function blackAndWhiteDraw()
    love.graphics.clear()

    CAM:attach() --Start tracking camera

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

end

--Draws everything that may need to be blurred
local function blurDraw()
    love.graphics.clear()

    DrawTable(DRAW_TABLE.BG) --Background

    MENU_CAM:attach() --Start tracking main menu camera

    blackAndWhiteCanvas:renderTo(blackAndWhiteDraw)

    Black_White_Shader:send("factor", BLACK_WHITE_SHADER_FACTOR)
    love.graphics.setShader(Black_White_Shader)
    drawCanvas(blackAndWhiteCanvas)
    love.graphics.setShader()

end

--Draws every drawable object from all tables
local function mainDraw()
    love.graphics.clear()

    if USE_BLUR_CANVAS then
        --We need to use 2 Canvas because we need to apply 2 different shaders
        blurCanvas1:renderTo(blurDraw)

        blurCanvas2:renderTo(function()
            love.graphics.clear()
            love.graphics.setShader(Horizontal_Blur_Shader)
            drawCanvas(blurCanvas1)
        end)

        love.graphics.setShader(Vertical_Blur_Shader)
        drawCanvas(blurCanvas2)
        love.graphics.setShader()
    else
        blurDraw()
    end

    MENU_CAM:attach() --Start tracking main menu camera

    DrawTable(DRAW_TABLE.GUIl) --Behind Game GUI

    DrawTable(DRAW_TABLE.GUI) --Top GUI

    MENU_CAM:detach() --Start tracking main menu camera

end

function draw.allTables()
    love.graphics.clear()
    mainCanvas:renderTo(mainDraw)

    ResManager.preDraw()
    drawCanvas(mainCanvas)
    ResManager.postDraw()

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
