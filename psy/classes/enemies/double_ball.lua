require "classes.primitive"
local Color = require "classes.color.color"
local Hsl   = require "classes.color.hsl"
local Util = require "util"
local LM = require "level_manager"

--DOUBLE BALL CLASS--
--[[Simple red circle enemy that spawns simple balls when it dies]]

--Local functions

local isInside

-- Enemy functions

local enemy = {}

Double_Ball = Class{
    __includes = {ENEMY},
    init = function(self, _x, _y, _dir, _speed_m, _radius, _score_mul, _game_win_idx)
        local dx, dy, r, color, color_table

        color_table = {
            HSL(Hsl.stdv(0,100,44.9)), --Ku Crimson
            HSL(Hsl.stdv(14,100,46)), --Coquelicot
            HSL(Hsl.stdv(1,84,55)), --Deep Carmine Red
            HSL(Hsl.stdv(12,100,38.8)) --Candy Apple Red
        }


        ENEMY.init(self,  _x, _y, _dir, _speed_m, _radius, _score_mul, color_table, 270, 35, _game_win_idx)

        self.tp = "double_ball" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Double_Ball:kill(gives_score, mode, dont_explode)
    local e

    if self.death then return end

    self.death = true

    if gives_score == nil then gives_score = true end --If this enemy should give score

    if not dont_explode then
      FX.explosion(self.pos.x, self.pos.y, self.r, self.color, nil, nil, nil, nil, nil, self.game_win_idx)
    end

    if gives_score then
        if self.score_value*self.score_mul > 0 then
            LM.giveScore(math.ceil(self.score_value*self.score_mul))
        end

        FX.shake(.1,.1)

        SFX.hit_double:play()

    end

    if mode ~= "dontspawn" then
        --Create two Simple Balls in a V shape
        e = SB.create(self.pos.x, self.pos.y, self.speed:rotated(math.pi/12), 1.12*self.speed_m, .75*self.r, .5*self.score_mul, self.game_win_idx)
        e.enter = true
        e = SB.create(self.pos.x, self.pos.y, self.speed:rotated(-math.pi/12), 1.12*self.speed_m, .75*self.r, .5*self.score_mul, self.game_win_idx)
        e.enter = true
    end

end

--Update this enemy
function Double_Ball:update(dt)
    local o

    o = self

    --Update movement
    o.pos = o.pos + dt*o.speed*o.speed_m

    --Check if enemy entered then leaved the game screen
    if not o.enter then
        if isInside(o) then o.enter = true end
    else
        if not isInside(o) then o:kill(false, "dontspawn", true) end --Don't give score or spawn if enemy is killed by leaving screen
    end

end

--UTILITY FUNCTIONS--

function enemy.create(x, y, dir, speed_m, radius, score_mul, game_win_idx)
    local e

    e = Double_Ball(x, y, dir, speed_m, radius, score_mul, game_win_idx)
    e:addElement(DRAW_TABLE.L4)
    e:startColorLoop()

    return e
end

--Return this enemy radius
function enemy.radius()
    return 20
end

--Return the color for this enemy indicator
function enemy.indColor()
    return HSL(Hsl.stdv(1,84,55))
end

--Return the default score this enemy gives when killed
function enemy.score()
    return 35
end

--LOCAL FUNCTION--

--Checks if a circular enemy has entered (even if partially) inside the game screen
function isInside(o)

    local win = WINM.getWin(o.game_win_idx)
    if    o.pos.x + o.r >= win.x
      and o.pos.x - o.r <= win.x + win.w
      and o.pos.y + o.r >= win.y
      and o.pos.y - o.r <= win.y + win.h
      then
          return true
      end

    return false
end

--return function
return enemy
