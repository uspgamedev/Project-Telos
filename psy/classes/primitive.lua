local Color = require "classes.color.color"
local Util = require "util"

--PRIMITIVE CLASS--

local primitive = {}

--[[Primitive classes to inherit from]]

--Element: has a type, subtype and id
ELEMENT = Class{
    init = function(self)
        self.tp = nil --Type this element belongs to
        self.subtp = nil --Subtype this element belongs to, if any
        self.id = nil --Id of this element, if any
        self.exception = false --If this object is not to be removed when clearing tables
        self.invisible = false --If this object is not to be draw
        self.death = false --If true, the object will be deleted next update
        self.handles = {} --Table containing active color timer handles for this object
        self.level_handles = {} --Table containing active level timer handles for this object
    end,

    --Sets id for this element, and add it to a ID table for quick lookup
    setId = function(self, _id)
        if self.id then
            ID_TABLE[self.id] = nil --Delete previous Id element
        end
        self.id = _id
        if not _id then return end --If nil, just remove
        ID_TABLE[_id] = self
    end,
    --Sets subtype for this element, and add it to respective subtype table for quick lookup
    setSubTp = function(self, _subtp)
        if self.subtp then
            SUBTP_TABLE[self.subtp][self] = nil --Delete previous subtype this element had
            if not next(SUBTP_TABLE[self.subtp]) then
                SUBTP_TABLE[self.subtp] = nil   --If no more elements of this subtype, delete the table
            end
        end
        self.subtp = _subtp
        if not _subtp then return end  --If nil, just remove element
        if not SUBTP_TABLE[self.subtp] then
            SUBTP_TABLE[self.subtp] = {} --Creates subtype table if it didn't exist
        end
        SUBTP_TABLE[self.subtp][self] = true
    end,

    destroy = function(self, t) --Destroy this element from all tables (quicker if you send his drawable table, if he has one)
        self:setSubTp(nil) --Removes from Subtype table, if its in one
        self:setId(nil) --Removes from Id table, if its in one
        if self.handles then
            for _,h in pairs(self.handles) do
                COLOR_TIMER:cancel(h) --Stops any timers this object has
            end
        end
        if self.level_handles then
            for _,h in pairs(self.level_handles) do
                LEVEL_TIMER:cancel(h) --Stops any timers this object has
            end
        end
        if t then
            t[self] = nil --If you provide the  drawable table, removes from it quicker
        else
            for _,tb in pairs(DRAW_TABLE) do--Iterates in all drawable tables and removes element
                if tb[self] then
                    tb[self] = nil
                    return
                end
            end
        end
    end,

    addElement = function(self, t, subtp, id) --Add element to a t drawable table, and if desired, adds a subtype and/or id
        if subtp then self:setSubTp(subtp) end
        if id then self:setId(id) end
        t[self] = true
    end,

    --Kill this object
    kill = function(self)

        if self.death then return end
        self.death = true

    end,

    --Checks if an circular object o collides with this enemy
    collides = function (self, o)
        local e , dx, dy, dr

        e = self
        dx = e.pos.x - o.pos.x
        dy = e.pos.y - o.pos.y

        --In case of psycho, check collision with his collision radius
        if o.tp == "psycho" then
            dr = e.r + o.collision_r
        else
            dr = e.r + o.r
        end

        return (dx*dx + dy*dy) < dr*dr

    end
}

-------------------
--CHARACTERISTICS--
-------------------

--Positionable: has a x and y position
POS = Class{
    init = function(self, _x, _y) --Set position for object
        self.pos = Vector(_x or 0, _y or 0) --Position vector
    end,

    setPos = function(self, _x, _y) --Set position for object
        self.pos.x, self.pos.y = _x, _y
    end
}

--Colorful: the object has a color, and a color table for  transistions
CLR = Class{
    init = function(self, _c, _color_table, _color_duration)
        self.color = HSL() --This object main color
        if _c then Color.copy(self.color, _c) end
        self.color_table = _color_table or {}
        self.color_duration = _color_duration or 4
    end,

    setColor = function(self, _c) --Set object's color
        Color.copy(self.color, _c)
    end,

    getRandColor = function(self) --Get a random color from color table (except last color), for the getDiffRandColor function
        local size

        size = Util.tableLen(self.color_table)
        if size > 0 then
            return self.color_table[love.math.random(size-1)]
        else
            print("Empty color table")
        end
    end,

    getDiffRandColor = function(self) --Get a random color from color table different from current
        local color, size

        color = self:getRandColor()
        --In case the color is equal, get the last color that couldn't be chosen in the getRandColor function
        if math.floor(color.h) == math.floor(self.color.h) and
           math.floor(color.s) == math.floor(self.color.s) and
           math.floor(color.l) == math.floor(self.color.l) then
             size = Util.tableLen(self.color_table)
             color = self.color_table[size]
        end
        return color
    end,

    startColorLoop = function(self)
        FX.colorLoop(self, "color")
    end
}

--With-Text: the object has a text
WTXT = Class{
    init = function(self, _text, _font, _t_color) --Set circle's atributes
        self.text = _text or "sample" --This object text
        self.font = _font             --This object text font
        self.t_color = _t_color or HSL(0,0,0) --This object text color
        if _text_color then Color.copy(self.t_color, _t_color) end
    end,

    setTextColor = function(self, _c) --Set object's text color
        Color.copy(self.t_color, _c)
    end
}

----------
--SHAPES--
----------

