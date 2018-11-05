local ResManager = require "res_manager"
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

    --Create fullscreen switch button
    local switch_func = function(status)
        if status == "disabled" then
            local w, h = love.graphics.getWidth(), love.graphics.getHeight()
            love.window.setMode(w, h, {fullscreen = false, resizable = true,
                                minwidth = 800, minheight = 600})
            ResManager.adjustWindow(w, h)
        elseif status == "borderless fullscreen" then
            love.window.setFullscreen(true, "desktop")
        elseif status == "windowed fullscreen" then
            local w, h = ResManager.getRealWidth(), ResManager.getRealHeight()
            love.window.setMode(w, h, {fullscreen = false, resizable = true,
                                minwidth = 800, minheight = 600})
            ResManager.adjustWindow(w, h)
        else
            error("not a valid fullscreen status: "..status)
        end
    end
    local status_func = function()
        local fs, mode = love.window.getFullscreen()
        if not fs then
            if ResManager.getRealWidth() == love.graphics.getWidth() and
               ResManager.getRealHeight() == love.graphics.getHeight() then
                return "disabled"
            else
                return "windowed fullscreen"
            end
        else
            return "borderless fullscreen"
        end
    end
    Button.create_switch_gui(400 - WINDOW_WIDTH, 190, "Fullscreen",
        {"disabled","borderless fullscreen", "windowed fullscreen"},
        switch_func,
        status_func,
        nil, "options_menu_buttons", "fullscreen_button"
    )
    table.insert(options_buttons, "fullscreen")

end
return f
