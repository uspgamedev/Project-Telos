local Button = require "classes.button"

local table = {}
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

end
return f, table
