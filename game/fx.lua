local Color = require "classes.color.color"
local Particle = require "classes.particle"
--EFFECTS CLASS --

local fx = {}

--------------------
--PARTICLE FUNCTIONS
--------------------

--Creates a colored article explosion starting at a circle with center (x,y) and radius r
function fx.explosion(x, y, r, color, number, speed, decaying, size)
    local dir --Direction for particle

    --Default Values
    number = number or 30           --Number of particles created in a explosion
    speed    = speed    or 200  --Particles speed
    decaying = decaying or .98  --Particles decaying alpha speed (when reaching 0, it will be deleted)
    size = size or 4

    --Creates all particles of explosion
    for i=1, number do

        --Randomize direction for each particle (value between [-1,1])
        dir = Vector(0,0)
        dir.x = love.math.random()*2 - 1
        dir.y = love.math.random()*2 - 1
        --Randomize position inside the given circle
        pos = Vector(0,0)
        pos.x = x + love.math.random()*2*(r-size) - (r-size)
        pos.y = y + love.math.random()*2*(r-size) - (r-size)

        Particle.create_decaying(pos, dir, color, speed, decaying, size)

    end

end

------------------
--CAMERA FUNCTIONS
------------------

--Shake the camera for d seconds, with "strength" s
function fx.shake(d, s)
    local orig_x, orig_y, str

    str = s or 4 --Strength of shake

    orig_x = CAM.x
    orig_y = CAM.y

    Game_Timer.during(d,
        function()
            CAM.x = orig_x + math.random(-str,str)
            CAM.y = orig_y + math.random(-str,str)
        end,
        function()
            -- reset camera position
            CAM.x = orig_x
            CAM.y = orig_y
        end
    )
end

---------------
--COLOR EFFECTS
---------------

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
