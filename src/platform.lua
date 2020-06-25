require ("src/lib/vector")
require ("src/lib/rectangle")

Platform = {}

Platform.__index = Platform;

function Platform:new()
    local platform = {
        position = Vector.new(),
        height = 0,
        width = 0,
        sprite = love.graphics.newImage("assets/images/platform.png"),
        collider = {}
    }
    platform.width = platform.sprite:getWidth()
    platform.height = platform.sprite:getHeight()

    platform.collider = Rectangle.new(0, 5, 32, 13)

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
    return self.position.x + self.collider:getLeft()
end

function Platform:getRight()
    return self.position.x + self.collider:getRight()
end

function Platform:getBottom()
    return self.position.y + self.collider:getBottom()
end

function Platform:getTop()
    return self.position.y + self.collider:getTop()
end

function Platform:draw()
    return love.graphics.draw(self.sprite, self.position.x, self.position.y)
end