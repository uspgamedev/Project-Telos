--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"


--CLASSES--

--color
require "classes.color.color"
require "classes.color.rgb"
require "classes.color.hsl"

--enemies
require "classes.enemies.simple_ball"
require "classes.enemies.double_ball"

--bosses
require "classes.bosses.boss1"

--levels

require "levels.level1"
require "levels.level2"

--other
require "classes.primitive"
require "classes.particle"
require "classes.psycho"
require "classes.bullet"
require "classes.text"
require "classes.bg"
require "classes.circle_effect"
require "classes.ui"
require "classes.psycho_aim"
require "classes.indicator"
require "classes.ultrablast"
Button = require "classes.button"

--MY MODULES
local Util = require "util"
require "draw"
require "audio"
require "formation"
require "level_manager"
FX = require "fx"
local Setup = require "setup"

--IMPORTED MODULES
local FreeRes = require "FreeRes"



--GAMESTATES
GS = {
MENU     = require "gamestates.menu",     --Menu Gamestate
GAME     = require "gamestates.game",     --Game Gamestate
PAUSE    = require "gamestates.pause",    --Pause Gamestate
GAMEOVER = require "gamestates.gameover"  --Gameover Gamestate
}

--LEVELS
require "levels.level1"

function love.load()

    Setup.config() --Configure your game

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well
    Gamestate.switch(GS.MENU) --Jump to the inicial state

end

--Called when user resizes the screen
function love.resize(w, h)

    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    FreeRes.setScreen(1)

end

--Called when screen loses or receives focus
function love.focus(f)
    FOCUS = f
end

--Used to draw canvas (fixes screen blinking when changing gamestates)
function love.draw()

    if USE_CANVAS and SCREEN_CANVAS then
        love.graphics.setColor(255, 255, 255, 255)
        -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(SCREEN_CANVAS)
        love.graphics.setBlendMode("alpha")
    end

end

--Used for debugging
function love.update()

end
