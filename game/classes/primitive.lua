local Color = require "classes.color.color"

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
        dr = e.r + o.r

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

--Colorful: the object has a color
CLR = Class{
    init = function(self, _c)
        self.color = HSL() --This object main color
        if _c then Color.copy(self.color, _c) end
    end,

    setColor = function(self, _c) --Set object's color
        Color.copy(self.color, _c)
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

--Rectangle: is a positionable and colorful object with width and height
RECT = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _w, _h, _c) --Set rectangle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.w = _w or 10 --Width
        self.h = _h or 10 --Height
        CLR.init(self, _c)
    end,

    resize = function(self, _w, _h) --Change width/height
        self.w = _w
        self.h = _h
    end

}

--Circle: is a positionable and colorful object with radius
CIRC = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _r, _c, _mode) --Set circle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.r = _r or 10 --Radius
        self.mode = _mode or "fill" --Circle draw mode
        CLR.init(self, _c)
    end,

    resize = function(self, _r) --Change radius
        self.r = _r
    end
}
