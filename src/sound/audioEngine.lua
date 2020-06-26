AudioEngine = {
}

setmetatable(AudioEngine, {__index = AudioEngine})

AudioEngine.playSound = function(sound, seek)
    if(sound ~= nil) then
        sound:seek(seek or 0, "samples")
        sound:play()
    end

end

AudioEngine.playLoopOnce = function(loop)
    if(loop ~= nil and not(loop:isPlaying())) then
        loop:play()
    end
end

AudioEngine.stopSound = function(sound)
    if(sound ~= nil) then
        sound:stop()
    end
end

AudioEngine.pauseSound = function(sound)
    if(sound ~= nil) then
        sound:pause()
    end
end

AudioEngine.getSound = function(soundName)
    return love.audio.newSource("assets/"..soundName, "stream")
end

AudioEngine.getLoop = function(loopName)
    local source =  love.audio.newSource("assets/"..loopName, "stream")
    source:setLooping(true);
    return source
end