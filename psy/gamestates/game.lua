local Psycho = require "classes.psycho"
local Util = require "util"
local Draw = require "draw"
local Level = require "level_manager"
local Color = require "classes.color.color"
local Txt = require "classes.text"
local UltraCounter = require "classes.ultrablast_counter"
local LifeCounter = require "classes.life_counter"
local ScoreCounter = require "classes.score_counter"

--MODULE FOR THE GAMESTATE: GAME--

--LEVEL FUNCTIONS--
local Levels = {
    tutorial = require "levels.tutorial",
    level1 = require "levels.level1",
    level2 = require "levels.level2",
    level3 = require "levels.level3",
}

local garbage_collector_t = 0
local garbage_collector_max = .5
local _dt_limit = .02

--------------------

local state = {}

local p --Psycho

function state:enter(last_gs, go_to_level, go_to_part)
    local x, y, level, t
    love.mouse.setVisible(false) --Make cursor invisible
    love.mouse.setGrabbed(true) --Resume mouse capture

    if go_to_level then
      level = Levels[go_to_level]
    else
      level = Levels["level1"]
    end

    x, y = level.startPositions()

    if TUTORIAL then
      p = Psycho.create(x,y,true)
    else
      p = Psycho.create(x,y)
    end

    SLOWMO = false

    --Level part text
    Txt.create_game_gui(350, 10, "", GUI_MED, nil, nil, nil, "level_part")

    --Life counter
    LifeCounter.create(25, 20)

    --Separator 1
    Txt.create_game_gui(15, 55, "————", GUI_MEDPLUSPLUS, nil, nil, nil, "separator_1")

    --Ultrablast counter
    UltraCounter.create(36, 118)

    --Score counter
    ScoreCounter.create(10)

    level.setup() --Make title and start BGM

    if go_to_part then
      Level.start(level[go_to_part]) --Start desired part
    else
      Level.start(level.part_1) --Start first part of level
    end

end

function state:leave()

    Level.stop()

    --Don't remove background or fps counter
    Util.addExceptionId("background")
    Util.addExceptionId("fps_counter")
    Util.clearAllTables("remove")

    love.mouse.setVisible(true) --Make cursor visible
    love.mouse.setGrabbed(false) --Stop mouse capture


end

local lag = 0
local frame = 1/60
function state:update(dt)
    if dt > .12 then
        print("#############################")
        print("#############################")
        print("dt is high: "..dt)
        print("#############################")
        print("#############################")
    end

    local clock, dt_clock
    clock = love.timer.getTime()
    Util.updateTimers(dt)
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("update_timer", dt_clock) end
    clock = love.timer.getTime()
    Util.updateFPS()
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("updateFPS", dt_clock) end

    --Update psycho
    clock = love.timer.getTime()
    p:update(dt)
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("psycho", dt_clock) end

    --Update other objects (if slow mo, make them slow)
    local m_dt
    if SLOWMO then
        m_dt = dt*SLOWMO_M
    else
        m_dt = dt
    end

    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "player_bullet")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("player_bullet", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "enemies")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("enemies", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "cages")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("cages", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "bosses")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("bosses", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "decaying_particle")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("decaying_particle", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(dt, "psycho_explosion") --Are not affected by slowmo
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("psycho_explosion", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "particle_batch")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("particle_batch", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "enemy_indicator_batch")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("enemy_indicator_batch", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "growing_circle")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("growing_circle", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "enemy_indicator")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("enemy_indicator", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "rotating_indicator")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("rotating_indicator", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "ultrablast")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("ultrablast", dt_clock) end
    clock = love.timer.getTime()
    Util.updateSubTp(m_dt, "tutorial_icon")
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("tutorial_icon", dt_clock) end
    clock = love.timer.getTime()
    Util.updateId(dt, "psycho_aim") --Is not affected by slowmo
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("psycho_aim", dt_clock) end
    clock = love.timer.getTime()
    Util.updateId(dt, "ultrablast_counter") --Is not affected by slowmo
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("ultra_blast_counter", dt_clock) end
    clock = love.timer.getTime()
    Util.updateId(dt, "life_counter") --Is not affected by slowmo
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("life_counter", dt_clock) end
    clock = love.timer.getTime()
    Util.updateId(dt, "score_counter") --Is not affected by slowmo
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("score_counter", dt_clock) end
    clock = love.timer.getTime()
    Util.checkCollision()
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("collision", dt_clock) end
    clock = love.timer.getTime()

    --Kill dead objects
    Util.killAll()
    dt_clock = love.timer.getTime() - clock
    if dt_clock > _dt_limit then print("kill_all", dt_clock) end
    clock = love.timer.getTime()

    --Change state if required
    if SWITCH == "PAUSE" or not FOCUS then

        SWITCH = nil
        Gamestate.push(GS.PAUSE)
    elseif SWITCH == "GAMEOVER" then

        SWITCH = nil
        Util.gameElementException("GAMEOVER")

        Gamestate.switch(GS.GAMEOVER)
    end

end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)
    local x, y

    p:keypressed(key) --Key handling of psycho

    if key == 'escape' or key == 'p' then --Pause game
        SWITCH = "PAUSE"
    elseif key == 'x' then
        p = Util.findId("psycho")
        if p.can_ultra then
            p:ultrablast(p.default_ultrablast_power)
        end
    elseif key == '0' then
      Util.toggleGODMODE()
    elseif key == '4' then
      p = Util.findId("psycho")
      if p and not p.death then
        p:kill()
      end
    elseif key == '5' then
      Util.countDrawables()
    elseif key == '6' then
      p = Util.findId("psycho")
      print("psycho position",p.pos.x, p.pos.y)
    elseif key == '7' then
      p = Util.findId("psycho")
      p.ultrablast_counter = MAX_ULTRABLAST
    elseif key == '8' then
      p = Util.findId("psycho")
      p.lives = 1
    elseif key == '9' then
        p = Util.findId("psycho")
        p.lives = p.lives + 10
    else
        Util.defaultKeyPressed(key)
    end

end

function state:keyreleased(key)

    p:keyreleased(key) --Key handling of psycho

end

function state:mousepressed(x, y, button, istouch)
    local p

    --Secondary mouse button unleashes an ultrablast
    if button == 2 then
        p = Util.findId("psycho")
        if p and p.can_ultra then
            p:ultrablast(p.default_ultrablast_power)
        end
    end

end

function state:joystickaxis(joystick, axis, value)
    local p = Util.findId("psycho")
    if p then
      p:joystickaxis(joystick, axis, value)
    end
end

function state:joystickpressed(joystick, button)

  if button == Controls.getCommand("start") then
      SWITCH = "PAUSE"
  end

  local p = Util.findId("psycho")
  if p then
    p:joystickpressed(joystick, button)
  end

end

function state:joystickreleased(joystick, button)

  local p = Util.findId("psycho")
  if p then
    p:joystickreleased(joystick, button)
  end

end

function state:getCurrentSelectedButton()
    return
end
function state:setCurrentSelectedButton(but)
  return
end

--Return state functions
return state
