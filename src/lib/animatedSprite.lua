require ("src/lib/vector")

AnimatedSprite = {}
AnimatedSprite.__index = AnimatedSprite;

function AnimatedSprite.new(spriteSheet, frameWidth, frameHeight, frameCount, timePerFrame, origin)
    local sprite = {
        currentFrame = 1,
        timePerFrame = timePerFrame or (1 / 60),
        currentTime = 0,
        frameCount = frameCount,
        spriteSheet = spriteSheet,
        width = frameWidth,
        height = frameHeight,
        quads = {},
        origin = origin or Vector.new()
    }
    sprite.currentTime = sprite.timePerFrame;
    setmetatable(sprite, AnimatedSprite)

    sprite:initializeQuads()
    return sprite
end

function AnimatedSprite:update(dt)
    self.currentTime = self.currentTime - dt;
    if (self.currentTime > 0) then return end

    self.currentFrame = self.currentFrame + 1;
    self.currentTime = self.currentTime + self.timePerFrame
    if(self.currentFrame > self.frameCount) then
        self.currentFrame = 1;
    end
end

function AnimatedSprite:draw(position, rotation)
    love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], position.x, position.y, rotation or 0, 1, 1, self.origin.x + 30, self.origin.y + 13)
end

function AnimatedSprite:initializeQuads()
    local quadCounter = self.frameCount;
    for y = 0, self.spriteSheet:getHeight() - self.height, self.height do
        for x = 0, self.spriteSheet:getWidth() - self.width, self.width do
            table.insert(self.quads, love.graphics.newQuad(x, y, self.width, self.height, self.spriteSheet:getDimensions()))
            quadCounter = quadCounter - 1
            if (quadCounter <= 0) then
                return;
            end
        end
    end
end