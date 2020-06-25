AudioEngine = {
}

AudioEngine.playSound = function(sound)
    if(sound ~= nil) then
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

AudioEngine.getSound = function(soundName)
    return love.audio.newSource("assets/"..soundName, "stream")
end

AudioEngine.getLoop = function(loopName)
    local source =  love.audio.newSource("assets/"..loopName, "stream")
    source:setLooping(true);
    return source
end
