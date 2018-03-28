local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
require "classes.primitive"

--MODULE FOR THE GAMESTATE: GAMEOVER--

--LOCAL VARIABLES--
local _black_and_white_handle
local _gameover_menu_screen_buttons
local _highscore_menu_screen_buttons
local _current_selected_button
local _current_menu_screen
local _joystick_moved
local _joystick_direction
local _go_to_level
local _go_to_part
local _hs
local _gameover_buttons_lock

--LOCAL FUNCTION DECLARATIONS--
local chooseDeathMessage
local changeSelectedButton
local getValidButtons
local getCurrentSelectedButton
local createRegularGameoverButtons

--------------------

local state = {}

function state:enter(_score)
    local t, b

    _go_to_level = nil
    _go_to_part = nil
    _hs = nil
    _current_menu_screen = "gameover_menu"

    --Blur gamescreen
    USE_BLUR_CANVAS = true

    --Make everything black and white
    BLACK_WHITE_SHADER_FACTOR = 0
    _black_and_white_handle = FX_TIMER:tween(2, _G, {BLACK_WHITE_SHADER_FACTOR = .7}, 'in-linear')

    --Shake Screen
    FX.shake(3,1)

    --Handling Highscore
    local score = PSYCHO_SCORE
    local pos = HS.isHighscore(score)
    if pos then
        --"Got a highscore" text
        Txt.create_gui(180, 100, "You got a highscore on position #"..pos.."!", GUI_BOSS_TITLE, nil, "format", nil, "highscore_text", "center", ORIGINAL_WINDOW_WIDTH/1.5)
        Txt.create_gui(260, 260, "please enter your name and confirm", GUI_MEDMED, nil, "format", nil, "highscore_text2", "center")
        _hs = HS.createHighscoreButton(330, 410, score, pos)

        _gameover_buttons_lock = true
    else
        --Normal gameover text and buttons
        createRegularGameoverButtons()
    end

    --Add slowmotion effect
    SLOWMO_M = .2

    _joystick_moved = false
    _joystick_direction = Vector(0,0)
    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    --Stop using blur
    USE_BLUR_CANVAS = false
    BLUR_CANVAS_1 = nil
    BLUR_CANVAS_2 = nil

    --Stop using black and white effect
    BLACK_WHITE_SHADER_FACTOR = 0
    if _black_and_white_handle then
      FX_TIMER:cancel(_black_and_white_handle)
    end

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")

    --Stop indicators batch from spawning enemies
    if SUBTP_TABLE["enemy_indicator_batch"] then
        for batch in pairs(SUBTP_TABLE["enemy_indicator_batch"]) do
            batch.spawn = false
        end
    end

    --Stop highscore highlight effect
    if HIGHSCORE_HIGHLIGHT_EFFECT_HANDLE then
        FX_TIMER:cancel(HIGHSCORE_HIGHLIGHT_EFFECT_HANDLE)
    end

    Util.clearAllTables("remove")

end


function state:update(dt)
    local m_dt

    if _hs and _hs.death then
        _hs = nil
        createRegularGameoverButtons("got_highscore")
    end

    --Move selected button based on joystick hat or axis input
    if USING_JOYSTICK and CURRENT_JOYSTICK then
      --First try to get hat input
      _joystick_direction = Util.getHatDirection(CURRENT_JOYSTICK:getHat(1))
      if _joystick_direction:len() == 0 then
        --If there isn't a hat input, tries to get an axis input
        _joystick_direction = Vector(Util.getJoystickAxisValues(CURRENT_JOYSTICK, 1, 2)):normalized()
      end
      if _joystick_direction:len() == 0 then
        _joystick_moved = false
      else
        if not _joystick_moved then
          local b = Util.findId(_current_selected_button.."_button")
          if b and b.alpha_modifier >= .3 then
            changeSelectedButton(_joystick_direction)
          end
        end
        --Set joystick as moved so it doesn't move to several buttons at once
        _joystick_moved = true
      end
    end


    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.switch(GS.GAME, _go_to_level, _go_to_part)
    elseif SWITCH == "MENU" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil

        Gamestate.switch(GS.MENU)
    end

    Util.updateTimers(dt)

    Util.updateFPS()

    --Update objects position in slowmo
    m_dt = dt*SLOWMO_M

    Util.updateSubTp(m_dt, "player_bullet")
    Util.updateSubTp(m_dt, "enemies")
    Util.updateSubTp(m_dt, "bosses")
    Util.updateSubTp(m_dt, "decaying_particle")
    Util.updateSubTp(m_dt, "particle_batch")
    Util.updateSubTp(m_dt, "enemy_indicator_batch")
    Util.updateSubTp(m_dt, "growing_circle")
    Util.updateSubTp(m_dt, "enemy_indicator")
    Util.updateSubTp(m_dt, "ultrablast")
    Util.updateSubTp(m_dt, "rotating_indicator")
    Util.updateId(dt, "highscore_button")
    Util.updateSubTp(dt, "gameover_gui") --Update buttons on the gui
    Util.updateSubTp(dt, "button_particles")
    Util.checkCollision()

    --Kill dead objects
    Util.killAll()


end

function state:draw()

    --Stop using canvas
    if USE_CANVAS then
        USE_CANVAS = false
        SCREEN_CANVAS = nil
        love.graphics.clear()
    end

    Draw.allTables()

