require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
local FreeRes = require "FreeRes"
--PSYCHO AIM CLASS--
--[[Line and circle representing psycho's aim]]

local aim_functions = {}

-------
--AIM--
-------

--Particle that has an alpha decaying over-time
Aim = Class{
    __includes = {ELEMENT},
    init = function(self)

        ELEMENT.init(self) --Set atributes

        self.pos = Vector(0,0)
        self.dir = Vector(0,0)
        self.distance = math.sqrt(ORIGINAL_WINDOW_WIDTH^2 + ORIGINAL_WINDOW_HEIGHT^2)
        self.line_width = 1 --Thickness of aim line
        self.circle_thickness = 1 --Thickness of aim circle
        self.circle_size = 5
        self.mouse_pos = Vector(0,0)

        self.alpha = 0 --Alpha of aim

        self.tp = "aim" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Aim:draw()
    local aim, color

    --Don't draw if psycho is exploding
    if Util.findId("psycho").shootLocked and Util.findId("psycho").controlsLocked then return end

    aim = self
    color = Color.black()
    Color.copy(color, Util.findId("psycho").color)
    color.a = aim.alpha


    --Draw the line
    Color.set(color)
    love.graphics.setLineWidth(aim.line_width)
    love.graphics.line(aim.pos.x, aim.pos.y, aim.pos.x + aim.distance*aim.dir.x, aim.pos.y + aim.distance*aim.dir.y)

    --Draw the circle
    love.graphics.setLineWidth(aim.circle_thickness)
    love.graphics.circle("line", aim.mouse_pos.x, aim.mouse_pos.y, aim.circle_size)
end

function Aim:update(dt)
    local aim, p, w, h, scale

    aim = self
    p = Util.findId("psycho")

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --Update circle position
    aim.mouse_pos.x, aim.mouse_pos.y = x, y

    --Update line position
    aim.pos.x, aim.pos.y = p.pos.x, p.pos.y
    aim.dir.x, aim.dir.y = aim.mouse_pos.x - aim.pos.x, aim.mouse_pos.y - aim.pos.y
    aim.dir = aim.dir:normalized()

end

--UTILITY FUNCTIONS--

--Create a particle in the (x,y) position, direction dir, color c, radius r and subtype st
function aim_functions.create(id)
    local aim

    id = id or "aim" --subtype

    aim = Aim()

    aim:addElement(DRAW_TABLE.L2, nil, id)

    --Fade in the aim
    LEVEL_TIMER:after(3,
        function()
            LEVEL_TIMER:tween(.3, aim, {alpha = 90}, 'in-linear')
        end
    )

    return aim
end

--Return functions
return aim_functions
