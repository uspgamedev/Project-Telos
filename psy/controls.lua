local Util = require "util"
--CONTROLS CLASS --

local func = {}

--Local variables
local _command_id_name = { --Verbose name of each command id
  start = "Start",
  confirm = "Confirm",
  back = "Back",
  shoot = "Shoot",
  ultrablast1 = "Ultrablast",
  ultrablast2 = "Ultrablast (secondary)",
  focus = "Focus",
  laxis_horizontal = "Left Stick (horizontal axis)",
  laxis_vertical = "Left Stick (vertical axis)",
  raxis_horizontal = "Right Stick (horizontal axis)",
  raxis_vertical = "Right Stick (vertical axis)",
}

local _default_gamepad_mapping = { --Mapping of generic joystick buttons
  start = {type = "button", value = 4},
  confirm = {type = "button", value = 1},
  back = {type = "button", value = 2},
  shoot = {type = "button", value = 14},
  ultrablast1 = {type = "axis", value = 3},
  ultrablast2 = {type = "axis", value = 6},
  focus = {type = "button", value = 11},
  laxis_horizontal = {type = "axis", value = 1},
  laxis_vertical = {type = "axis", value = 2},
  raxis_horizontal = {type = "axis", value = 4},
  raxis_vertical = {type = "axis", value = 5},
}

local _gamepad_mapping = {} --Current gamepad mapping
local _joystick_deadzone = .3 --Percentage of dead zone on all sticks (value between [0,1])
local _getting_input = false --If game is looking for input
local _previous_axis = nil --Previous values for all axis
local _previous_button = nil --Previous values for all joystick buttons

--Functions--

--JOYSTICK VALUES FUNCTIONS--

--Return corrected joystick value given two axis.
--If axis are given as strings, it will take the value from gamepad mapping
function func.getJoystickAxisValues(joy, horizontal_axis, vertical_axis)
  if type(horizontal_axis) == "string" then
      horizontal_axis = func.getCommand(horizontal_axis)
  end
  if type(vertical_axis) == "string" then
      vertical_axis = func.getCommand(vertical_axis)
  end
  local v = Vector(joy:getAxis(horizontal_axis), joy:getAxis(vertical_axis))
  if(v:len() < _joystick_deadzone) then
      v = Vector(0,0)
  else
      v = v:normalized() * ((v:len() - _joystick_deadzone) / (1 - _joystick_deadzone))
  end
  return v.x, v.y
end

--Given a hat value, returns the correspondent direction
function func.getHatDirection(hat)
  if hat == 'l' then
    return Vector(-1,0)
  elseif hat == 'u' then
    return Vector(0,-1)
  elseif hat == 'r' then
    return Vector(1,0)
  elseif hat == 'd' then
    return Vector(0,1)
  elseif hat == 'lu' then
    return Vector(-1,-1)
  elseif hat == 'ru' then
    return Vector(1,-1)
  elseif hat == 'rd' then
    return Vector(1,1)
  elseif hat == 'ld' then
    return Vector(-1,1)
  elseif hat == 'c' then
    return Vector(0,0)
  else
    return Vector(0,0)
  end
end

--COMMAND FUNCTIONS--

function func.getCommandName(id)
    return _command_id_name[id]
end

function func.setGamepadMapping(map)
    _gamepad_mapping = map
end

function func.getGamepadMapping()
    return _gamepad_mapping
end

function func.getDefaultGamepadMapping()
    return _default_gamepad_mapping
end

--Checks if a command is active
function func.isActive(joystick, command_id)
    local command = _gamepad_mapping[command_id]
    if command.type == "button" then
        return love.joystickpressed(joystick, command.value)
    elseif command.type == "axis" then
        local direction = joystick:getAxis(command.value)
        return (math.abs(direction) > _joystick_deadzone)
    elseif command.type == "hat" then
        local hat_value = joystick:getHat(command.hat_index)
        return (hat_value == command.value)
    end
end

--Given a command ID, returns its value and type
function func.getCommand(command_id)
    local command = _gamepad_mapping[command_id]
    return command.value, command.type
end

function func.setCommand(command_id, input_info)
    _gamepad_mapping[command_id] = input_info
end


--PLAYER INPUT FUNCTIONS--

--Set previous state of axis
function func.setPreviousAxis(joystick)
    _previous_axis = {}
    for i = 1, joystick:getAxisCount() do
        _previous_axis[i] = joystick:getAxis(i)
    end
end

--Set previous state of buttons
function func.setPreviousButton(joystick)
    _previous_button = {}
    for i = 1, joystick:getButtonCount() do
        _previous_button[i] = joystick:isDown(i)
    end
end


function func.setGettingInputFlag(value)
    _getting_input = value
end

function func.isGettingInput()
    return _getting_input
end

--Function to be called on update, that checks for player input.
-- If found, returns the appropriate input table
function func.getPlayerInput()
    if not _getting_input or not CURRENT_JOYSTICK then return end

    --Check if a button is pressed
    if _getting_input ~= "axis" then
        for i = 1, CURRENT_JOYSTICK:getButtonCount() do
            if CURRENT_JOYSTICK:isDown(i) then
                --Check for repeating input
                if not _previous_button[i] then
                    return {type = "button", value = i}
                end
            else
                _previous_button[i] = false
            end
        end
    end

    --Check if a hat is pressed
    if _getting_input ~= "axis" then
        for i = 1, CURRENT_JOYSTICK:getHatCount() do
            local joystick_hat = CURRENT_JOYSTICK:getHat(i)
            local direction = func.getHatDirection(hat)
            if direction:len() > 0 then
                return {type = "hat", value = joystick_hat, hat_index = i}
            end
        end
    end

    --Check if an axis has moved
    local difference_needed = .5
    for i = 1, CURRENT_JOYSTICK:getAxisCount() do
        local v = CURRENT_JOYSTICK:getAxis(i)
        if math.abs(v - _previous_axis[i]) >= difference_needed then
            return {type = "axis", value = i}
        end
    end

end



return func
