require "classes.primitive"
local Color = require "classes.color.color"
local Util = require "util"
--INDICATOR AIM CLASS--
--[[Line representing where an indicator is pointing]]

local aim_functions = {}

---------------
--INDICATOR AIM--
---------------

--Line that aims in a direction
Indicator_Aim = Class{
    __includes = {ELEMENT, CLR},
    init = function(self, _ind, _c, _game_win_idx)

        ELEMENT.init(self) --Set atributes
        CLR.init(self, _c)

        self.indicator = _ind
        self.pos = Vector(_ind.center.x, _ind.center.y) --Center of aim
        self.line_width = 3 --Thickness of aim line
        self.alpha = 0 --Alpha of aim
        self.game_win_idx = _game_win_idx or 1 --Which game window this indicator is from

        self.tp = "indicator_aim" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Indicator_Aim:draw()
    local aim, color

    aim = self
    color = aim.color
    color.a = aim.alpha
    p = Util.findId("psycho")

    --Draw the line
    Color.set(color)
    aim.pos.x = self.indicator.center.x
    aim.pos.y = self.indicator.center.y
    local win = WINM.getWin(self.game_win_idx)
    love.graphics.setLineWidth(aim.line_width)
    love.graphics.line(aim.pos.x + win.x, aim.pos.y + win.y, p.pos.x + win.x, p.pos.y + win.y)

end

--UTILITY FUNCTIONS--

--Create a regular aim with and st
function aim_functions.create_indicator(indicator, c, game_win_idx, st)
    local aim, h1, h2

    st = st or "indicator_aim" --subtype

    aim = Indicator_Aim(indicator, c, game_win_idx)

    aim:addElement(DRAW_TABLE.L2, st)

    --Fade in the aim
    h1 = LEVEL_TIMER:after(2,
        function()
            LEVEL_TIMER:tween(1, aim, {alpha = 30}, 'in-linear')
        end
    )
    --Fade out the aim
    h2 = LEVEL_TIMER:after(7,
        function()
            LEVEL_TIMER:tween(1, aim, {alpha = 0}, 'in-linear',
                function()
                    aim.death = true
                end
            )
        end
    )

    return aim, h1, h2
end

--Return functions
return aim_functions
