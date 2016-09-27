--MODULE FOR AUDIO STUFF--

local audio = {}

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

function audio.playBGM(bgm)

    --Remove any timers still going
    if FADE_IN_HANDLE then
        AUDIO_TIMER:cancel(FADE_IN_HANDLE)
    end
    if FADE_OUT_HANDLE then
        AUDIO_TIMER:cancel(FADE_OUT_HANDLE)

    end
    if AUDIO_TIMER_HANDLE then
        AUDIO_TIMER:cancel(AUDIO_TIMER_HANDLE)
        SOUNDTRACK["current"]:stop()
        SOUNDTRACK["current"] = SOUNDTRACK["next"]
        SOUNDTRACK["next"] = nil
    end

    if not SOUNDTRACK["current"] then
        bgm:play()
        bgm:setLooping(true)
        audio.fade_in(bgm, 0, BGM_VOLUME_LEVEL, 2)
        SOUNDTRACK["current"] = bgm
    else
        bgm:play()
        bgm:setLooping(true)
        audio.fade_in(bgm, 0, BGM_VOLUME_LEVEL, 2)
        audio.fade_out(SOUNDTRACK["current"], SOUNDTRACK["current"]:getVolume(), 0, .2)
        SOUNDTRACK["next"] = bgm
        AUDIO_TIMER_HANDLE = AUDIO_TIMER:after(2,
            function()
               SOUNDTRACK["current"]:stop()
               SOUNDTRACK["current"] = SOUNDTRACK["next"]
               SOUNDTRACK["next"] = nil
            end
        )
    end
end

--Remove any sfx that have ended
function audio.cleanupSFX()
    for i,sfx in pairs(SFX) do
        if sfx:isStopped() then
            SFX[i] = nil
        end
    end
end

--Fade an audio source in d seconds, from value ini to fin
function audio.fade_in(s, ini, fin, d)
    local delay, rate

    s:setVolume(ini)
    d = d or 1
    delay = .01
    rate = (fin-ini)/(d/delay)
    if FADE_IN_HANDLE then
        AUDIO_TIMER:cancel(FADE_IN_HANDLE)
    end
    FADE_IN_HANDLE = AUDIO_TIMER:every(delay,
        function()
            s:setVolume(s:getVolume() + rate)
        end,
    d/delay)
end

--Fade an audio source in d seconds, from value ini to fin
function audio.fade_out(s, ini, fin, d)
    local delay, rate

    s:setVolume(ini)
    d = d or 1
    delay = .01
    rate = (fin-ini)/(d/delay)

    if FADE_OUT_HANDLE then
        AUDIO_TIMER:cancel(FADE_OUT_HANDLE)
    end
    FADE_OUT_HANDLE = AUDIO_TIMER:every(delay,
        function()
            s:setVolume(s:getVolume() + rate)
        end,
    d/delay)

end


--Return functions
return audio
