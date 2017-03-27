local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"
local Util = require "util"
local Txt = require "classes.text"

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

--Draw all highscores in the middle of the screen
function hs.draw()

    --Draw header
    Txt.create_gui(180, 100, "HIGHSCORES", GUI_HIGHSCORE, nil, "format", nil, "highscore_title", "center", ORIGINAL_WINDOW_WIDTH/1.5)
    Txt.create_gui(180, 110, "__________", GUI_HIGHSCORE, nil, "format", nil, "highscore_title_underscore", "center", ORIGINAL_WINDOW_WIDTH/1.5)

    --Draw highscores
    for i = 1, MAX_HIGHSCORE do
        --Draw numbers
        Txt.create_gui(235, 140+i*80, i, GUI_BOSS_TITLE, nil, nil, nil, "highscore_number_"..i)
        --Draw numberdot
        Txt.create_gui(275, 140+i*80, ".", GUI_BOSS_TITLE, nil, nil, nil, "highscore_dot"..i)
        --Draw player name
        Txt.create_gui(400, 140+i*80, HIGHSCORES[i].name, GUI_BOSS_TITLE, nil, nil, nil, "highscore_name"..i)
        --Draw player score
        Txt.create_gui(660, 140+i*80, HIGHSCORES[i].score, GUI_BOSS_TITLE, nil, nil, nil, "highscore_score"..i)
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

--[[3 individual circular displays, each containing a letter, and two arrow buttons above and below for changing the letter. On the right of the individual displays, an arrow for confirming]]--
Highscore_Button = Class{
    __includes = {ELEMENT, POS},
    init = function(self, _x, _y, _score)

        ELEMENT.init(self)
        POS.init(self, _x, _y)

        self.score = _score --Score player got

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
            self.change_button_up[i] =  Highscore_Arrow(pos1, pos2, pos3, up_arrow_func, self, i)

            --Create down arrow
            pos1 = Vector(center_x - s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top left vertex
            pos2 = Vector(center_x + s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top right vertex
            pos3 = Vector(center_x, center_y + s.display_r + s.arrow_gap + s.arrow_size*sqrt3/2) --Bottom vertex
            self.change_button_down[i] =  Highscore_Arrow(pos1, pos2, pos3, down_arrow_func, self, i)

        end

        --Create confirm arrow
        local s = self
        pos1 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap, s.pos.y + (2*s.display_r - s.arrow_size)/2) --Top left vertex
        pos2 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap, s.pos.y + (2*s.display_r - s.arrow_size)/2 + s.arrow_size) --Bottom left vertex
        pos3 = Vector(s.pos.x + 6*s.display_r + 2*s.display_gap + s.arrow_gap + s.arrow_size*sqrt3/2, s.pos.y + (2*s.display_r - s.arrow_size)/2 + s.arrow_size/2) --Right vertex
        self.confirm_button =  Highscore_Arrow(pos1, pos2, pos3, confirm_arrow_func, self)

        self.type = "highscore_button"
    end

}

function Highscore_Button:draw()
    local but, dis_r, gap = self, self.display_r, self.display_gap

    --Draw the displays
    for i=0,2 do

        --Draw the display circle
        Color.set(HSL(Hsl.stdv(297,81,74,100)))
        love.graphics.circle("fill", but.pos.x + dis_r + i*(gap+2*dis_r), but.pos.y + dis_r, dis_r)
        Color.set(Color.purple())
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", but.pos.x + dis_r + i*(gap+2*dis_r), but.pos.y + dis_r, dis_r)

        --Draw the letter
        local font = GUI_HIGHSCORE
        love.graphics.setFont(font)
        Color.set(Color.black())
        local letter = but.letters_table[but.letters[i+1]]
        love.graphics.print(letter, but.pos.x + dis_r + i*(gap+2*dis_r) - font:getWidth(letter)/2, but.pos.y + dis_r - font:getHeight(letter)/2)

        --Draw the up and down arrow
        but.change_button_up[i+1]:draw()
        but.change_button_down[i+1]:draw()
    end

    --Draw the confirm button
    but.confirm_button:draw()

end

--Auxiliary functions for checking collision with mouse click
local sign
local pointInTriangle

--Check collision between mouse and arrow buttons
function Highscore_Button:mousepressed(x,y)
    local point = Vector(x,y)

    --Check collision with arrows buttons
    for i = 1,3 do
        --Top buttons
        local a = self.change_button_up[i]
        if pointInTriangle(point, a.p1, a.p2, a.p3) then
            a.func(a, a.highscore_button)
            return
        end

        --Bottom buttons
        local a = self.change_button_down[i]
        if pointInTriangle(point, a.p1, a.p2, a.p3) then
            a.func(a, a.highscore_button)
            return
        end
    end

    --Check collision with confirm button
    local a = self.confirm_button
    if pointInTriangle(point, a.p1, a.p2, a.p3) then
        a.func(a, a.highscore_button)
        return
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
    init = function(self, _pos1, _pos2, _pos3, _func, _highscore_button, _number)
        TRIANGLE.init(self, _pos1, _pos2, _pos3, Color.purple(), nil, "line")

        self.func = _func --Function when the triangle is pressed
        self.highscore_button = _highscore_button --Reference to highscore button
        self.number = _number --Number of correspondent display

        self.type = "highscore_arrow"
    end

}

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

    --Create regular gameover buttons
    local func
    --Restart button
    func = function() SWITCH = "GAME"; CONTINUE = false end
    Button.create_inv_gui(140, 650, func, "(r)estart", GUI_MED, "start a new game", GUI_MEDLESS, "gameover_gui")

    if CONTINUE then

        --Continue button
        func = function() SWITCH = "GAME" end
        Button.create_inv_gui(340, 650, func, "(c)ontinue", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "gameover_gui")

    end

    --Back to menu button
    func = function() SWITCH = "MENU" end
    Button.create_inv_gui(540, 650, func, "(b)ack to menu", GUI_MED, "reset score, lives and progress on this level", GUI_MEDLESS, "gameover_gui")

    --Unlock buttons shortkeys
    GAMEOVER_BUTTONS_LOCK = false

    --Draw highscores on the screen
    hs.draw()

end


--HIGHSCORE BUTTON UTILITY FUNCTION--

function hs.createHighscoreButton(x, y, score)
    local b

    b = Highscore_Button(x, y, score)
    b:addElement(DRAW_TABLE.GUI, nil, "highscore_button")

    return but
end


--Return functions
return hs
