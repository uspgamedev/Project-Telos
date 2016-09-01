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
require "formation"
require "classes.enemies.simple_ball"

--other
require "classes.primitive"
require "classes.psycho"
require "classes.bullet"
require "classes.text"
Button = require "classes.button"

--MY MODULES
require "util"
require "draw"
local Setup = require "setup"


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
