local Color = require "classes.color.color"
--EFFECTS CLASS --

local fx = {}

---------
--EFFECTS
---------

function fx.colorLoop(o, color_var, d)
    local color_target, duration, func, handle

    color_target = o:getDiffRandColor()
    duration = d or 4
    func = "in-linear"
    fx.colorTransition(o, color_var, color_target, duration, func)
    handle = FX_TIMER:after(duration+.1,
        function()
            fx.colorLoop(o, color_var)
        end
    )
    table.insert(o.handles, handle)
end
----------------------
--TRANSITION FUNCTIONS
----------------------

--Make a smooth transition in a variable var to value f
function fx.varTransition(o, var, f, duration, func)
    mode = mode or 'in-linear'
    duration = duration or 5

    return FX_TIMER:tween(duration, o[var], {f}, func)
end

--Make a smooth transition in an objects o.color_var to color_target
--USES HSL
function fx.colorTransition(o, color_var, color_target, duration, func)

    --HSL transition
    if o[color_var] then
        table.insert(o.handles, FX_TIMER:tween(duration, o[color_var], {h = color_target.h}, func))

        table.insert(o.handles, FX_TIMER:tween(duration, o[color_var], {s = color_target.s}, func))

        table.insert(o.handles, FX_TIMER:tween(duration, o[color_var], {l = color_target.l}, func))
    else
        print("COLOR TRANSITION ERROR")
    end
end

--Return fucntions
return fx
