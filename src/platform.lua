require ("src/lib/vector")

Platform = {}

Platform.__index = Platform;

function Platform:new()
    local platform = {
        position = Vector:new(),
        height = 5,
        width = 20
    }
    setmetatable(platform, self)
    return platform
end

function Platform:getWidth()
    return self.width
end

function Platform:getHeight()
    return self.height
end

function Platform:getLeft()
    return self.position.x - self:getWidth() / 2
end

function Platform:getRight()
    return self.position.x + self:getWidth() / 2
end

function Platform:getBottom()
    return self.position.y + self:getHeight() / 2
end

function Platform:getTop()
    return self.position.y - self:getHeight() / 2
end