-----------------------
--RECTANGLE FUNCTIONS--
-----------------------

--Rectangle: is a positionable and colorful object with width and height
RECT = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _w, _h, _c, _color_table) --Set rectangle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.w = _w or 10 --Width
        self.h = _h or 10 --Height
        CLR.init(self, _c, _color_table)
    end,

    resize = function(self, _w, _h) --Change width/height
        self.w = _w
        self.h = _h
    end

}

----------------------
--TRIANGLE FUNCTIONS--
----------------------

--Triangle: is a positionable and colorful object with three points
TRIANGLE = Class{
    __includes = {ELEMENT, CLR},
    init = function(self, _pos1, _pos2, _pos3, _color, _color_table, _mode, _line_width) --Set rectangle's atributes
        ELEMENT.init(self)

        --Triangle positions
        self.p1 = Vector(_pos1.x, _pos1.y)
        self.p2 = Vector(_pos2.x, _pos2.y)
        self.p3 = Vector(_pos3.x, _pos3.y)

        self.mode = self.mode or _mode or "line" --Mode to draw the triangle
        self.line_width = _line_width or 3 --Line thickness if mode is line

        CLR.init(self, _color, _color_table)

    end
}

function TRIANGLE:draw()
    local t

    t = self

    --Draws the triangle
    Color.set(t.color)
    if t.line_width then love.graphics.setLineWidth(t.line_width) end
    love.graphics.polygon(t.mode, t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y)
end

--------------------
--CIRCLE FUNCTIONS--
--------------------

--Circle: is a positionable and colorful object with radius
CIRC = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _r, _c, _color_table, _mode) --Set circle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.r = _r or 10 --Radius
        self.mode = _mode or "fill" --Circle draw mode
        CLR.init(self, _c, _color_table)
    end,

    resize = function(self, _r) --Change radius
        self.r = _r
    end
}

--Draws the circle
function CIRC:draw()
    local p

    p = self

    --Draws the circle
    Color.set(p.color)
    if p.mode == "line" then
        love.graphics.setLineWidth(p.line_width)
        love.graphics.circle(p.mode, p.pos.x, p.pos.y, p.r)
    else
        Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r)
    end
end

-------------------
--ENEMY FUNCTIONS--
-------------------

ENEMY = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dir, _speed_m, _radius, _score_mul, _color_table, _speedv, _score_value)
        local dx, dy, r, color, color_table

        r = _radius or 20 --Radius of enemy

        color_table = _color_table or {}

        --Color of enemy
        if not Util.tableEmpty(color_table) then
            color = color_table[love.math.random(#color_table)]
        else
            color = Color.pink()
        end

        CIRC.init(self, _x, _y, r, color, color_table, "fill")

        --Set atributes
        ELEMENT.setSubTp(self, "enemies")

        self.color_duration = 6 --Duration between color transitions

        --Normalize direction and set speed
        self.speedv = _speedv or 270 --Speed value
        self.speed_m = _speed_m or 1 --Speed multiplier
        self.speed = Vector(_dir.x, _dir.y) --Speed vector
        self.speed = self.speed:normalized()*self.speedv

        self.score_value = _score_value or 25 --Score this enemy gives when killed without multiplier
        self.score_mul = _score_mul or 1 --Score multiplier

        self.enter = false --If this enemy has already entered the game screen
        self.tp = "simple_enemy" --Type of this class
    end
}

--Draws the enemy
function ENEMY:draw()
    local p

    p = self

    if not p.enter then return end

    --Draws the circle
    Color.set(p.color)
    if p.mode == "line" then
        Draw_Smooth_Ring(p.pos.x, p.pos.y, p.r, p.r-p.line_width)
    else
        Draw_Smooth_Circle(p.pos.x, p.pos.y, p.r)
    end

end

--------------------
--GLOBAL FUNCTIONS--
--------------------

--Receives the center x and y values of a circle, and its radius, and draw it on the screen
--OBS: Have the color already setted
function Draw_Smooth_Circle(x, y, r)

    x = x - r
    y = y - r

    size = math.ceil(2*r)
    --Create smooth circle shader if it hasn't been yet
    if not SMOOTH_CIRCLE_TABLE[size] then
        print("creating circle shader for size ".. size)
        SMOOTH_CIRCLE_TABLE[size] = love.graphics.newShader(Smooth_Circle_Shader:format(size))
    end

    --Draw the circle
    love.graphics.setShader(SMOOTH_CIRCLE_TABLE[size])
    love.graphics.draw(PIXEL, x, y, 0, 2*r)
    love.graphics.setShader()

end

--Receives the center x and y values of a ring, its radius and inner_radius, and draw it on the screen
--OBS: Have the color already setted
function Draw_Smooth_Ring(x, y, r, i_r)

    x = x - r
    y = y - r

    size = math.ceil(2*r)
    i_r = math.ceil(i_r)
    --Create smooth circle shader if it hasn't been yet
    if not SMOOTH_RING_TABLE[size..'-'..i_r] then
        print("creating ring shader for size ".. size.." and inner radius "..i_r)
        SMOOTH_RING_TABLE[size..'-'..i_r] = love.graphics.newShader(Smooth_Ring_Shader:format(size, i_r))
    end

    --Draw the circle
    love.graphics.setShader(SMOOTH_RING_TABLE[size..'-'..i_r])
    love.graphics.draw(PIXEL, x, y, 0, 2*r)
    love.graphics.setShader()

end
