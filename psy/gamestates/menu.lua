local Button = require "classes.button"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Txt = require "classes.text"
local Logo = require "classes.logo"
--MODULE FOR THE GAMESTATE: MENU--

--LOCAL VARIABLES--

local main_menu_screen_buttons
local highscore_menu_screen_buttons
local joystick_moved
local joystick_direction

--BUTTON FUNCTIONS--

--------------------

local state = {}

function state:enter()
    local b, func, offset

    --GUI--

    --------------------
    --MAIN MENU SCREEN--
    --------------------

    offset = 0

    main_menu_screen_buttons = {} --Reset available buttons for joystick

    if CONTINUE then
        offset = 105 --Move "Tutorial" button to the right

        --Continue Button
        func = function() SWITCH = "GAME" end
        b = Button.create_circle_gui(430, 610, 75, func, "Continue", GUI_BIGLESSLESS, "main_menu_buttons", "menu_continue_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(main_menu_screen_buttons, "menu_continue")
    end

    --Play Button
    func = require "buttons.play_button"
    b = Button.create_circle_gui(528, 340, 140, func, "New Game", GUI_BIGLESS, "main_menu_buttons", "menu_play_button")
    b.sfx = SFX.play_button
    b.ring_growth_speed = b.ring_growth_speed
    b.alpha_mod_v = 1.5
    b.alpha_modifier = 0
    b.lock = true
    b.selected_by_joystick = true --Mark as default selected button
    CURRENT_SELECTED_BUTTON = "menu_play"
    table.insert(main_menu_screen_buttons, "menu_play")

    if not FIRST_TIME then

        --Tutorial Button
        func = function() SWITCH = "GAME"; TUTORIAL = true end
        b = Button.create_circle_gui(525+offset, 610, 75, func, "Tutorial", GUI_BIGLESSLESS, "main_menu_buttons", "menu_tutorial_button")
        b.sfx = SFX.play_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(main_menu_screen_buttons, "menu_tutorial")


        --"Go to Highscore Menu Screen" button
        local func = require "buttons.highscore_button"
        b = Button.create_circle_gui(880, 650, 90, func, "Highscores", GUI_BIGLESSLESS, "main_menu_buttons", "menu_go2highscore_button")
        b.sfx = SFX.generic_button
        b.alpha_modifier = 0
        b.lock = true
        table.insert(main_menu_screen_buttons, "menu_go2highscore")

    end


    --Create main menu logo
    local logo = Logo.create()

    -------------------------
    --HIGHSCORE MENU SCREEN--
    -------------------------

    highscore_menu_screen_buttons = {} --Reset available buttons for joystick


    HS.draw(nil, ORIGINAL_WINDOW_WIDTH, 0) --Create highscore table "one screen to the right"

    --"Go to Main Menu Screen" button
    func = require "buttons.highscore_back_button"
    b = Button.create_circle_gui(ORIGINAL_WINDOW_WIDTH + 110, 680, 55, func, "Back", GUI_BIGLESSLESS, "highscore_menu_buttons", "menu_go2main_button")
    b.sfx = SFX.back_button
    table.insert(highscore_menu_screen_buttons, "menu_go2menu")

    --AUDIO--
    Audio.playBGM(BGM.menu)

    --SHAKE--
    if SHAKE_HANDLE then
        LEVEL_TIMER:cancel(SHAKE_HANDLE)
    end

    love.mouse.setGrabbed(false) --Stop mouse capture

    joystick_moved = false
    joystick_direction = Vector(0,0)
    CURRENT_MENU_SCREEN = "main_menu"

end

function state:leave()

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)

    --Move selected button based on joystick hat or axis input
    if USING_JOYSTICK and CURRENT_JOYSTICK then
      --First try to get hat input
      joystick_direction = Util.getHatDirection(CURRENT_JOYSTICK:getHat(1))
      if joystick_direction:len() == 0 then
        --If there isn't a hat input, tries to get an axis input
        joystick_direction = Vector(Util.getJoystickAxisValues(CURRENT_JOYSTICK, 1, 2)):normalized()
      end
      if joystick_direction:len() == 0 then
        joystick_moved = false
      else
        if not joystick_moved then
          changeSelectedButton(joystick_direction)
        end
        --Set joystick as moved so it doesn't move to several buttons at once
        joystick_moved = true
      end
    end

    if SWITCH == "GAME" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.switch(GS.GAME)
    end

    Util.updateSubTp(dt, "gui")
    Util.updateSubTp(dt, "main_menu_buttons")
    Util.updateSubTp(dt, "highscore_menu_buttons")
    Util.updateSubTp(dt, "decaying_particle")
    Util.updateId(dt, "logo")

    Util.updateTimers(dt)

    Util.updateFPS()

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

    Util.defaultKeyPressed(key)

end

function state:mousepressed(x, y, button)

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

function state:joystickpressed(joystick, button)

  if joystick == CURRENT_JOYSTICK then
    if button == GENERIC_JOY_MAP.confirm then
      local b = Util.findId(CURRENT_SELECTED_BUTTON.."_button")
      if b and not b.lock then
        b:func()
        if b.sfx then b.sfx:play() end
      end
    end
  end

end

--LOCAL FUNCTIONS--

function changeSelectedButton(dir)

  if CURRENT_SELECTED_BUTTON then
    local valid_buttons

    if CURRENT_MENU_SCREEN == "main_menu" then
      valid_buttons = getValidButtons(dir, main_menu_screen_buttons)
    elseif CURRENT_MENU_SCREEN == "highscore_menu" then
      valid_buttons = getValidButtons(dir, highscore_menu_screen_buttons)
    else
      error("Not a valid menu screen "..CURRENT_MENU_SCREEN)
    end

    --Find closes button
    local b = Util.findId(CURRENT_SELECTED_BUTTON.."_button")
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
      CURRENT_SELECTED_BUTTON = target_button
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
  local b = Util.findId(CURRENT_SELECTED_BUTTON.."_button")
  if not b then return valid_buttons end

  for _,k in ipairs(available_buttons_table) do
    if k ~= CURRENT_SELECTED_BUTTON then
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

--Return state functions
return state
