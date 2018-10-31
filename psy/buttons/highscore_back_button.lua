local Util = require "util"
local FX = require "fx"

return function()
    --Iterate through all highscore menu buttons and add objects positions (and target values) to the tables
    local table = Util.findSbTp("highscore_menu_buttons")
    if table then
        for ob in pairs(table) do
            ob.lock = true
        end
    end

    --Iterate through all main menu buttons and unlock them
    local table = Util.findSbTp("main_menu_buttons")
    if table then
        for ob in pairs(table) do
            ob.lock = false
        end
    end

    MENU_CAM_POS = {WINDOW_WIDTH/2,WINDOW_HEIGHT/2}

    --Update button selection for joystick
    local b = Util.findId("high_go2main_button")
    if b then b.selected_by_joystick = false end
    local b = Util.findId("main_go2highscore_button")
    if b then b.selected_by_joystick = true end
end
