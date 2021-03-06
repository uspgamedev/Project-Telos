local Color = require "classes.color.color"
local Particle = require "classes.particle"
local Util = require "util"
local Blink = require "classes.blink_screen"
--EFFECTS CLASS --

local fx = {}

--------------------
--PARTICLE FUNCTIONS
--------------------

--Creates a colored article explosion starting at a circle with center (x,y) and radius r
function fx.explosion(x, y, r, color, number, speed, decaying, size, important, game_win_idx)
    local dir, angle, radius, batch, particle, number_of_particles

    game_win_idx = game_win_idx or 1

    --Default Values
    number = number or 25  --Number of particles created in a explosion
    speed  = speed    or 150  --Particles speed
    decaying = decaying or 400  --Particles decaying alpha speed (decreases this amunt per second, when reaching 0, it will be deleted)
    size = size or 4
    important = important or false --If an explosion is important, it will always be drawn intact, despite current number of particles already on screen

    number_of_particles = Util.tableLen(Util.findSbTp("decaying_particle"))

    --If current particles are already 75% of the max, half the number of particles being drawn
    if not important and number_of_particles >= .75* MAX_PARTICLES and number_of_particles < MAX_PARTICLES then
        number = math.floor(number/2)
    --If current particles already reached or exceded max number of particles, then don't explode
    elseif not important and number_of_particles >= MAX_PARTICLES then
        return
    end

    --Create as much particles it can before exceding the max
    if not important and number + number_of_particles > MAX_PARTICLES then
        number = math.max(0, MAX_PARTICLES - number_of_particles)
    end

    --Create a batch with endtime 5
    batch = Particle.create_batch(255/decaying + .05)

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

        particle = Particle.create_decaying(pos, dir, color, speed * (1 - love.math.random()*.5), decaying, size)
        if game_win_idx > 0 then
            particle.game_win_idx = game_win_idx
        end
        batch:put(particle)

    end

end