end

function state:keypressed(key)

    if     key == 'r' and not _gameover_buttons_lock then
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == 'c' and CONTINUE and not _gameover_buttons_lock then
        SWITCH = "GAME"
    elseif key == 'b' and not _gameover_buttons_lock then
        SWITCH = "MENU"
    else
        Util.defaultKeyPressed(key)
    end

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
        local hsb = Util.findId("highscore_button")
        if hsb then hsb:mousepressed(x,y) end
    end

end

function state:joystickpressed(joystick, button)

  if joystick == CURRENT_JOYSTICK then
    if button == GENERIC_JOY_MAP.confirm and _current_selected_button then
      local b = Util.findId(_current_selected_button.."_button")
      if b and not b.lock then
        b:func()
        if b.sfx then b.sfx:play() end
      end
    end
  end

end

------------------
--LOCAL FUNCIONS--
------------------

--Create a centralized level title, that fades out after 3 seconds
function chooseDeathMessage(t)
    local message, fx, fy, x, y, font, limit

    message = Util.randomElement(DEATH_TEXTS) --Get a random death message

    limit = ORIGINAL_WINDOW_WIDTH/2

    --Get position so that the text is centralized on screen
    fx = math.min(t.font:getWidth(message),limit) --Width of text
    fy = t.font:getHeight(message)*  math.ceil(t.font:getWidth(message)/fx) --Height of text
    x = ORIGINAL_WINDOW_WIDTH/2 - fx/2
    y = ORIGINAL_WINDOW_HEIGHT/2 - fy/2

    --Update gameover text, position and limit
    t.pos = Vector(x, y)
    t.text = message
    t.limit = fx

    return message
end

function changeSelectedButton(dir)

  if _current_selected_button then
    local valid_buttons

    if _current_menu_screen == "gameover_menu" then
      valid_buttons = getValidButtons(dir, _gameover_menu_screen_buttons)
    elseif _current_menu_screen == "highscore_menu" then
      valid_buttons = getValidButtons(dir, _highscore_menu_screen_buttons)
    else
      error("Not a valid menu screen ".._current_menu_screen)
    end

    --Find closest button
    local b = Util.findId(_current_selected_button.."_button")
    if not b then return end
    local min_len = 9999999
    local target_button = nil
    for i, k in ipairs(valid_buttons) do
      local temp = Util.findId(k.."_button")
      local len = Vector(temp.pos.x - b.pos.x, temp.pos.y - b.pos.y):len()
      if len < min_len then
        min_len = len
        target_button = k
      end
    end

    --Change currently selected button
    if target_button then
      _current_selected_button = target_button
      local new_button = Util.findId(target_button.."_button")
      b.selected_by_joystick = false
      new_button.selected_by_joystick = true
    end

  end

end

--Returns all buttons that have difference of angle between them and the current button given a direction,
-- based on a list of available buttons
function getValidButtons(direction, available_buttons_table)
  local range = math.pi/4
  local valid_buttons = {}
  local b = Util.findId(_current_selected_button.."_button")
  if not b then return valid_buttons end

  for _,k in ipairs(available_buttons_table) do
    if k ~= _current_selected_button then
      local temp = Util.findId(k.."_button")
      if temp then
        local vector = Vector(temp.pos.x - b.pos.x, temp.pos.y - b.pos.y):normalized()
        local angle = math.abs(direction:angleTo(vector))
        if angle > math.pi then angle = 2*math.pi - angle end
        if angle <= range then
          table.insert(valid_buttons, k)
        end
      end
    end
  end

  return valid_buttons

end

function getCurrentSelectedButton()
  return _current_selected_button
end

function createRegularGameoverButtons(mode)
    _gameover_menu_screen_buttons = {}

    if mode ~= "got_highscore" then
        t = Txt.create_gui(400, 300, "GAMEOVER", GUI_BOSS_TITLE, nil, "format", nil, "gameover_text", "center")
        chooseDeathMessage(t)
    end

    --Restart button
    func = function() SWITCH = "GAME"; CONTINUE = false end
    b = Button.create_circle_gui(140, 650, 75, func, "Restart", GUI_BIGLESSLESS, "gameover_gui", "restart_button", "start a new game")
    b.selected_by_joystick = true --Mark as default selected button
    _current_selected_button = "restart"
    table.insert(_gameover_menu_screen_buttons, "restart")

    if CONTINUE then

        --Continue button
        func = function()
            _go_to_level = "level"..CONTINUE
            _go_to_part = "part_1"
            USED_CONTINUE = true
            SWITCH = "GAME"
        end
        b = Button.create_circle_gui(340, 650, 75, func, "Continue", GUI_BIGLESSLESS, "gameover_gui", "continue_button", "reset lives, score and level progress")
        table.insert(_gameover_menu_screen_buttons, "continue")

    end

    --Back to menu button
    func = function() SWITCH = "MENU" end
    b = Button.create_circle_gui(540, 650, 75, func, "Menu", GUI_BIGLESSLESS, "gameover_gui", "back2menu_button", "reset lives, score and level progress")
    table.insert(_gameover_menu_screen_buttons, "back2menu")

    _gameover_buttons_lock = false
end

--Return state functions
return state
