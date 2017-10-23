--MODULE FOR AUDIO STUFF--

local audio = {}

local _current_bgm
local _current_bgm_handles = {}
----------------------
--BASIC AUDIO FUNCTIONS
----------------------

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

--Start playing given bgm with a loop, crossfading with previous current bgm
--Optional fade_in_d and fade_out_d for fade-in/fade-ou durations on crossfade
--Optional start_pos to determine what position to start the bgm
function audio.playBGM(bgm, fade_out_d, fade_in_d, start_pos)
    fade_in_d = fade_in_d or 2
    fade_out_d = fade_out_d or .5
    start_pos = start_pos or 0

    if not _current_bgm then
        _current_bgm = bgm:play()
        _current_bgm:setLooping(true)
        _current_bgm:seek(start_pos)
        local handle = audio.fade(bgm, 0, BGM_VOLUME_LEVEL, fade_in_d)
        table.insert(_current_bgm_handles, handle)
    else
        --Fades out previous bgm
        for _, handle in pairs(_current_bgm_handles) do
            AUDIO_TIMER:cancel(handle)
        end
        audio.fade(_current_bgm, _current_bgm:getVolume(), 0, fade_out_d, true, true)
        --Fade in new bgm
        _current_bgm_handles = {}
        _current_bgm = bgm:play()
        _current_bgm:setLooping(true)
        _current_bgm:seek(start_pos)
        local handle = audio.fade(_current_bgm, 0, BGM_VOLUME_LEVEL, fade_in_d)
        table.insert(_current_bgm_handles, handle)
    end
end

--Fade an audio source in d seconds, from value ini to fin
--If optional argument stop is true, it will stop the song after the fade
function audio.fade(s, ini, fin, d, stop, debug)
    local delay, rate

    s:setVolume(ini)
    d = d or 1
    delay = .01
    rate = (fin-ini)/(d/delay)
    local h1 = AUDIO_TIMER:every(delay,
        function()
            s:setVolume(s:getVolume() + rate)
            if debug then print(s:getVolume()) end
        end,
    d/delay)
    if stop then
        local h2 = AUDIO_TIMER:after(d + delay, function() print(s:getVolume(),"stopped");s:stop() end)
    end

    return h1, h2
end

function audio.getCurrentBGM()
    return _current_bgm
end


--Return functions
return audio
