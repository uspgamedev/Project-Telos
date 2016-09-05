local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
--MODULE FOR THE GAMESTATE: GAME--

--ENEMIES--
local SB = require "classes.enemies.simple_ball"

--LEVEL FUNCTIONS--

local level1 = require "levels.level1"

--------------------

local state = {}

local p --Psycho

function state:enter()

    p = Psycho.create(ORIGINAL_WINDOW_WIDTH/2,ORIGINAL_WINDOW_HEIGHT/2)
    Level.start(level1)

end

function state:leave()

    Level.stop()
    Util.clearAllTables("remove")

end


function state:update(dt)

    --Change state if required
    if SWITCH == "PAUSE" then
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
    --Update other objects
    Util.updateSubTp(dt, "player_bullet")
    Util.updateSubTp(dt, "enemies")

    checkCollision()

    --Kill dead objects
    Util.killSubTp("player_bullet")
    Util.killSubTp("enemies")
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
    elseif key == 't' then
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
            if e:collides(p) then
                p:kill()
            end

        end
    end

end

--Return state functions
return state
