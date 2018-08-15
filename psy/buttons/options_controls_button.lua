local Button = require "classes.button"
local Util = require "util"

local function f(options_buttons)
    --Remove all previous buttons except for important ones
    for i,b in pairs(options_buttons) do
        if b ~= "opt_controls" and b ~= "opt_go2main" then
            local but = Util.findId(b.."_button")
            if but then
                but.kill()
                options_buttons[i] = nil
            end
        end
    end

    --Create controls buttons
    local x, original_y, gap_y, gap_x = 240, 170, 70, 400
    local y = original_y
    local cont = 1
    local command_order = {
        "confirm", "back", "shoot", "ultrablast1", "ultrablast2",
        "focus", "start", "laxis_horizontal", "laxis_vertical", "raxis_horizontal",
        "raxis_vertical"
    }
    for i,command in ipairs(command_order) do
        local key, type = Controls.getCommand(command)
        Button.create_keybinding_gui(x - ORIGINAL_WINDOW_WIDTH, y, command, key, type, "options_menu_buttons", command.."_command_button")
        table.insert(options_buttons, command.."_command")
        y = y + gap_y
        cont = cont + 1
        if cont > math.ceil(Util.tableLen(Controls.getGamepadMapping())/2) then
            cont = 1
            y = original_y
            x = x + gap_x
        end
    end
end
return f
