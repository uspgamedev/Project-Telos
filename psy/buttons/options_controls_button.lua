local Button = require "classes.button"
local Txt = require "classes.text"
local Util = require "util"

local function f(options_buttons, current_menu_screen)
    --Remove all previous buttons except for important ones
    for i,b in pairs(options_buttons) do
        if b ~= "opt_controls" and b ~= "opt_go2main" then
            local but = Util.findId(b.."_button")
            if but then
                but:kill()
                options_buttons[i] = nil
            end
        end
    end
    --Remove all previous text
    local texts = Util.findSbTp("options_screen_normal_texts")
    if texts then
        for txt in pairs(texts) do
            txt:kill()
        end
    end

    --Create controls buttons
    local x, y, gap_y = 230 - WINDOW_WIDTH, 110, 55, 370
    local cont = 1
    local command_order = {
        "confirm", "back", "shoot", "ultrablast1", "ultrablast2",
        "focus", "start", "laxis_horizontal", "laxis_vertical", "raxis_horizontal",
        "raxis_vertical"
    }
    local command_image = {
        "confirm", "back", "rightbumper", "lefttrigger", "righttrigger",
        "leftbumper", "start", "leftstickhorizontal", "leftstickvertical", "rightstickhorizontal",
        "rightstickvertical"
    }
    for i,command in ipairs(command_order) do
        local key, type = Controls.getCommand(command)
        local image = IMG["controller_"..command_image[i]]
        local image_empty
        if command_image[i]:sub(1,9) == "leftstick" then
            image_empty = IMG["controller_"..command_image[i]:sub(1,9).."_empty"]
        elseif command_image[i]:sub(1,10) == "rightstick" then
            image_empty = IMG["controller_"..command_image[i]:sub(1,10).."_empty"]
        else
            image_empty = IMG["controller_"..command_image[i].."_empty"]
        end
        Button.create_keybinding_gui(x, y, command, key, type, image, image_empty, "options_menu_buttons", command.."_command_button")
        table.insert(options_buttons, command.."_command")
        y = y + gap_y
    end

    --Create autoshoot toggle button
    Button.create_toggle_gui(500 - WINDOW_WIDTH, 450, "Auto Shoot",
        function()
            JOYSTICK_AUTO_SHOOT = not JOYSTICK_AUTO_SHOOT
        end,
        function()
            return JOYSTICK_AUTO_SHOOT
        end,
        nil, "options_menu_buttons", "autoshoot_button"
    )
    table.insert(options_buttons, "autoshoot")

end
return f
