local FreeRes = require "FreeRes"
--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--
    --PIXEL = love.graphics.newImage("assets/pixel.png") --Example image

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status
    BUTTON_LOCK = false --Blocks buttons to be pressed
    SWITCH = nil --Which gamestate to switch next

    WINDOW_WIDTH = love.graphics.getWidth() --Current width of the game window
    WINDOW_HEIGHT = love.graphics.getHeight() --Current height of the game window
    ORIGINAL_WINDOW_WIDTH = love.graphics.getWidth() --Default width of the game window
    ORIGINAL_WINDOW_HEIGHT = love.graphics.getHeight() --Default height of the game window
    PREVIOUS_WINDOW_WIDTH = love.graphics.getWidth() --Window width before fullscreen
    PREVIOUS_WINDOW_HEIGHT = love.graphics.getHeight() --Window height before fullscreen

    SWITCH = nil --What state to go next

    COROUTINE = nil --Current coroutine
    COROUTINE_HANDLE = nil --Handle timer for current coroutine

    --TIMERS--
    GAME_TIMER = Timer.new()  --General Timer
    FX_TIMER = Timer.new() --Effects Timer (for tweening mostly)

    --INITIALIZING TABLES--
    --Drawing Tables
    DRAW_TABLE = {
    BG = {}, --Layer 1 (bottom layer, first to draw)
    L2 = {}, --Layer 2
    L3 = {}, --Layer 3
    L4 = {}, --Layer 4
    L5 = {}, --Layer 5
    GUI = {}  --Layer 6 (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)

    --WINDOW CONFIG--
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true, minwidth = 800, minheight = 600})
    FreeRes.setScreen(1)

    --FONT CONFIG--
    GUI_BIG = love.graphics.newFont("assets/fonts/vanadine_bold.ttf", 60)
    GUI_MED = love.graphics.newFont("assets/fonts/Nevis.ttf", 20)

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--
    --Example shader for drawing glow effect
    Glow_Shader = love.graphics.newShader[[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );
            vec2 center = vec2(0.5,0.5);
            number grad = 0.7;
            number dist = distance(center, texture_coords);
            if(dist <= 0.5){
                color.a = color.a * 1-(dist/0.5);
                color.r = color.r * grad;
                color.g = color.g * grad;
                color.b = color.b * grad;
                return pixel*color;
            }
        }
    ]]
end

--Return functions
return setup
