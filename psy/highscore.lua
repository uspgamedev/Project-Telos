local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local Txt = require "classes.text"
local Particle = require "classes.particle"

--MODULE WITH FOR HANDLING HIGHSCORES AND STUFF--
local hs = {}

--[[Highscore table: Goes from 1 to MAX_HIGHSCORE, where HIGHSCORES[1] is the biggest score, and
   HIGHSCORES[MAX_HIGHSCORE] is the lowest ]]

--Print all highscores on the terminal (for debugging purposes)
function hs.print()

    if not HIGHSCORES then
        print("Highscores not found")
        return
    end

    print("--HIGHSCORE--")
    for i = 1, MAX_HIGHSCORE do
        print(HIGHSCORES[i].name, HIGHSCORES[i].score)
    end
    print("-----------")

end


--Create text related to highscores in the middle of the screen. Can provide an optional argument "position", to highlight a position in the highscore
--An optional x_offset or y_offset argument will create all texts with an offset to their original position
function hs.draw(position, x_offset, y_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0

    local texts = {} --Table for texts, used for highlighting a given position received by the function, if it exists

    --Draw header
    Txt.create_gui(180 + x_offset, 100 + y_offset, "HIGHSCORES", GUI_HIGHSCORE, nil, "format", nil, "highscore_title", "center", ORIGINAL_WINDOW_WIDTH/1.5, nil, "highscore_screen_texts")
    Txt.create_gui(180 + x_offset, 110 + y_offset, "__________", GUI_HIGHSCORE, nil, "format", nil, "highscore_title_underscore", "center", ORIGINAL_WINDOW_WIDTH/1.5, nil, "highscore_screen_texts")

    local invert --Will invert colors of given player stats, if function receives a 'position' argument
    --Draw highscores
    for i = 1, MAX_HIGHSCORE do

        if position and i == position then
            invert = true
        else
            invert = false
        end

        local t

        --Draw numbers
        t = Txt.create_gui(235 + x_offset, 140+i*80 + y_offset, i, GUI_BOSS_TITLE, nil, nil, nil, "highscore_number_"..i, nil, nil, invert, "highscore_screen_texts")
        if invert then
            t.angle = 0 --Creates a angle variable fo the highlight effect
            table.insert(texts, t)
        end

        --Draw numberdot
        t = Txt.create_gui(275 + x_offset, 140+i*80 + y_offset, ".", GUI_BOSS_TITLE, nil, nil, nil, "highscore_dot"..i, nil, nil, invert, "highscore_screen_texts")
        if invert then
            t.angle = 0 --Creates a angle variable fo the highlight effect
            table.insert(texts, t)
        end

        --Draw player name
        t = Txt.create_gui(400 + x_offset, 140+i*80 + y_offset, HIGHSCORES[i].name, GUI_BOSS_TITLE, nil, nil, nil, "highscore_name"..i, nil, nil, invert, "highscore_screen_texts")
        if invert then
            t.angle = 0 --Creates a angle variable fo the highlight effect
            table.insert(texts, t)
        end

        --Draw player score
        t = Txt.create_gui(660 + x_offset, 140+i*80 + y_offset, HIGHSCORES[i].score, GUI_BOSS_TITLE, nil, nil, nil, "highscore_score"..i, nil, nil, invert, "highscore_screen_texts")
        if invert then
            t.angle = 0 --Creates a angle variable fo the highlight effect
            table.insert(texts, t)
        end

        if invert then
            FX.rotate_objects(texts)
        end

    end
end

--Reset all highscores to name "---" and score 0
function hs.reset()

    for i = 1, MAX_HIGHSCORE do
        HIGHSCORES[i].name = "---"
        HIGHSCORES[i].score = 0
    end
    print("---------\nHighscores reseted\n---------")

end

--If given score will enter highscore, return the position it will enter. Returns false otherwise. Ties will always enter.
function hs.isHighscore(score)

    for i = 1, MAX_HIGHSCORE do
        if HIGHSCORES[i].score <= score then return i end
    end

    return false
end

--Add a name (3 letters only) and score to the highscore table.
--IMPORTANT: Score given must be inside highscore table. Score at worst case will always enter last position
function hs.addHighscore(name, score)

    local position = MAX_HIGHSCORE
    --Find position for new score
    for i = 1, MAX_HIGHSCORE do
        if HIGHSCORES[i].score <= score then
            position = i
            break
        end
    end

    local temp_name = HIGHSCORES[position].name
    local temp_score = HIGHSCORES[position].score
    --Shift every position to the one below
    for j = MAX_HIGHSCORE, position+1,-1 do
        HIGHSCORES[j].name = HIGHSCORES[j-1].name
        HIGHSCORES[j].score = HIGHSCORES[j-1].score
    end

    --Update highscore table with new score and name
    HIGHSCORES[position].score = score
    HIGHSCORES[position].name = name

end

--HIGHSCORE BUTTON--

local up_arrow_func, down_arrow_func, confirm_arrow_func --Functions for arrows above and below displays, and confirm arrow
local _buttons_positions = {}

--[[3 individual circular displays, each containing a letter, and two arrow buttons above and below for changing the letter. On the right of the individual displays, an arrow for confirming]]--
Highscore_Button = Class{
    __includes = {ELEMENT, POS},
    init = function(self, _x, _y, _score, _pos)

        ELEMENT.init(self)
        POS.init(self, _x, _y)

        self.score = _score --Score player got
        self.position = _pos --Position of player score in the highscore table

        --Order of letters
        self.letters_table = {
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q',
        'R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8',
        '9', '*'}

        self.letters = {} --Letters in each individual display (value is position on letters_table)
        self.change_button_up = {} --Arrow buttons on top of the displays
        self.change_button_down = {} --Arrow buttons on bottom of the displays

        self.display_gap = 30 --Space between each individual display
        self.display_r = 50 --Radius of individual display

        self.arrow_gap = 15 --Gap between circular display and arrow buttons
        self.arrow_size = 50 --Size of equilateral triangle for arrow

        --Creating initial letters and change_buttons
        local sqrt3 = math.sqrt(3)
        for i=1,3 do
            local s = self
            s.letters[i] = 1

            --Center of current circular display
            local center_x = s.pos.x + s.display_r + (i-1)*(s.display_gap+2*s.display_r)
            local center_y = s.pos.y + s.display_r

            --Create up arrow
            local pos1 = Vector(center_x - s.arrow_size/2, center_y - s.display_r - s.arrow_gap) --Bottom left vertex
            local pos2 = Vector(center_x + s.arrow_size/2, center_y - s.display_r - s.arrow_gap) --Bottom right vertex
            local pos3 = Vector(center_x, center_y - s.display_r - s.arrow_gap - s.arrow_size*sqrt3/2) --Top vertex
            self.change_button_up[i] =  Highscore_Arrow(pos1, pos2, pos3, up_arrow_func, self, i, nil, true, "up_"..i)
            _buttons_positions["up_"..i] = self.change_button_up[i].center
            --Create down arrow
            pos1 = Vector(center_x - s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top left vertex
            pos2 = Vector(center_x + s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top right vertex
            pos3 = Vector(center_x, center_y + s.display_r + s.arrow_gap + s.arrow_size*sqrt3/2) --Bottom vertex
            self.change_button_down[i] =  Highscore_Arrow(pos1, pos2, pos3, down_arrow_func, self, i, nil, false,"down_"..i)
            _buttons_positions["down_"..i] = self.change_button_down[i].center
        end

        --Create confirm arrow
        local s = self
        pos1 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap, s.pos.y + (2*s.display_r - s.arrow_size)/2) --Top left vertex
        pos2 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap, s.pos.y + (2*s.display_r - s.arrow_size)/2 + s.arrow_size) --Bottom left vertex
        pos3 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap + s.arrow_size*sqrt3/2, s.pos.y + (2*s.display_r - s.arrow_size)/2 + s.arrow_size/2) --Right vertex
        self.confirm_button =  Highscore_Arrow(pos1, pos2, pos3, confirm_arrow_func, self, nil, true, nil, "center")
        _buttons_positions["center"] = self.confirm_button.center

        self.current_selected = "up_1" --current selected button

        self.type = "highscore_button"

    end

}

