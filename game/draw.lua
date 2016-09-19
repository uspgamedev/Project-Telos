--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    --Makes transformations regarding screen curretn size
    FreeRes.transform()

    DrawTable(DRAW_TABLE.BG) --Background

    DrawTable(DRAW_TABLE.L1) --Circle effect

    DrawTable(DRAW_TABLE.L2) --Game particle effects

    --CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L3) --Bullets and projectiles

    DrawTable(DRAW_TABLE.L4) --Psycho and enemies

    DrawTable(DRAW_TABLE.GAME_GUI) --Game GUI

    --CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI) --Top GUI

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
