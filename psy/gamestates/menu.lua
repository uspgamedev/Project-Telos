local Button = require "classes.button"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
local Logo = require "classes.logo"
--MODULE FOR THE GAMESTATE: MENU--

--LOCAL VARIABLES--

local _main_menu_screen_buttons
local _highscore_menu_screen_buttons
local _options_menu_screen_buttons
local _joystick_moved
local _joystick_direction
local _current_selected_button
local _current_menu_screen
local _go_to_level
local _go_to_part
--Buttons
local _but_high = require "buttons.highscore_button"
local _but_high_back = require "buttons.highscore_back_button"
local _but_opt = require "buttons.options_button"
local _but_opt_back = require "buttons.options_back_button"


--LOCAL FUNCTIONS DECLARATIONS--

local changeSelectedButton
local getValidButtons
local getCurrentSelectedButton
local setCurrentSelectedButton
local setCurrentMenuScreen

--------------------

local state = {}

function state:enter()
    local b, func, offset

    --Reset local variables
    _go_to_level = nil
    _go_to_part = nil
    _current_selected_button = nil
    _current_menu_screen = "main_menu"
    _main_menu_screen_buttons = {}

    --Reset camera center pos
    CAM.x = ORIGINAL_WINDOW_WIDTH/2
    CAM.y = ORIGINAL_WINDOW_HEIGHT/2

    love.mouse.setGrabbed(false) --Stop mouse capture

    _joystick_moved = false
    _joystick_direction = Vector(0,0)

    --GUI--

    --------------------
    --MAIN MENU SCREEN--
    --------------------

    offset = 0


    if CONTINUE then
        offset = 105 --Move "Tutorial" button to the right

        --Continue Button
        func = function()
            _go_to_level = "level"..CONTINUE
            _go_to_part = "part_1"
            USED_CONTINUE = true
            SWITCH = "GAME"
        end
        b = Button.create_circle_gui(430, 610, 75, func, "Continue", GUI_BIGLESSLESS, "main_menu_buttons", "main_continue_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(_main_menu_screen_buttons, "main_continue")
    end

    --Play Button
    func = function()
        SWITCH = "GAME"
        CONTINUE = false
        USED_CONTINUE = false
        if FIRST_TIME then
            TUTORIAL = true
        end
    end
    b = Button.create_circle_gui(528, 340, 140, func, "New Game", GUI_BIGLESS, "main_menu_buttons", "main_play_button")
    b.sfx = SFX.play_button
    b.ring_growth_speed = b.ring_growth_speed
    b.alpha_mod_v = 1.5
    b.alpha_modifier = 0
    b.lock = true
    b.selected_by_joystick = true --Mark as default selected button
    _current_selected_button = "main_play"
    table.insert(_main_menu_screen_buttons, "main_play")

    if not FIRST_TIME then

        --Tutorial Button
        func = function() SWITCH = "GAME"; TUTORIAL = true end
        b = Button.create_circle_gui(525+offset, 610, 75, func, "Tutorial", GUI_BIGLESSLESS, "main_menu_buttons", "main_tutorial_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(_main_menu_screen_buttons, "main_tutorial")


        --"Go to Highscore Menu Screen" button
        func = function()
             _but_high()
             setCurrentSelectedButton("high_go2main")
             setCurrentMenuScreen("highscore_menu")
        end
        b = Button.create_circle_gui(880, 650, 90, func, "Highscores", GUI_BIGLESSLESS, "main_menu_buttons", "main_go2highscore_button")
        b.sfx = SFX.generic_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(_main_menu_screen_buttons, "main_go2highscore")

    end

    --"Go to Options Menu Screen" button
    func = function()
         _but_opt()
         setCurrentSelectedButton("options_go2main")
         setCurrentMenuScreen("options_menu")
    end
    b = Button.create_circle_gui(ORIGINAL_WINDOW_WIDTH - 880, 650, 90, func, "Options", GUI_BIGLESSLESS, "main_menu_buttons", "main_go2options_button")
    b.sfx = SFX.generic_button
    b.alpha_modifier = 0
    b.lock = true
    table.insert(_main_menu_screen_buttons, "main_go2options")


    --Create main menu logo
    local logo = Logo.create()

    -------------------------
    --HIGHSCORE MENU SCREEN--
    -------------------------

    _highscore_menu_screen_buttons = {} --Reset available buttons for joystick


    HS.draw(nil, ORIGINAL_WINDOW_WIDTH, 0) --Create highscore table "one screen to the right"

    --"Go to Main Menu Screen" button
    func = function()
         _but_high_back()
         setCurrentSelectedButton("main_go2highscore")
         setCurrentMenuScreen("main_menu")
    end
    b = Button.create_circle_gui(ORIGINAL_WINDOW_WIDTH + 110, 680, 55, func, "Back", GUI_BIGLESSLESS, "highscore_menu_buttons", "high_go2main_button")
    b.sfx = SFX.back_button
    table.insert(_highscore_menu_screen_buttons, "high_go2main")

    -----------------------
    --OPTIONS MENU SCREEN--
    -----------------------

    _options_menu_screen_buttons = {} --Reset available buttons for joystick

    --"Go to Main Menu Screen" button
    func = function()
         _but_opt_back()
         setCurrentSelectedButton("main_go2options")
         setCurrentMenuScreen("main_menu")
    end
    b = Button.create_circle_gui(880 - ORIGINAL_WINDOW_WIDTH, 650, 55, func, "Back", GUI_BIGLESSLESS, "options_menu_buttons", "opt_go2main_button")
    b.sfx = SFX.back_button
    table.insert(_options_menu_screen_buttons, "opt_go2main")


    --AUDIO--
    Audio.playBGM(BGM.menu, nil, 3.5)

    --SHAKE--
    if Util.tableLen(SHAKE_HANDLES) > 0 then
        for handle in pairs(SHAKE_HANDLES) do
          LEVEL_TIMER:cancel(handle)
        end
    end

end

function state:leave()

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)
    --Move selected button based on joystick hat or axis input
    if USING_JOYSTICK and CURRENT_JOYSTICK then
      --First try to get hat input, if there is
      _joystick_direction = Util.getHatDirection(CURRENT_JOYSTICK:getHat(1))
      if _joystick_direction:len() == 0 then
        --If there isn't a hat input, tries to get an axis input
        _joystick_direction = Vector(Util.getJoystickAxisValues(CURRENT_JOYSTICK, GENERIC_JOY_MAP.laxis_horizontal, GENERIC_JOY_MAP.laxis_vertical)):normalized()
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

    Util.updateSubTp(dt, "gui")
    Util.updateSubTp(dt, "main_menu_buttons")
    Util.updateSubTp(dt, "highscore_menu_buttons")
    Util.updateSubTp(dt, "options_menu_buttons")
    Util.updateSubTp(dt, "button_particles")
    Util.updateId(dt, "logo")

    Util.updateTimers(dt)

    Util.updateFPS()

    Util.killAll()

    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        if TUTORIAL then
          Gamestate.switch(GS.GAME, "tutorial")
        else
          Gamestate.switch(GS.GAME, _go_to_level, _go_to_part)
        end
    end
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
    if key == '1' then
        _go_to_level = "level1"
        _go_to_part = "part_1"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '2' then
        _go_to_level = "level1"
        _go_to_part = "part_2"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '3' then
        _go_to_level = "level1"
        _go_to_part = "part_3"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '4' then
        _go_to_level = "level1"
        _go_to_part = "part_4"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '5' then
        _go_to_level = "level2"
        _go_to_part = "part_1"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '6' then
        _go_to_level = "level2"
        _go_to_part = "part_2"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '7' then
        _go_to_level = "level2"
        _go_to_part = "part_3"
        SWITCH = "GAME"
        CONTINUE = false
    elseif key == '8' then
        _go_to_level = "level2"
        _go_to_part = "part_4"
        SWITCH = "GAME"
        CONTINUE = false
    else
        Util.defaultKeyPressed(key)
    end
end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

function state:joystickpressed(joystick, button)
  if joystick == CURRENT_JOYSTICK then
    if button == GENERIC_JOY_MAP.confirm then
      local b = Util.findId(_current_selected_button.."_button")
      if b and not b.lock then
        b:func()
        if b.sfx then b.sfx:play() end
      end
    end
  end

end

--LOCAL FUNCTIONS--

function changeSelectedButton(dir)

  if _current_selected_button then
    local valid_buttons

    if _current_menu_screen == "main_menu" then
      valid_buttons = getValidButtons(dir, _main_menu_screen_buttons)
    elseif _current_menu_screen == "highscore_menu" then
      valid_buttons = getValidButtons(dir, _highscore_menu_screen_buttons)
  elseif _current_menu_screen == "options_menu" then
      valid_buttons = getValidButtons(dir, _options_menu_screen_buttons)
    else
      error("Not a valid menu screen ".._current_menu_screen)
    end

    --Find closes button
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

function setCurrentSelectedButton(but)
  _current_selected_button = but
end

function setCurrentMenuScreen(scr)
  _current_menu_screen = scr
end

--Return state functions
return state
