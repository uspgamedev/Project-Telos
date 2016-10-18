local FreeRes = require "FreeRes"
local BG = require "classes.bg"
local Hsl = require "classes.color.hsl"
local UI = require "classes.ui"
local Txt = require "classes.text"
--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--
    PIXEL = love.graphics.newImage("assets/images/pixel.png") -- Pixel for shaders

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status
    BUTTON_LOCK = false --Blocks buttons to be pressed
    SWITCH = nil --Which gamestate to switch next

    WINDOW_WIDTH = love.graphics.getWidth() --Current width of the game window
    WINDOW_HEIGHT = love.graphics.getHeight() --Current height of the game window
    ORIGINAL_WINDOW_WIDTH = 1000 --Default width of the game window
    ORIGINAL_WINDOW_HEIGHT = 750 --Default height of the game window
    PREVIOUS_WINDOW_WIDTH = love.graphics.getWidth() --Window width before fullscreen
    PREVIOUS_WINDOW_HEIGHT = love.graphics.getHeight() --Window height before fullscreen

    SCREEN_CANVAS = nil --Screen canvas that can be draw or apllied effects
    USE_CANVAS = false --If game should draw the SCREEN_CANVAS

    BLUR_CANVAS_1 = nil --First canvas for blur effect
    BLUR_CANVAS_2 = nil --Second canvas for blur effect
    USE_BLUR_CANVAS = false --If game should draw the BLUR_CANVAS

    FOCUS = true --If game screen is focused
    SWITCH = nil --What state to go next

    MAX_PARTICLES = 300 --Max number of particles effects on screen

    COROUTINE = nil --Current coroutine
    COROUTINE_HANDLE = nil --Handle timer for current coroutine
    INDICATOR_DEFAULT = 1.5 --Indicator timer default

    SHAKE_HANDLE = nil --Handle for shake effect

    SLOWMO = false --If (most) game elements will move in slow-mo
    SLOWMO_M = .5 --Slowmo multiplier effect

    --TIMERS--
    LEVEL_TIMER = Timer.new()  --General Timer
    FX_TIMER = Timer.new() --Effects Timer (for tweening mostly)
    COLOR_TIMER = Timer.new() --Color Effects Timer
    AUDIO_TIMER = Timer.new() --Audio effects

    --CHEATS--
    GODMODE = false

    --INITIALIZING TABLES--
    --Drawing Tables
    DRAW_TABLE = {
    BG = {}, --Background (bottom layer, first to draw)
    L1 = {}, --Layer 1
    L2 = {}, --Layer 2
    L3 = {}, --Layer 3
    L4 = {}, --Layer 4
    BOSS = {}, --Bosses
    GAME_GUI = {}, --Game User Interface
    L5 = {}, --Layer 5
    GUI = {}  --Graphic User Interface (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)
    INDICATOR_HANDLES = {} --Table holding handles for enemies indicators

    --Functions receives two positions (p1 and p2) and a value, and returns a value
    DEATH_FUNCS = {
        function(p1, p2, value) return 8*value end,
        function(p1, p2, value) return 300*(math.cos(p1:dist2(p2)*value*3)) end,
        function(p1, p2, value)  return 500*math.cos(math.deg(math.atan(p1:dist(p2) *.2*value))) end,
        function(p1, p2, value) return 9*(value^1.75)/p1:dist(p2) end,
        function(p1, p2, value) return 18*(value^2 - p1:dist2(p2))/value end,
    }
    --Contains the death timer handles
    DEATH_HANDLES = {}

    --WINDOW CONFIG--
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true, minwidth = 800, minheight = 600})
    FreeRes.setScreen()

    --FONT CONFIG--
    GUI_GAME_TITLE = love.graphics.newFont("assets/fonts/Nevis.ttf", 90)
    GUI_BOSS_TITLE = love.graphics.newFont("assets/fonts/Nevis.ttf", 60)
    GUI_BIG = love.graphics.newFont("assets/fonts/vanadine_bold.ttf", 60)
    GUI_MEDPLUS = love.graphics.newFont("assets/fonts/Nevis.ttf", 30)
    GUI_MED = love.graphics.newFont("assets/fonts/Nevis.ttf", 20)

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--

    --Default Smooth Circle Shader
    Smooth_Circle_Shader = ([[
      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        vec2 center = vec2(0.5,0.5);
        pixel.a = 1 - smoothstep(.5 - 1/%f, .5, distance(center, texture_coords));
        return pixel * color;
      }
    ]])

    --Table containing smooth circle shaders created
    SMOOTH_CIRCLE_TABLE = {}


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

    Horizontal_Blur_Shader = ([[
        extern number win_width; //1 / (screen width)
		const float kernel[5] = float[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);
		vec4 effect(vec4 color, sampler2D tex, vec2 tex_coords, vec2 pos) {
			color = texture2D(tex, tex_coords) * kernel[0];
			for(int i = 1; i < 5; i++) {
				color += texture2D(tex, vec2(tex_coords.x + 2*i * win_width, tex_coords.y)) * kernel[i];
				color += texture2D(tex, vec2(tex_coords.x - 2*i * win_width, tex_coords.y)) * kernel[i];
			}
			return color;
		}
	]]):format(1 / love.graphics.getWidth(), 1 / love.graphics.getWidth())
	Horizontal_Blur_Shader = love.graphics.newShader(Horizontal_Blur_Shader)

	Vertical_Blur_Shader = love.graphics.newShader[[
        extern number win_height; //1 / (screen height)
		const float kernel[5] = float[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);
		vec4 effect(vec4 color, sampler2D tex, vec2 tex_coords, vec2 pos) {
			color = texture2D(tex, tex_coords) * kernel[0];
			for(int i = 1; i < 5; i++) {
				color += texture2D(tex, vec2(tex_coords.x, tex_coords.y + 2*i * win_height)) * kernel[i];
				color += texture2D(tex, vec2(tex_coords.x, tex_coords.y - 2*i * win_height)) * kernel[i];
			}
			return color;
		}
	]]

    --AUDIO--
    SOUNDTRACK = {}
    SOUNDTRACK["current"] = nil --Current soudntrack playing
    SOUNDTRACK["next"] = nil  --Next soundtrack to play (for cross-fading)
    SFX = {} --Table with all sound effects playing
    BGM_VOLUME_LEVEL = 1 --Volume of BGM
    SFX_VOLUME_MULT = 1 --Volume multiplier for SFX
    --Useful handles for audio manipulation
    FADE_IN_HANDLE = nil
    FADE_OUT_HANDLE = nil
    AUDIO_TIMER_HANDLE = nil
    --Tracks
    BGM_MENU = love.audio.newSource("assets/bgm/Flying Carrots 2.mp3")
    BGM_LEVEL_1 = love.audio.newSource("assets/bgm/Limitless.mp3")
    BGM_LEVEL_2 = love.audio.newSource("assets/bgm/Through Hiperboles.ogg")
    --SFX
    SFX_PSYCHOBALL_SHOT = love.audio.newSource("assets/sfx/general_sfxs/snd_psychoball_shot.mp3")
    SFX_PSYCHOBALL_SHOT:setVolume(.2*SFX_VOLUME_MULT)
    SFX_PSYCHOBALL_DIES = love.audio.newSource("assets/sfx/general_sfxs/snd_psychoball_dies.mp3")
    SFX_PSYCHOBALL_DIES:setVolume(1*SFX_VOLUME_MULT)
    SFX_HIT_SIMPLE = love.audio.newSource("assets/sfx/general_sfxs/snd_hit_simple_ball.mp3")
    SFX_HIT_SIMPLE:setVolume(.5*SFX_VOLUME_MULT)
    SFX_HIT_DOUBLE = love.audio.newSource("assets/sfx/general_sfxs/snd_hit_double_ball.mp3")
    SFX_HIT_DOUBLE:setVolume(.5*SFX_VOLUME_MULT)
    SFX_GENERIC_BUTTON = love.audio.newSource ("assets/sfx/general_sfxs/snd_generic_button.mp3")
    SFX_GENERIC_BUTTON:setVolume(.5*SFX_VOLUME_MULT)
    SFX_BACK_BUTTON = love.audio.newSource ("assets/sfx/general_sfxs/snd_back_button.mp3")
    SFX_BACK_BUTTON:setVolume(.5*SFX_VOLUME_MULT)
    SFX_PLAY_BUTTON = love.audio.newSource("assets/sfx/general_sfxs/snd_button_play.mp3")
    SFX_PLAY_BUTTON:setVolume(.3*SFX_VOLUME_MULT)

    --Start UI color transition
    UI_COLOR = UI.create_color()

    --Background start
    BG.create()

    --FPS Counter
    Txt.create_gui(ORIGINAL_WINDOW_WIDTH - 100, 10, "FPS: ", GUI_MED, love.timer.getFPS(), "right", GUI_MED, "fps_counter")

    --SHADERS SETUP
    print("Setting up shaders")
    Horizontal_Blur_Shader:send("win_width", 1/WINDOW_WIDTH)
    Vertical_Blur_Shader:send("win_height", 1/WINDOW_HEIGHT)
    --Create some pre-made smooth circle
    for size = 36, 49 do
        SMOOTH_CIRCLE_TABLE[size] = love.graphics.newShader(Smooth_Circle_Shader:format(size))
    end
    SMOOTH_CIRCLE_TABLE[6] = love.graphics.newShader(Smooth_Circle_Shader:format(10))
    SMOOTH_CIRCLE_TABLE[10] = love.graphics.newShader(Smooth_Circle_Shader:format(10))
    SMOOTH_CIRCLE_TABLE[12] = love.graphics.newShader(Smooth_Circle_Shader:format(12))
    SMOOTH_CIRCLE_TABLE[60] = love.graphics.newShader(Smooth_Circle_Shader:format(60))
    print("Finished setting up shaders")

end

--Return functions
return setup
