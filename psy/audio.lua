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
        audio.fade(bgm, 0, BGM_VOLUME_LEVEL, fade_in_d, nil, true)
    else
        --Fades out previous bgm
        for _, handle in pairs(_current_bgm_handles) do --Remove all previous effects applied to the current song
            AUDIO_TIMER:cancel(handle)
        end
        audio.fade(_current_bgm, _current_bgm:getVolume(), 0, fade_out_d, true)
        --Fade in new bgm
        _current_bgm_handles = {} --Reset handles
        _current_bgm = bgm:play()
        _current_bgm:setLooping(true)
        _current_bgm:seek(start_pos)
        audio.fade(_current_bgm, 0, BGM_VOLUME_LEVEL, fade_in_d, false, true)
    end
end

--Fade an audio source in d seconds, from value ini to fin
--If optional argument stop is true, it will stop the song after the fade
--If optional argument is_bgm is true, it will store the handles on the current_bgm_handles table
function audio.fade(s, ini, fin, d, stop, is_bgm)
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

    if is_bgm then
        table.insert(_current_bgm_handles, h1)
        if h2 then table.insert(_current_bgm_handles, h1) end
    end
end

function audio.getCurrentBGM()
    return _current_bgm
end


--Return functions
return audio
