local Color = require "classes.color.color"
local Particle = require "classes.particle"
local Util = require "util"
--EFFECTS CLASS --

local fx = {}

--------------------
--PARTICLE FUNCTIONS
--------------------

--Creates a colored article explosion starting at a circle with center (x,y) and radius r
function fx.explosion(x, y, r, color, number, speed, decaying, size)
    local dir, angle, radius, batch, particle
    --Default Values
    number = number or 15  --Number of particles created in a explosion
    speed    = speed    or 150  --Particles speed
    decaying = decaying or .99  --Particles decaying alpha speed (when reaching 0, it will be deleted)
    size = size or 4

    --Create a batch with endtime 5
    batch = Particle.create_batch(1)

    --Creates all particles of explosion
    for i=1, number do

        --Randomize direction for each particle (value between [-1,1])
        dir = Vector(0,0)
        dir.x = love.math.random()*2 - 1
        dir.y = love.math.random()*2 - 1
        --Randomize position inside the given circle
        angle = 2*math.pi*love.math.random()
        radius = 2*r*love.math.random()
        if radius > r then
            radius = 2*r-radius
        end
        pos = Vector(0,0)
        pos.x = x + radius*math.cos(angle)
        pos.y = y + radius*math.sin(angle)

        particle = Particle.create_decaying(pos, dir, color, speed, decaying, size)
        batch:put(particle)

    end

end

--Explode Psycho in a cool function when he dies
function fx.psychoExplosion(p)
    local d, multi, e, death_func, x, y, dir, pos, speed, c_pos, r, color, handle

    d = 2 --Duration of effect's first part (expansion)
    multi = 3 --Multiplier of speed in effects second part (going back)

    color = Color.white()
    Color.copy(color, p.color)

    e = 1.5 --Size of cell the grid will be created from
    r = 3 --Radius of particle explosion

    death_func = DEATH_FUNCS[love.math.random(#DEATH_FUNCS)] --Function to generate particle speed (and consequently, pattern)

    --Config psycho so he just disapears
    p.controlsLocked = true --Refrains player from interacting with psycho
    p.invisible = true
    p.invincible = true
    SLOWMO = true
    SLOWMO_M = .1
    ------------------------------
    --EFFECT FIRST PART: EXPANSION
    ------------------------------
    --Create several particles filling psycho's dead body, exploding in a random death_func pattern


    c_pos = Vector(p.pos.x, p.pos.y) --Position of psycho's center

    --Create particles in a grid divided by 'e' distances
    --Each particleadasa
    for x = c_pos.x - p.r, c_pos.x + p.r - e, e do
        for y = c_pos.y - p.r, c_pos.y + p.r - e, e do
            --If inside psycho radius, and not dead center, create particle
            if (x+e/2 - c_pos.x)*(x+e/2 - c_pos.x) + (y+e/2 - c_pos.y)*(y+e/2 - c_pos.y) <= p.r*p.r
            and x+e/2 ~= c_pos.x and y+e/2 ~= c_pos.y then
                --Makes the particle go outwards
                dir = Vector(x+e/2 - c_pos.x, y+e/2 - c_pos.y)
                dir = dir:normalized()

                pos = Vector(x + e/2, y + e/2)
                speed = death_func(pos, c_pos, p.r)

                Particle.create_regular(pos, dir, p.color, speed, r, "psycho_explosion")
            end
        end
    end

    --------------------------------
    --EFFECT SECOND PART: GOING BACK
    --------------------------------
    --Male all particles go back the way they expanded, but faster
    handle = FX_TIMER:after(d,
        function()
            for part in pairs(Util.findSbTp("psycho_explosion")) do
                part.speed = -part.speed*multi
            end
        end
    )
    table.insert(DEATH_HANDLES, handle)
    -----------------------------------
    --EFFECT LAST PART: REVIVING PSYCHO
    -----------------------------------
    handle = FX_TIMER:after(d + d/multi,
        function()

            --Removes slowmotion effect
            SLOWMO = false

            --Remove particles
            for part in pairs(Util.findSbTp("psycho_explosion")) do
                part.death = true
            end

            --Fix psycho for invincible-blinking effect
            p.controlsLocked = false
            p.invisible = false
            Color.copy(p.color, color) --Make psycho the particles color
            p:startInvincible()
        end
    )
    table.insert(DEATH_HANDLES, handle)
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

    LEVEL_TIMER.during(d,
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

function fx.colorLoop(o, color_var)
    local color_target, func, handle, d

    color_target = o:getDiffRandColor()
    d = o.color_duration

    func = "in-linear"
    fx.colorTransition(o, color_var, color_target, func)
    handle = COLOR_TIMER:after(d+.1,
        function()
            fx.colorLoop(o, color_var)
        end
    )
    table.insert(o.handles, handle)
end
----------------------
--TRANSITION FUNCTIONS
----------------------
--Tween model:
--FX_TIMER:tween(duration, o, {var = f}, func)

--Make a smooth transition in an objects o.color_var to color_target
--USES HSL
function fx.colorTransition(o, color_var, color_target, func)

    --HSL transition
    if o[color_var] then
        table.insert(o.handles, COLOR_TIMER:tween(o.color_duration, o[color_var], {h = color_target.h}, func))

        table.insert(o.handles, COLOR_TIMER:tween(o.color_duration, o[color_var], {s = color_target.s}, func))

        table.insert(o.handles, COLOR_TIMER:tween(o.color_duration, o[color_var], {l = color_target.l}, func))
    else
        print("COLOR TRANSITION ERROR")
    end
end

--Return fucntions
return fx
