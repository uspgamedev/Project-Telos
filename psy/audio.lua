--MODULE FOR AUDIO STUFF--

local audio = {}

local _current_bgm
local _current_bgm_volume_handles = {}
local _current_bgm_pitch_handle

-----------------------
--SFX AUDIO FUNCTIONS--
-----------------------

--Update all current sfxs volume
function audio.updateSFX()
    for _,sfx in pairs(SFX) do
        sfx:setVolume(SFX_VOLUME_MULT)
    end
end

--Play all current sfxs
function audio.resumeSFX()
    for _,sfx in pairs(SFX) do
        sfx:resume()
    end
end

--Pause all current sfxs
function audio.pauseSFX()
    for _,sfx in pairs(SFX) do
        sfx:pause()
    end
end

--Stop all current sfxs
function audio.stopSFX()
    for _,sfx in pairs(SFX) do
        sfx:stop()
    end
end

local enemy_hit_index = 1
local enemy_hit_max = 7
--Play sfx for enemy hit
function audio.enemyHit()
    SFX["hit_simple"..enemy_hit_index]:play()
    enemy_hit_index = math.min(enemy_hit_index+1, enemy_hit_max)
end
-----------------------
--BGM AUDIO FUNCTIONS--
-----------------------

--Start playing given bgm with a loop, crossfading with previous current bgm
--Optional fade_in_d and fade_out_d for fade-in/fade-ou durations on crossfade
--Optional start_pos to determine what position to start the bgm
function audio.playBGM(bgm, fade_out_d, fade_in_d, start_pos)
    fade_in_d = fade_in_d or 2.5
    fade_out_d = fade_out_d or .5
    start_pos = start_pos or 0

    if not _current_bgm then
        _current_bgm = bgm:play()
        _current_bgm:setLooping(true)
        _current_bgm:seek(start_pos)
        audio.fade(bgm, 0, BGM_VOLUME_LEVEL, fade_in_d, nil, true)
    else
        --Fades out previous bgm
        audio.fadeOutCurrentBGM(fade_out_d)
        --Fade in new bgm
        _current_bgm = bgm:play()
        _current_bgm:setLooping(true)
        _current_bgm:seek(start_pos)
        audio.fade(_current_bgm, 0, BGM_VOLUME_LEVEL, fade_in_d, false, true)
    end
end

function audio.getCurrentBGM()
    return _current_bgm
end

--Fades and removes the current bgm in d seconds
function audio.fadeOutCurrentBGM(d)
    if not _current_bgm then return end
    d = d or .5
    for _, handle in pairs(_current_bgm_volume_handles) do --Remove all previous effects applied to the current song
        AUDIO_TIMER:cancel(handle)
    end
    audio.fade(_current_bgm, _current_bgm:getVolume(), 0, d, true)
    _current_bgm = nil
    _current_bgm_volume_handles = {}
end

--Tween current bgm pitch to target value in d seconds
function audio.tweenCurrentBGMPitch(target, d)

    if not _current_bgm then return end
    if _current_bgm_pitch_handle then
        AUDIO_TIMER:cancel(_current_bgm_pitch_handle)
    end

    local bgm = _current_bgm

    delay = .01
    rate = (target-bgm:getPitch())/(d/delay)
    _current_bgm_pitch_handle = AUDIO_TIMER:every(delay,
        function()
            bgm:setPitch(bgm:getPitch() + rate)
        end,
    d/delay)

end

---------------------------
--GENERAL AUDIO FUNCTIONS--
---------------------------

--Fade an audio source in d seconds, from value ini to fin
--If optional argument stop is true, it will stop the song after the fade
--If optional argument is_current_bgm is true, it will store the handles on the current_bgm_handles table
function audio.fade(s, ini, fin, d, stop, is_current_bgm)
    local delay, rate

    s:setVolume(ini)
    d = d or 1
    delay = .01
    rate = (fin-ini)/(d/delay)
    local h1 = AUDIO_TIMER:every(delay,
        function()
            s:setVolume(s:getVolume() + rate)
        end,
    d/delay)
    if stop then
        local h2 = AUDIO_TIMER:after(d + delay, function() s:stop() end)
    end

    if is_current_bgm then
        table.insert(_current_bgm_volume_handles, h1)
        if h2 then table.insert(_current_bgm_volume_handles, h1) end
    end
end


--Return functions
return audio
