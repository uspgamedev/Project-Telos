local Button = require "classes.button"
local Psycho = require "classes.psycho"
local Color  = require "classes.color.color"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Txt = require "classes.text"
--MODULE FOR THE GAMESTATE: PAUSE--

--LOCAL VARIABLES--

local pause_menu_screen_buttons
local _current_selected_button
local joystick_moved
local joystick_direction

--LOCAL FUNCTION DECLARATION--
local getValidButtons
local changeCurrentSelectedButton

--------------------

local state = {}

function state:enter()
    local t, b, func

    --Blur gamescreen
    USE_BLUR_CANVAS = true

    --GUI--

    --Main pause text
    Txt.create_gui(440, 300, "Pause", GUI_BIG)

    pause_menu_screen_buttons = {}

    --Unpause button
    func = function() SWITCH = "GAME" end
    b = Button.create_circle_gui(140, 650, 75, func, "Unpause", GUI_BIGLESSLESS, "pause_gui", "unpause_button")
    b.selected_by_joystick = true --Mark as default selected button
    _current_selected_button = "unpause"
    table.insert(pause_menu_screen_buttons, "unpause")


    --"Go back" button
    func = function() SWITCH = "MENU" end
    b = Button.create_circle_gui(340, 650, 75, func, "Menu", GUI_BIGLESSLESS, "pause_gui", "back2menu_button", "reset lives, score and level progress")
    table.insert(pause_menu_screen_buttons, "back2menu")


    --AUDIO--
    Audio.pauseSFX()

    --Decrease current bgm volume
    local bgm = Audio.getCurrentBGM()
    if bgm then
        Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL/5,.3,false,true)
    end

    joystick_moved = false
    joystick_direction = Vector(0,0)

    love.mouse.setVisible(true) --Make cursor visible
    love.mouse.setGrabbed(false) --Stop mouse capture

end

function state:leave()

    --Stop using blur
    USE_BLUR_CANVAS = false

    Psycho.updateSpeed(Psycho.get())

    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

    Audio.resumeSFX()

    --Return current bgm volume to normal
    local bgm = Audio.getCurrentBGM()
    if bgm then
        Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL,.3,false,true)
    end

    love.mouse.setVisible(false) --Make cursor invisible
    love.mouse.setGrabbed(true) --Resume mouse capture

end


function state:update(dt)

    --Move selected button based on joystick hat or axis input
    if USING_JOYSTICK and CURRENT_JOYSTICK then
      --First try to get hat input
      joystick_direction = Controls.getHatDirection(CURRENT_JOYSTICK:getHat(1))
      if joystick_direction:len() == 0 then
        --If there isn't a hat input, tries to get an axis input
        joystick_direction = Vector(Controls.getJoystickAxisValues(CURRENT_JOYSTICK, "laxis_horizontal", "laxis_vertical")):normalized()
      end
      if joystick_direction:len() == 0 then
        joystick_moved = false
      else
        if not joystick_moved then
          local b = Util.findId(_current_selected_button.."_button")
          if b and b.alpha_modifier >= .3 then
            changeCurrentSelectedButton(joystick_direction)
          end
        end
        --Set joystick as moved so it doesn't move to several buttons at once
        joystick_moved = true
      end
    end


    if SWITCH == "GAME" then
        SWITCH = nil
        Util.gameElementException()
        Gamestate.pop()

    elseif SWITCH == "MENU" then
        SWITCH = nil
        Util.clearTimerTable(DEATH_HANDLES, FX_TIMER)
        Util.clearTimerTable(WINM_HANDLES, LEVEL_TIMER)
        CAM.rot = 0 --Reset camera rotation
        CAM.scale = 1 --Reset camera zoom

        BLACK_WHITE_SHADER_FACTOR = 0 --Reset grey factor

        Audio.stopSFX()

        SFX.back_button:play()

        if TUTORIAL then
            TUTORIAL = false
            FIRST_TIME = false

            DONT_ENABLE_SHOOTING_AFTER_DEATH = false
            DONT_ENABLE_ULTRA_AFTER_DEATH = false
            DONT_ENABLE_MOVING_AFTER_DEATH = false

            --Turn fps counter visible
            txt = Util.findId("fps_counter")
            txt.level_handles["become_visible"] = LEVEL_TIMER:tween(1, txt, {alpha = 255}, 'in-linear')

        end

        --Stop indicators batch from spawning enemies
        if SUBTP_TABLE["enemy_indicator_batch"] then
            for batch in pairs(SUBTP_TABLE["enemy_indicator_batch"]) do
                batch.spawn = false
            end
        end

        Gamestate.pop()
        Gamestate.switch(GS.MENU)
    end

    COLOR_TIMER:update(dt)
    AUDIO_TIMER:update(dt)

    Util.updateSubTp(dt, "pause_gui") --Update buttons on the gui
    Util.updateSubTp(dt, "button_particles")

    Util.updateFPS()

    Util.killAll()


end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)

    if     key == 'p' or key == 'escape' then
        SWITCH = "GAME" --Unpause game
    elseif key == 'b' then
        SWITCH = "MENU" --Go back to menu
    else
        Util.defaultKeyPressed(key)
    end

end

function state:joystickpressed(joystick, button)


  if joystick == CURRENT_JOYSTICK then
    if button == Controls.getCommand("start") or button == Controls.getCommand("back") then
      SWITCH = "GAME" --Return to game
  elseif button == Controls.getCommand("confirm") then
      local b = Util.findId(_current_selected_button.."_button")
      if b and not b.lock then
        b:func()
        if b.sfx then b.sfx:play() end
      end
    end
  end

end

function state:mousepressed(x, y, button)
    local scale

    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end

end

--LOCAL FUNCTIONS--

function changeCurrentSelectedButton(dir)

  if _current_selected_button then
    local valid_buttons

    valid_buttons = getValidButtons(dir, pause_menu_screen_buttons)

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

function state:getCurrentSelectedButton()
  return _current_selected_button
end

function state:setCurrentSelectedButton(but)
  if _current_selected_button then
      Util.findId(_current_selected_button.."_button").selected_by_joystick = false
  end
  _current_selected_button = but
  local b = Util.findId(but.."_button")
  b.selected_by_joystick = true
end

--Return state functions
return state