function Highscore_Button:draw()
    local but, dis_r, gap = self, self.display_r, self.display_gap

    --Draw the displays
    for i=0,2 do

        --Draw the letter
        local font = GUI_HIGHSCORE
        love.graphics.setFont(font)
        color = Color.black()
        Color.copy(color, UI_COLOR.color)
        color.l = 160
        Color.set(color)
        local letter = but.letters_table[but.letters[i+1]]
        love.graphics.print(letter, but.pos.x + dis_r + i*(gap+2*dis_r) - font:getWidth(letter)/2, but.pos.y + dis_r - font:getHeight(letter)/2)

        --Draw the up and down arrow
        but.change_button_up[i+1]:draw()
        but.change_button_down[i+1]:draw()
    end

    --Draw the confirm button
    but.confirm_button:draw()

end

--Call update functions of buttons
function Highscore_Button:update(dt)

    --Move selected button based on joystick hat or axis input
    if USING_JOYSTICK and CURRENT_JOYSTICK and self.current_selected then
      --First try to get hat input
      local _joystick_direction = Util.getHatDirection(CURRENT_JOYSTICK:getHat(1))
      if _joystick_direction:len() == 0 then
        --If there isn't a hat input, tries to get an axis input
        _joystick_direction = Vector(Util.getJoystickAxisValues(CURRENT_JOYSTICK, GENERIC_JOY_MAP.laxis_horizontal, GENERIC_JOY_MAP.laxis_vertical)):normalized()
      end
      if _joystick_direction:len() == 0 then
        _joystick_moved = false
      else
        if not _joystick_moved then
            self:changeSelectedButton(_joystick_direction)
        end
        --Set joystick as moved so it doesn't move to several buttons at once
        _joystick_moved = true
      end
    end


    for i = 1,3 do
        self.change_button_up[i]:update(dt)
        self.change_button_down[i]:update(dt)
    end
    self.confirm_button:update(dt)

