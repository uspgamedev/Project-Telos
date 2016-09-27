local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Color = require "classes.color.color"
local Txt = require "classes.text"
local Audio = require "audio"
--MODULE FOR THE GAMESTATE: GAME--

--ENEMIES--
local SB = require "classes.enemies.simple_ball"

--LEVEL FUNCTIONS--

local level1 = require "levels.level1"
local level2 = require "levels.level2"

--------------------

local state = {}

local p --Psycho

function state:enter()

    p = Psycho.create(662,424)

    SLOWMO = false

    --Level part text
    Txt.create_game_gui(200, 10, "Part PI: Eletric Boogaloo", GUI_MED, nil, nil, nil, "level_part")

    --Lives counter text
    Txt.create_game_gui(5, 10, "lives: ", GUI_MED, p.lives, "down", GUI_MEDPLUS, "lives_counter")

    Level.start(level1)


end

function state:leave()

    Level.stop()
    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

end


function state:update(dt)
    local m_dt

    --Change state if required
    if SWITCH == "PAUSE" or not FOCUS then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Gamestate.push(GS.PAUSE)
    elseif SWITCH == "GAMEOVER" then
        --Make use of canvas so screen won't blink
        USE_CANVAS = true
        Draw.allTables()

        SWITCH = nil
        Util.gameElementException("GAMEOVER")

        Gamestate.switch(GS.GAMEOVER)
    end

    Audio.cleanupSFX() --Remove sfx that have ended

    Util.updateTimers(dt)

    Util.updateFPS()

    --Update psycho
    p:update(dt)

    --Update other objects (if slow mo, make them slow)
    if SLOWMO then
        m_dt = dt*SLOWMO_M
    else
        m_dt = dt
    end

    Util.updateSubTp(m_dt, "player_bullet")
    Util.updateSubTp(m_dt, "enemies")
    Util.updateSubTp(m_dt, "bosses")
    Util.updateSubTp(m_dt, "decaying_particle")
    Util.updateSubTp(dt, "psycho_explosion") --Are not affected by slowmo
    Util.updateSubTp(m_dt, "particle_batch")
    Util.updateSubTp(m_dt, "growing_circle")
    Util.updateSubTp(m_dt, "enemy_indicator")
    Util.updateSubTp(m_dt, "rotating_indicator")
    Util.updateId(dt, "psycho_aim") --Is not affected by slowmo

    checkCollision()

    --Kill dead objects
    Util.killAll()


end

function state:draw()

    --Stop using canvas
    if USE_CANVAS then
        USE_CANVAS = false
        SCREEN_CANVAS = nil
        love.graphics.clear()
    end

    Draw.allTables()

end

function state:keypressed(key)
    local x, y
    p:keypressed(key) --Key handling of psycho

    if key == 'escape' or key == 'p' then --Pause game
        SWITCH = "PAUSE"
    elseif key == 'o' then
        x = 50 + love.math.random()*(ORIGINAL_WINDOW_WIDTH-100)
        y = 50 + love.math.random()*(ORIGINAL_WINDOW_HEIGHT-100)
        SB.create(x, y)
    else
        Util.defaultKeyPressed(key)
    end

end

function state:keyreleased(key)

    p:keyreleased(key) --Key handling of psycho

end

--Makes all collisions
function checkCollision()

    if SUBTP_TABLE["enemies"] then

        for e in pairs(SUBTP_TABLE["enemies"]) do

            --Checking player bullet collision
            if SUBTP_TABLE["player_bullet"] then
                for bullet in pairs(SUBTP_TABLE["player_bullet"]) do
                    if not bullet.death and e:collides(bullet) then
                        e:kill()
                        bullet:kill()
                    end
                end
            end

            --Colliding with psycho
            if not p.invincible and e:collides(p) then
                p:kill()
            end

        end
    end

    --Colliding player bullets with bosses
    if SUBTP_TABLE["player_bullet"] then
        for bullet in pairs(SUBTP_TABLE["player_bullet"]) do
            if SUBTP_TABLE["bosses"] then
                for boss in pairs(SUBTP_TABLE["bosses"]) do
                    if not bullet.death and bullet:collides(boss) then
                        bullet:kill()
                        if not boss.invincible then boss:getHit() end
                    end
                end
            end
        end
    end

    --Colliding bosses with psycho
    if SUBTP_TABLE["bosses"] then
        for boss in pairs(SUBTP_TABLE["bosses"]) do
            --Colliding with psycho
            if not p.invincible and boss:collides(p) then
                p:kill()
            end
        end
    end

end

--Return state functions
return state
