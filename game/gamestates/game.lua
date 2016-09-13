local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Color = require "classes.color.color"
local Txt = require "classes.text"
--MODULE FOR THE GAMESTATE: GAME--

--ENEMIES--
local SB = require "classes.enemies.simple_ball"

--LEVEL FUNCTIONS--

local level1 = require "levels.level1"

--------------------

local state = {}

local p --Psycho

function state:enter()

    p = Psycho.create()

    SLOWMO = false

    --Level part text
    Txt.create_gui(200, 10, "Part PI: Eletric Boogaloo", GUI_MED, nil, nil, nil, "level_part")

    --Lives counter text
    Txt.create_gui(5, 10, "lives: ", GUI_MED, p.lives, "down", GUI_MEDPLUS, "lives_counter")

    Level.start(level1)

end

function state:leave()

    Level.stop()
    Util.addExceptionId("background")
    Util.clearAllTables("remove")

end


function state:update(dt)
    local m_dt

    --Change state if required
    if SWITCH == "PAUSE" or not FOCUS then
        SWITCH = nil
        Gamestate.push(GS.PAUSE)
    elseif SWITCH == "GAMEOVER" then
        SWITCH = nil
        Util.gameElementException("GAMEOVER")

        Gamestate.switch(GS.GAMEOVER)
    end

    Util.updateTimers(dt)

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
    Util.updateSubTp(m_dt, "decaying_particle")
    Util.updateSubTp(dt, "psycho_explosion") --Are not affected by slowmo
    Util.updateSubTp(m_dt, "particle_batch")

    checkCollision()

    --Kill dead objects
    Util.killSubTp("player_bullet")
    Util.killSubTp("enemies")
    Util.killSubTp("decaying_particle")
    Util.killSubTp("psycho_explosion")
    Util.killSubTp("particle_batch")
    Util.killSubTp("gui")
    Util.killId("psycho")


end

function state:draw()

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
                    if e:collides(bullet) then
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

end

--Return state functions
return state