end

--Check collision between mouse and arrow buttons
function Highscore_Button:mousepressed(x,y)
    local mousepos


    --Fix mouse position click to respective distance
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    mousepos = Vector(x, y)

    --Check collision with arrows buttons
    for i = 1,3 do
        --Top buttons
        local a = self.change_button_up[i]
        if a.center:dist(mousepos) <= a.col_radius then
            a.func(a, a.highscore_button)
            return
        end

        --Bottom buttons
        local a = self.change_button_down[i]
        if a.center:dist(mousepos) <= a.col_radius then
            a.func(a, a.highscore_button)
            return
        end
    end

    --Check collision with confirm button
    local a = self.confirm_button
    if a.center:dist(mousepos) <= a.col_radius then
        a.func(a, a.highscore_button)
        return
    end

end

function Highscore_Button:changeSelectedButton(direction)
    --First get list of valid buttons given the direction
    local cur_pos = _buttons_positions[self.current_selected]
    local range = math.pi/4
    local valid_buttons = {}
    for i,pos in pairs(_buttons_positions) do
      if i ~= self.current_selected then
          local vector = Vector(pos.x - cur_pos.x, pos.y - cur_pos.y):normalized()
          local angle = math.abs(direction:angleTo(vector))
          if angle > math.pi then angle = 2*math.pi - angle end
          if angle <= range then
            valid_buttons[i] = pos
          end
      end
    end

    --No valid buttons in that direction
    if Util.tableLen(valid_buttons) == 0 then return end

    --Find closest button
    local min_len = 9999999
    local target_button = nil
    for i, pos in pairs(valid_buttons) do
      local len = Vector(pos.x - cur_pos.x, pos.y - cur_pos.y):len()
      if len < min_len then
        min_len = len
        target_button = i
      end
    end

    self.current_selected = target_button
end

function Highscore_Button:joystickpressed(button)
    if button == GENERIC_JOY_MAP.confirm then
        --Check arrows buttons
        for i = 1,3 do
            --Top buttons
            local a = self.change_button_up[i]
            if self.current_selected == a.name then
                a.func(a, a.highscore_button)
                return
            end

            --Bottom buttons
            local a = self.change_button_down[i]
            if self.current_selected == a.name then
                a.func(a, a.highscore_button)
                return
            end
        end

        --Check confirm button
        local a = self.confirm_button
        if self.current_selected == a.name then
            a.func(a, a.highscore_button)
            return
        end
    end
end

--Correct the sign of the points given for collision
function sign (p1, p2, p3)
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

--Check if a point is inside a triangle
function pointInTriangle (pt, v1, v2, v3)
    local b1, b2, b3

    b1 = (sign(pt, v1, v2) < 0)
    b2 = (sign(pt, v2, v3) < 0)
    b3 = (sign(pt, v3, v1) < 0)

    return ((b1 == b2) and (b2 == b3));
end

