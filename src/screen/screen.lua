Screen = {}

Screen.__index = Screen;

function Screen.new()
    local s = {};
    setmetatable(s, Screen)
    return s;
end

function Screen:update(dt)
end

function Screen:draw()
end

function Screen:reset()
end

function Screen:keyPressed(key)
end