--Explode Psycho in a cool function when he dies
function fx.psychoExplosion(p)
    local d, multi, e, death_func, x, y, dir, pos, speed, c_pos, r, color, handle, part

    d = 2 --Duration of effect's first part (expansion)
    multi = 3 --Multiplier of speed in effects second part (going back)

    color = Color.white()
    Color.copy(color, p.color)

    e = 2 --Size of cell the grid will be created from
    r = 3 --Radius of particle explosion

    death_func = DEATH_FUNCS[love.math.random(#DEATH_FUNCS)] --Function to generate particle speed (and consequently, pattern)



    --Refrains player from interacting with psycho
    p.can_move = false
    p.can_shoot = false
    p.can_ultra = false
    p.can_charge = false

    --Config psycho so he disapears
    p.invisible = true
    p.invincible = true
    SLOWMO = true
    SLOWMO_M = .1


    ------------------------------
    --EFFECT FIRST PART: EXPANSION
    ------------------------------
    --Create several particles filling psycho's dead body, exploding in a random death_func pattern

    --Make everything "almost" black and white
    BLACK_WHITE_SHADER_FACTOR = 0
    local handle = FX_TIMER:tween(d, _G, {BLACK_WHITE_SHADER_FACTOR = .6}, 'in-linear')
    table.insert(DEATH_HANDLES, handle)

    --Lower sound when psycho is killed
    local bgm = Audio.getCurrentBGM()
    if bgm then
        Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL/5, d, false, true)
    end

    --Create explosion for each game_window
    for win_idx, win in ipairs(GAME_WINDOWS) do
        if win.active then
            c_pos = Vector(p.pos.x + win.x, p.pos.y + win.y) --Position of psycho's center

            --Create particles in a grid divided by 'e' distances
            --Each particle --olhar no git
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

                        part = Particle.create_regular(pos, dir, p.color, speed, r, win_idx, "psycho_explosion")
                        --Fade-out particles
                        part.color.a = 250
                        part.level_handles = LEVEL_TIMER:tween(d/6, part.color, {a = 0}, 'in-linear')
                    end
                end
            end
        end
    end

    --------------------------------
    --EFFECT SECOND PART: GOING BACK
    --------------------------------
    --Male all particles go back the way they expanded, but faster
    handle = FX_TIMER:after(d,
        function()

            --Make everything "normal colors" again
            local handle = FX_TIMER:tween(.7, _G, {BLACK_WHITE_SHADER_FACTOR = 0}, 'in-linear')
            table.insert(DEATH_HANDLES, handle)

            --Increase sound to normal levels again
            local bgm = Audio.getCurrentBGM()
            if bgm then
                Audio.fade(bgm, bgm:getVolume(), BGM_VOLUME_LEVEL, .7, false, true)
            end

            for part in pairs(Util.findSbTp("psycho_explosion")) do
                part.speed = -part.speed*multi
                --Fade-in particles
                part.level_handles = LEVEL_TIMER:tween((d/6)/multi, part.color, {a = 250}, 'in-linear')
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
            if not DONT_ENABLE_SHOOTING_AFTER_DEATH then
               p.can_shoot = true
            end
            if not DONT_ENABLE_ULTRA_AFTER_DEATH then
               p.can_ultra = true
            end
            if not DONT_ENABLE_MOVING_AFTER_DEATH then
               p.can_move = true
            end
            if not DONT_ENABLE_CHARGE_AFTER_DEATH then
               p.can_charge = true
            end

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


    local handle = LEVEL_TIMER:during(d,
                function()
                    CAM.x = orig_x + love.math.random(-str,str)
                    CAM.y = orig_y + love.math.random(-str,str)
                end
    )
    SHAKE_HANDLES[handle] = true
    LEVEL_TIMER:after(d,
                function()
                    SHAKE_HANDLES[handle] = nil
                    if Util.tableLen(SHAKE_HANDLES) <= 0 then
                      -- reset camera position to center screen if this is the last active shake effect
                      CAM.x = WINDOW_WIDTH/2
                      CAM.y = WINDOW_HEIGHT/2
                    end
                end
    )
end

--Moves a camera to target position with a given speed using a given tweening method (linear by default). Returns the handle for the tweening.
function fx.moveCamera(cam, target_x, target_y, speed, tweening)
    local target = Vector(target_x, target_y)
    local duration = target:dist(Vector(cam.x, cam.y))/speed
    tweening = tweening or "in-linear"

    return FX_TIMER:tween(duration, cam, {x = target.x, y = target.y}, tweening)
end

--Zooms the camera to target zoom in a given duration using a given tweening method (linear by default). Returns the handle for the tweening.
function fx.zoomCamera(cam, target_zoom, duration, tweening)
    tweening = tweening or "in-linear"

    return FX_TIMER:tween(duration, cam, {scale = target_zoom}, tweening)
end

--Rotates the camera to target rotation in a given duration using a given tweening method (linear by default). Returns the handle for the tweening.
function fx.rotateCamera(cam, target_rot, duration, tweening)
    local target = Vector(target_x, target_y)
    tweening = tweening or "in-linear"

    return FX_TIMER:tween(duration, cam, {rot = target_rot}, tweening)
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

----------------
--MOVEMENT EFFECTS--
----------------

--Given a table of objects, and a table of their initial positions, will rotate all of them in sync around in a circle, starting from the position given, rotating counter-clockwise.
--If you don't provide the initial positions, their current position will be used as the initial
--Objects will rotate around a point that will be "radius" distance to the left of the initial position of the objects
function fx.rotate_objects(objects, positions)
    local positions = positions or {}
    local radius = 5 --radius distance that the objects will rotate around from
    local speed = 10 --Speed that the objects will rotate around a point
    local duration = 2*math.pi*radius/speed --Duration of movement for each object, that represents the time until the object reaches the same angle it had

    --Cancel previously running effect
    if HIGHCORE_TEXT_EFFECT_HANDLE then
        FX_TIMER:cancel(HIGHCORE_TEXT_EFFECT_HANDLE)
    end

    --Get initial positions if they were not provided
    if Util.tableLen(positions) <= 0 then
        for i,k in ipairs(objects) do
            local pos = Vector(k.pos.x, k.pos.y)
            positions[i] = pos
        end
    end

    --Start applying effect on objects
    for i, ob in ipairs(objects) do

        if ob.death then return end --Stop function if any objects is killed

        --Cancel previously running effect
        if ob.handles["rotating_effect"] then
            FX_TIMER:cancel(ob.handles["rotating_effect"])
        end

        --Start rotating effect, that moves the position of object according to an angle (that will increase), a point to rotate around (based on object initial position) and radius of circle
        ob.handles["rotating_effect"] = FX_TIMER:during(duration,
            function(dt)
                ob.angle = ob.angle + speed*dt
                local center_of_circle = Vector(positions[i].x - radius, positions[i].y) --Point at which the object will rotate around of
                ob.pos.x = center_of_circle.x + math.cos(ob.angle)*radius
                ob.pos.y = center_of_circle.y + math.sin(ob.angle)*radius

            end)

    end

    HIGHCORE_TEXT_EFFECT_HANDLE = FX_TIMER:after(duration,
        function()
            if HIGHCORE_TEXT_EFFECT_HANDLE then

                --Cancel previously handle
                FX_TIMER:cancel(HIGHCORE_TEXT_EFFECT_HANDLE)
                HIGHCORE_TEXT_EFFECT_HANDLE = nil

                --Restart effect
                fx.rotate_objects(objects,positions)
            end
        end
    )
end

--Given a table of objects, a string "value_name" of the field you want to change, a table "target_values" with target values for each object(in the same order as the objects table), and a speed, it will make the tween for all objects of that field to the respective target value.
--It's advisable to provide a label for the handle stored in each object
--Provide a table that contains the handle tables for each object
--You can provide an optional argument for tweening method. If not provided, linear will be used.
--You can provide an optional argument "after_function" to execute after all effects are done
function fx.change_value_objects(objects, value_name, target_values, speed, label, handles_table, tweening_method, after_function)
    tweening_method = tweening_method or "in-linear"
    label = label or "changing_value_"..value_name

    local longest_duration = 0
    --Start applying effect on objects
    for i, ob in ipairs(objects) do

        --Calculate the duration of the effect based on the speed and differences between values
        local duration = math.abs(ob[value_name] - target_values[i])/speed
        if duration > longest_duration then
          longest_duration = duration
        end

        --Cancel previously running effect
        if handles_table[i][label] then
            FX_TIMER:cancel(handles_table[i][label])
        end

        --Create tweening effect for the object
        handles_table[i][label] = FX_TIMER:tween(duration, ob, {[value_name] = target_values[i]}, tweening_method)
    end

    if after_function then
      FX_TIMER:after(longest_duration, after_function)
    end

end

------------------
--MISC FUNCTIONS--
------------------

function fx.blink_screen(blank_dur, fade_out_dur)
    --Blink screen setup
    local blink = Blink()

    blink:addElement(DRAW_TABLE.L5u, nil, "blink_screen")

    blink.alpha = 150

    --Make it all white for a period of time
    LEVEL_TIMER:after(blank_dur,
        function()
            --Make it disappear
            LEVEL_TIMER:tween(fade_out_dur, blink, {alpha = 0}, "in-linear",
                function()
                    blink.death = true
                end
            )
        end
    )

end


--Return functions
return fx
