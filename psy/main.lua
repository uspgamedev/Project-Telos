--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"

 require "slam"

--CLASSES--

--color
require "classes.color.color"
require "classes.color.rgb"
require "classes.color.hsl"

--enemies
SB = require "classes.enemies.simple_ball"
DB = require "classes.enemies.double_ball"
GrB = require "classes.enemies.grey_ball"
GlB = require "classes.enemies.glitch_ball"
Trt = require "classes.enemies.turret"
Snk = require "classes.enemies.snake"
Cge = require "classes.enemies.cage"

--bosses
require "classes.bosses.boss1"
require "classes.bosses.boss2"

--levels
require "levels.tutorial"
require "levels.level1"
require "levels.level2"
require "levels.level3"

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
require "classes.ultrablast_counter"
require "classes.life_counter"
require "classes.score_counter"
require "classes.tutorial_icon"
require "classes.logo"
Button = require "classes.button"

--MY MODULES
local Util = require "util"
require "draw"
Audio = require "audio"
require "formation"
require "level_manager"
Controls = require "controls"
FX = require "fx"
FM = require "file_manager"
HS = require "highscore"
local Setup = require "setup"

--IMPORTED MODULES
local ResManager = require "res_manager"
require "Tserial"

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

    local callbacks = {'draw', 'errhand', 'update'}
    for c in pairs(love.handlers) do
        if c ~= 'mousepressed' and c ~= 'mousereleased' and c ~= 'mousemoved' then
            table.insert(callbacks, c)
        end
    end
    -- mousereleased, mousemoved and mousepressed are called manually
    Gamestate.registerEvents(callbacks) --Overwrites love callbacks to call Gamestate as well

    Gamestate.switch(GS.MENU) --Jump to the inicial state

end

--Called when user resizes the screen
function love.resize(w, h)
    ResManager.adjustWindow(w, h)

    --These values may be invalidated on a resize
    Horizontal_Blur_Shader:send("win_width", 1/WINDOW_WIDTH)
    Vertical_Blur_Shader:send("win_height", 1/WINDOW_HEIGHT)
end

--Called when screen loses or receives focus
function love.focus(f)
    FOCUS = f
end

--Function called when love is quitting
function love.quit()
    local sucess

    print("Exiting the game. Please hold while we save all the balls.")

    --Save all status on the files
    sucess = FM.save()
    if not sucess then
        print("Couldn't update your save in the savefile. Aborting the exit of the game. You can press f4 to forcefully close the game without trying to save.")
        return false
    end

    print("Balls saved. Thanks for psycho-balling")
    print("---------------------------")

    return true
end

------------------------------------

--Update status of player using joystick or not
function love.mousemoved(x, y, dx, dy, ...)
  USING_JOYSTICK = false
  x, y = love.mouse.getPosition() --fixed (ResManager)
  dx, dy = dx * ResManager.scale(), dy * ResManager.scale()
  Gamestate.mousemoved(x, y, dx, dy, ...)
end

function love.mousepressed(x, y, ...)
  x, y = love.mouse.getPosition() --fixed (ResManager)
  Gamestate.mousepressed(x, y, ...)
end

function love.mousereleased(x, y, ...)
  x, y = love.mouse.getPosition() --fixed (ResManager)
  Gamestate.mousereleased(x, y, ...)
end

function love.keypressed(...)
  USING_JOYSTICK = false
end

function love.joystickaxis(joystick, ...)
  USING_JOYSTICK = true
  CURRENT_JOYSTICK = joystick
end

function love.joystickpressed(joystick, ...)
  USING_JOYSTICK = true
  CURRENT_JOYSTICK = joystick
end

function love.joystickhat(joystick, ...)
  USING_JOYSTICK = true
  CURRENT_JOYSTICK = joystick
end

function love.joystickadded(joystick)
  USING_JOYSTICK = true
  CURRENT_JOYSTICK = joystick
end

function love.joystickremoved(joystick)
  if joystick == CURRENT_JOYSTICK then
    CURRENT_JOYSTICK = nil
    USING_JOYSTICK = false
  end
end

------------------------------
--Used for debugging
function love.update()
end
