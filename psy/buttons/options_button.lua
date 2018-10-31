local Util = require "util"
local FX = require "fx"

return function()
    --Iterate through all main menu buttons and add objects positions (and target values) to the tables
    local table = Util.findSbTp("main_menu_buttons")
    if table then
        for ob in pairs(table) do
            ob.lock = true
        end
    end

    --Iterate through all options menu buttons and unlock them
    local table = Util.findSbTp("options_menu_buttons")
    if table then
        for ob in pairs(table) do
            ob.lock = false
        end
    end

    MENU_CAM_POS = {-WINDOW_WIDTH/2,WINDOW_HEIGHT/2}

    --Update button selection for joystick
    local b = Util.findId("opt_go2main_button")
    if b then b.selected_by_joystick = true end
    local b = Util.findId("main_go2options_button")
    if b then b.selected_by_joystick = false end
end
