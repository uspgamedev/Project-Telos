local Button = require "classes.button"
local Txt = require "classes.text"
local Util = require "util"

local function f(options_buttons, current_menu_screen)
    --Remove all previous buttons except for important ones
    for i,b in pairs(options_buttons) do
        if b ~= "opt_controls" and b ~= "opt_go2main" and b ~= "opt_video" then
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

    --Create Video buttons

    --Create fullscreen toggle button
    Button.create_toggle_gui(230 - WINDOW_WIDTH, 110, "Fullscreen",
        function()
            print("stuff")
        end,
        function()
            return true
        end,
        nil, "options_menu_buttons", "fullscreen_button"
    )
    table.insert(options_buttons, "fullscreen")

end
return f
