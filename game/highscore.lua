local Color = require "classes.color.color"
local Hsl = require "classes.color.hsl"

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

local up_arrow_func, down_arrow_func --Functions for arrows above and below displays

--[[3 individual circular displays, each containing a letter, and two arrow buttons above and below for changing the letter. On the right of the individual displays, an arrow for confirming]]--
Highscore_Button = Class{
    __includes = {ELEMENT, POS},
    init = function(self, _x, _y)

        ELEMENT.init(self)
        POS.init(self, _x, _y)

        --Order of letters
        self.letters_table = {
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q',
        'R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8',
        '9','*'}

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
            self.change_button_up[i] =  Highscore_Arrow(pos1, pos2, pos3, up_arrow_func)

            --Create down arrow
            pos1 = Vector(center_x - s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top left vertex
            pos2 = Vector(center_x + s.arrow_size/2, center_y + s.display_r + s.arrow_gap) --Top right vertex
            pos3 = Vector(center_x, center_y + s.display_r + s.arrow_gap + s.arrow_size*sqrt3/2) --Bottom vertex
            self.change_button_down[i] =  Highscore_Arrow(pos1, pos2, pos3, down_arrow_func)

        end

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

end

--Triangle with a function for when its pressed
Highscore_Arrow = Class{
    __includes = {TRIANGLE},
    init = function(self, _pos1, _pos2, _pos3, _func)
        TRIANGLE.init(self, _pos1, _pos2, _pos3, Color.purple(), nil, "line")

        self.func = _func --Function when the triangle is pressed

        self.type = "highscore_arrow"
    end

}


--HIGHSCORE BUTTON UTILITY FUNCTION--

function hs.createHighscoreButton(x,y)
    local b

    b = Highscore_Button(x,y)
    b:addElement(DRAW_TABLE.L4, nil, "highscore_button")

    return but
end


--Return functions
return hs
