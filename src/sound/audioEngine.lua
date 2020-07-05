audioEngine = {
}

setmetatable(audioEngine, {__index = audioEngine})

audioEngine.playSound = function(sound, seek)
    if(sound ~= nil) then
        sound:seek(seek or 0, "samples")
        sound:play()
    end

end

audioEngine.playLoopOnce = function(loop)
    if(loop ~= nil and not(loop:isPlaying())) then
        loop:play()
    end
end

audioEngine.stopSound = function(sound)
    if(sound ~= nil) then
        sound:stop()
    end
end

audioEngine.pauseSound = function(sound)
    if(sound ~= nil) then
        sound:pause()
    end
end

audioEngine.getSound = function(soundName)
    return love.audio.newSource("assets/"..soundName, "stream")
end

audioEngine.getLoop = function(loopName)
    local source =  love.audio.newSource("assets/"..loopName, "stream")
    source:setLooping(true);
    return source
end