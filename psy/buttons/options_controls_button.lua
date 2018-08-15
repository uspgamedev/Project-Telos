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
    local offset = 0
    if current_menu_screen == "main_menu" then
        offset = ORIGINAL_WINDOW_WIDTH
    end
    local x, original_y, gap_y, gap_x = 170, 170, 70, 370
    local y = original_y
    local cont = 1
    local command_order = {
        "confirm", "back", "shoot", "ultrablast1", "ultrablast2",
        "focus", "start", "laxis_horizontal", "laxis_vertical", "raxis_horizontal",
        "raxis_vertical"
    }
    for i,command in ipairs(command_order) do
        local key, type = Controls.getCommand(command)
        Button.create_keybinding_gui(x - offset, y, command, key, type, "options_menu_buttons", command.."_command_button")
        table.insert(options_buttons, command.."_command")
        y = y + gap_y
        cont = cont + 1
        if cont > math.ceil(Util.tableLen(Controls.getGamepadMapping())/2) then
            cont = 1
            y = original_y
            x = x + gap_x
        end
    end
    --Create recomended text
    Txt.create_gui(780 - offset, 180, "recommended", GUI_MED, nil, nil, nil, "controls_recommended", nil, nil, nil, "options_screen_normal_texts")
end
return f