--Triangle with a function for when its pressed
Highscore_Arrow = Class{
    __includes = {TRIANGLE},
    init = function(self, _pos1, _pos2, _pos3, _func, _highscore_button, _number, _confirm, _up, _name)
        TRIANGLE.init(self, _pos1, _pos2, _pos3, Color.purple(), nil, "line")

        self.center = Vector((_pos1.x + _pos2.x + _pos3.x)/3, (_pos1.y + _pos2.y + _pos3.y)/3) --Coordenates of center of the arrow button
        --Fixes center of collision circle
        if not _confirm and _up then
            self.center.y = self.center.y - 5
        elseif not _confirm and not _up then
            self.center.y = self.center.y + 5
        elseif _confirm then
            self.center.x = self.center.x + 5
        end
        self.col_radius = 40 --Radius of collision shape of this button
        self.effect_radius = 0 --Radisu of effect that increases when mouse is over button
        self.effect_growth_speed = 500

        self.confirm = _confirm or false --If this arrow is a confirm arrow
        self.func = _func --Function when the triangle is pressed
        self.highscore_button = _highscore_button --Reference to highscore button
        self.number = _number --Number of correspondent display
        self.name = _name --Identification of this button

        self.type = "highscore_arrow"
    end

}

function Highscore_Arrow:draw()
    local t = self

    --Draws the circle effect for mouseover
    love.graphics.setLineWidth(4)
    local color = Color.black()
    Color.copy(color, UI_COLOR.color)
    if not t.confirm then
        color.h = (color.h+128)%256
    end
    Color.set(color)
    love.graphics.circle("line", t.center.x, t.center.y, t.effect_radius)

    --Draws the triangle
    local color = Color.black()
    Color.copy(color, UI_COLOR.color)
    if t.confirm then
        color.h = (color.h+128)%256
    end
    color.l = color.l *.7
    Color.set(color)

    love.graphics.setLineWidth(8)
    if not t.confirm then
        love.graphics.line(t.p1.x, t.p1.y, t.p3.x, t.p3.y, t.p2.x, t.p2.y)
    else
        love.graphics.line(t.p1.x, t.p1.y, t.p3.x, t.p3.y, t.p2.x, t.p2.y)
    end

end

--Increase effect radius of button if moosue is on top of it
function Highscore_Arrow:update(dt)
    local b, x, y, mousepos

    b = self

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()
    w, h = FreeRes.windowDistance()
    scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    mousepos = Vector(x, y)

    --If mouse is colliding with button collision radius, increase effect radius
    if b.center:dist(mousepos) <= b.col_radius or (USING_JOYSTICK and b.highscore_button.current_selected == b.name) then
        b.highscore_button.current_selected = b.name
        if b.effect_radius < b.col_radius then
            b.effect_radius = b.effect_radius + b.effect_growth_speed*dt
            if b.effect_radius > b.col_radius then b.effect_radius = b.col_radius end
        end
    else
        if b.effect_radius > 0 then
            b.effect_radius = b.effect_radius - b.effect_growth_speed*dt
            if b.effect_radius < 0 then b.effect_radius = 0 end
        end
    end

end

--HIGHCORE ARROW BUTTON FUNCTIONS--

--Change the letter of correspondent display to the next
function up_arrow_func(arrow, hs_button)

    hs_button.letters[arrow.number] = (hs_button.letters[arrow.number] % (#hs_button.letters_table)) + 1

end

--Change the letter of correspondent display to the previous
function down_arrow_func(arrow, hs_button)

    hs_button.letters[arrow.number] = (hs_button.letters[arrow.number] - 2) % (#hs_button.letters_table) + 1

end

--Confirm the current name and enter it on the highscore table
function confirm_arrow_func(arrow, hs_button)
    local name = ""

    --Get name of player
    for i=1,3 do
        name = name .. hs_button.letters_table[hs_button.letters[i]]
    end
    --Enter highscore
    HS.addHighscore(name, hs_button.score)

    --Delete highscore button and text on screen
    local text
    hs_button.death = true
    text = Util.findId("highscore_text")
    if text then text.death = true end
    text = Util.findId("highscore_text2")
    if text then text.death = true end

    --Draw highscores on the screen
    hs.draw(hs_button.position, 0, -70)

end


--HIGHSCORE BUTTON UTILITY FUNCTION--

function hs.createHighscoreButton(x, y, score, pos)
    local hsb = Highscore_Button(x, y, score, pos)
    hsb:addElement(DRAW_TABLE.GUI, nil, "highscore_button")

    return hsb
end


--Return functions
return hs
