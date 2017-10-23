local Util = require "util"
local FX = require "fx"

return function()
    local objects_positions = {}
    local target_x_values = {}
    local handles_table = {}

    --Iterate through all main menu buttons and add objects positions (and target values) to the tables
    local table_ = Util.findSbTp("main_menu_buttons")
    if table_ then
        for ob in pairs(table_) do
            table.insert(objects_positions, ob.pos)
            table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the right
            table.insert(handles_table, ob.handles)
            ob.lock = false
        end
    end

    --Iterate through all main menu buttons and add objects positions (and target values) to the tables
    local table_ = Util.findSbTp("highscore_menu_buttons")
    if table_ then
        for ob in pairs(table_) do
            table.insert(objects_positions, ob.pos)
            table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the right
            table.insert(handles_table, ob.handles)
            ob.lock = true
        end
    end

    --Iterate through all main menu buttons and add objects positions (and target values) to the tables
    local table_ = Util.findSbTp("highscore_screen_texts")
    if table_ then
        for ob in pairs(table_) do
            table.insert(objects_positions, ob.pos)
            table.insert(target_x_values, ob.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the right
            table.insert(handles_table, ob.handles)
        end
    end

    --Add logo to table
    local logo = Util.findId("logo")
    if logo then
      table.insert(objects_positions, logo.pos)
      table.insert(target_x_values, logo.pos.x + ORIGINAL_WINDOW_WIDTH) --Move objects to the right
      table.insert(handles_table, logo.handles)
    end

    --Change x value of all menu objects
    FX.change_value_objects(objects_positions, "x", target_x_values, 1800, "moving_tween", handles_table, "out-back")

end
