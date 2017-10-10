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
    local args
    --LOAD/SAVE
    SAVE_VERSION = 1.1 --Current save version
    args = FM.load() --Load from savefile (or create one if needed)


    --IMAGES--
    PIXEL = love.graphics.newImage("assets/images/pixel.png") -- Pixel for shaders

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )
    math.random = love.math.random --Override lua random function for love2d random function

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status
    BUTTON_LOCK = false --Blocks buttons to be pressed
    SWITCH = nil --Which gamestate to switch next

    FIRST_TIME = args["first_time"] --If its the first time the player is playing (for tutorial)
    CONTINUE = args["continue"] --If player is in the middle of a run

    HIGHSCORES = args["highscores"] --Highscores
    MAX_HIGHSCORE = 5 --Number of scores stored in the highscore table
    HIGHSCORE_HIGHLIGHT_EFFECT_HANDLE = nil --Handle for tween effect applied on highscore text (when a position is highlighed)

    GAMEOVER_BUTTONS_LOCK = false --If player can press or activate the gameover buttons
    PSYCHO_SCORE = 0 --Psycho score

    TUTORIAL = false --If the game gamestate should play the tutorial

    MAX_ULTRABLAST = 3 --Max number of ultrablasts psycho has

    WINDOW_WIDTH = love.graphics.getWidth() --Current width of the game window
    WINDOW_HEIGHT = love.graphics.getHeight() --Current height of the game window
    ORIGINAL_WINDOW_WIDTH = 1000 --Default width of the game window
    ORIGINAL_WINDOW_HEIGHT = 750 --Default height of the game window
    PREVIOUS_WINDOW_WIDTH = love.graphics.getWidth() --Window width before fullscreen
    PREVIOUS_WINDOW_HEIGHT = love.graphics.getHeight() --Window height before fullscreen

    --Game screen params
    TOP_LEFT_CORNER = Vector(0,0)
    BOTTOM_RIGHT_CORNER = Vector(ORIGINAL_WINDOW_WIDTH, ORIGINAL_WINDOW_HEIGHT)

    SCREEN_CANVAS = nil --Screen canvas that can be draw or apllied effects
    USE_CANVAS = false --If game should draw the SCREEN_CANVAS

    BLUR_CANVAS_1 = nil --First canvas for blur effect
    BLUR_CANVAS_2 = nil --Second canvas for blur effect
    USE_BLUR_CANVAS = false --If game should draw the BLUR_CANVAS

    FOCUS = true --If game screen is focused
    SWITCH = nil --What state to go next

    MAX_PARTICLES = 300 --Max number of particles effects on screen (actual number of particles can be greater when creating "important particles", that will be added despite the max_particle limit)

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
    BG  = {}, --Background (bottom layer, first to draw)
    L1  = {}, --Layer 1
    L2  = {}, --Layer 2
    L3  = {}, --Layer 3
    L4  = {}, --Layer 4
    L4u = {}, --Layer 4 upper
    BOSS = {}, --Bosses
    BOSSu = {}, --Bosses upper
    GAME_GUI = {}, --Game User Interface
    L5  = {}, --Layer 5
    L5u = {}, --Layer 5 upper
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
    GUI_HIGHSCORE = love.graphics.newFont("assets/fonts/Nevis.ttf", 80)
    GUI_LIFE_COUNTER = love.graphics.newFont("assets/fonts/Nevis.ttf", 40)
    GUI_SCORE_COUNTER = love.graphics.newFont("assets/fonts/Nevis.ttf", 50)
    GUI_LIFE_COUNTER_X = love.graphics.newFont("assets/fonts/Nevis.ttf", 35)
    GUI_BOSS_TITLE = love.graphics.newFont("assets/fonts/Nevis.ttf", 60)
    GUI_BIG = love.graphics.newFont("assets/fonts/vanadine_bold.ttf", 60)
    GUI_BIGLESS = love.graphics.newFont("assets/fonts/vanadine_bold.ttf", 45)
    GUI_BIGLESSLESS = love.graphics.newFont("assets/fonts/vanadine_bold.ttf", 30)
    GUI_MEDPLUSPLUS = love.graphics.newFont("assets/fonts/Nevis.ttf", 35)
    GUI_MEDPLUS = love.graphics.newFont("assets/fonts/Nevis.ttf", 30)
    GUI_MEDMED = love.graphics.newFont("assets/fonts/Nevis.ttf", 25)
    GUI_MED = love.graphics.newFont("assets/fonts/Nevis.ttf", 20)
    GUI_MEDLESS = love.graphics.newFont("assets/fonts/Nevis.ttf", 15)

    --CAMERA--
    CAM = Camera(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2) --Set camera position to center of screen
    MENU_CAM = Camera(ORIGINAL_WINDOW_WIDTH/2, ORIGINAL_WINDOW_HEIGHT/2) --Set camera position to center of screen, camera used for menu transitions

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

    --Default Smooth Ring Shader
    Smooth_Ring_Shader = ([[
      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        vec2 center = vec2(0.5,0.5);
        number size = %f;
        number inner_radius = %f;
        number x = distance(center, texture_coords);
        if (x >= inner_radius/size) {
          pixel.a = 1 - smoothstep(.5 - 1/size, .5, x);
        }
        else
        {
          pixel.a = smoothstep(inner_radius/size - 1/size, inner_radius/size, x);
        }

        return pixel * color;
      }
    ]])

    --Generic Smooth Circle Shader (for objects that change size a lot)
    Generic_Smooth_Circle_Shader = love.graphics.newShader[[
      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        vec2 center = vec2(0.5,0.5);
        pixel.a = 1 - smoothstep(.49, .5, distance(center, texture_coords));
        return pixel * color;
      }
    ]]

    --Table containing smooth circle shaders created
    SMOOTH_CIRCLE_TABLE = {}
    --Table containing smooth ring shaders created
    SMOOTH_RING_TABLE = {}


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
    BGM = {
        menu = love.audio.newSource("assets/bgm/Flying Carrots Remix.mp3"),
        level_1 = love.audio.newSource("assets/bgm/Limitless Remix.mp3"),
        level_2 = love.audio.newSource("assets/bgm/Through Hiperboles.ogg"),
        boss_1 = love.audio.newSource("assets/bgm/Boss Theme 1.mp3"),
    }
    --SFX
    SFX = {
        --Game Generic SFXs
        psychoball_shot = love.audio.newSource("assets/sfx/general_sfxs/snd_psychoball_shot.mp3"),
        hit_simple = love.audio.newSource("assets/sfx/general_sfxs/snd_hit_simple_ball.mp3"),
        hit_double = love.audio.newSource("assets/sfx/general_sfxs/snd_hit_double_ball.mp3"),
        psychoball_dies = love.audio.newSource("assets/sfx/general_sfxs/snd_psychoball_dies.mp3"),
        generic_button = love.audio.newSource ("assets/sfx/general_sfxs/snd_generic_button.mp3"),
        back_button = love.audio.newSource ("assets/sfx/general_sfxs/snd_back_button.mp3"),
        play_button = love.audio.newSource("assets/sfx/general_sfxs/snd_button_play.mp3"),
        ultrablast = love.audio.newSource("assets/sfx/general_sfxs/snd_ultrablast.mp3"),
        --Boss 1 SFXs
        b1_stomp = love.audio.newSource("assets/sfx/boss1/stomp.wav"),
        b1_big_thump = love.audio.newSource("assets/sfx/boss1/big_thump.wav"),
        b1_long_roar =  love.audio.newSource("assets/sfx/boss1/long_roar.wav"),
        b1_hurt_roar =  love.audio.newSource("assets/sfx/boss1/hurt_roar.wav"),
        b1_angry_hurt_roar =  love.audio.newSource("assets/sfx/boss1/angry_hurt_roar.wav"),
        b1_angry_af_roar =  love.audio.newSource("assets/sfx/boss1/angry_af_roar.wav"),
    }
    SFX.hit_simple:setVolume(.2*SFX_VOLUME_MULT)
    SFX.hit_double:setVolume(.2*SFX_VOLUME_MULT)
    SFX.generic_button:setVolume(.5*SFX_VOLUME_MULT)
    SFX.psychoball_shot:setVolume(.2*SFX_VOLUME_MULT)
    SFX.back_button:setVolume(.5*SFX_VOLUME_MULT)
    SFX.play_button:setVolume(.3*SFX_VOLUME_MULT)
    SFX.ultrablast:setVolume(1*SFX_VOLUME_MULT)
    SFX.psychoball_dies:setVolume(1*SFX_VOLUME_MULT)

    --DEATH MESSAGE
    DEATH_TEXTS = {
        "Game Over", "No one will miss you", "You now lay with the dead",
        "You ceased to exist", "Your mother wouldn't be proud","Snake? Snake? Snaaaaaaaaaake",
        "Already?", "All your base are belong to BALLS", "You wake up and realize it was all a nightmare",
        "MIND BLOWN", "Just one more", "USPGameDev Rulez", "A winner is not you", "Have a nice death",
        "There is no cake also you died", "You have died of dysentery", "You failed", "BAD END",
        "Embrace your defeat", "Balls have no mercy", "You have no balls left", "Nevermore...",
        "Rest in Peace", "Die in shame", "You've found your end", "KIA", "Status: Deceased",
        "Requiescat in Pace", "Valar Morghulis", "What is dead may never die", "Mission Failed",
        "It's dead Jim", "Arrivederci", "FRANKIE SAYS RELAX, YOU DIED"
    }

    --Start UI color transition
    UI_COLOR = UI.create_color()

    --Background start
    BG.create()

    --FPS Counter
    Txt.create_gui(5, ORIGINAL_WINDOW_HEIGHT - 20, "FPS: ", GUI_MEDLESS, love.timer.getFPS(), "right", GUI_MEDLESS, "fps_counter")

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
    SMOOTH_CIRCLE_TABLE[30] = love.graphics.newShader(Smooth_Circle_Shader:format(30))
    SMOOTH_CIRCLE_TABLE[60] = love.graphics.newShader(Smooth_Circle_Shader:format(60))

    --Create some pre-made smooth rings
    for i_r =1, 21 do
        SMOOTH_RING_TABLE["48-"..i_r] = love.graphics.newShader(Smooth_Ring_Shader:format(48,i_r))
    end
    for i_r =1, 16 do
        SMOOTH_RING_TABLE["38-"..i_r] = love.graphics.newShader(Smooth_Ring_Shader:format(38,i_r))
    end
    print("Finished setting up shaders")

    print("---------------------------")

end

--Return functions
return setup