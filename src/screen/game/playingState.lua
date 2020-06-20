PlayingState = {}
PlayingState.__index = PlayingState;

function PlayingState:new(gameScreen)
    local state = {
        screen = gameScreen,
        gravity = Vector:new(0, 2),
        debug = false,
        isColliding = false,
        angleThreshold = 5,
        speedThreshold = 1,
    }
    setmetatable(state, PlayingState)
    return state
end

function PlayingState:reset()
    self.screen.spacecraft.position = Vector:new((window.x - self.screen.spacecraft:getWidth()) / 2, (window.y - self.screen.spacecraft:getHeight()) / 2)
    self.screen.spacecraft.velocity = Vector:new();
    self.screen.spacecraft:setEngineOn(false);
    self.screen.spacecraft.angle = math.rad(270);

    self.screen.platform.position.y = window.y - self.screen.platform.height;
    self.screen.platform.position.x = math.random( 0, window.x - self.screen.platform.width )
end

function PlayingState:update(dt)
    if (not(self.screen.spacecraft:isFlying())) then
        return;
    end

    self.screen.spacecraft.velocity.x = self.screen.spacecraft.velocity.x + self.gravity.x * dt
    self.screen.spacecraft.velocity.y = self.screen.spacecraft.velocity.y + self.gravity.y * dt

    if (love.keyboard.isDown("space")) then
        self.screen.spacecraft:setEngineOn(true);
        self.screen.spacecraft.velocity.x = self.screen.spacecraft.velocity.x + math.cos(self.screen.spacecraft.angle) * self.screen.spacecraft.thrustPower * dt;
        self.screen.spacecraft.velocity.y = self.screen.spacecraft.velocity.y + math.sin(self.screen.spacecraft.angle) * self.screen.spacecraft.thrustPower * dt;
    else
        self.screen.spacecraft:setEngineOn(false);
    end

    if (love.keyboard.isDown("left")) then
        self.screen.spacecraft.angle = self.screen.spacecraft.angle - self.screen.spacecraft.angularSpeed * dt
    elseif (love.keyboard.isDown("right")) then
        self.screen.spacecraft.angle = self.screen.spacecraft.angle + self.screen.spacecraft.angularSpeed * dt
    end

    if (self.screen.spacecraft.angle < 0) then
        self.screen.spacecraft.angle = self.screen.spacecraft.angle + math.pi * 2
    elseif self.screen.spacecraft.angle > math.pi * 2 then
        self.screen.spacecraft.angle = self.screen.spacecraft.angle - math.pi * 2
    end

    if (self.screen.spacecraft.velocity:squareLength() > self.screen.spacecraft.maxSpeed * self.screen.spacecraft.maxSpeed) then
        self.screen.spacecraft.velocity = self.screen.spacecraft.velocity:normalize();
        self.screen.spacecraft.velocity.x = self.screen.spacecraft.velocity.x * self.screen.spacecraft.maxSpeed;
        self.screen.spacecraft.velocity.y = self.screen.spacecraft.velocity.y * self.screen.spacecraft.maxSpeed;
    end

    self.screen.spacecraft.position.x = self.screen.spacecraft.position.x + self.screen.spacecraft.velocity.x;
    self.screen.spacecraft.position.y = self.screen.spacecraft.position.y + self.screen.spacecraft.velocity.y;

    if(self:isSpaceCraftAndPlatformColliding()) then
        self.isColliding = true
        if (math.abs(self.screen.spacecraft.angle - math.rad(270)) < self.angleThreshold
            and self.screen.spacecraft:getSpeed() < self.speedThreshold) then
                self.screen.spacecraft:setAsLanded();
                gameState:setNewState(gameState.victoryScreen)
            else
                self.screen.spacecraft:setAsDestroyed();
                gameState:setNewState(gameState.failScreen)
            end
        else
            self.isColliding = false
    end

    if(self.screen.spacecraft:getBottom() > window.y) then
        self.screen.spacecraft:setAsDestroyed()
        gameState:setNewState(gameState.failScreen)
    end
end

function PlayingState:draw()
    love.graphics.rectangle("fill", self.screen.platform.position.x, self.screen.platform.position.y, self.screen.platform.width, self.screen.platform.height)
    love.graphics.draw(
        self.screen.spacecraft.sprite, 
        self.screen.spacecraft.position.x, self.screen.spacecraft.position.y, 
        self.screen.spacecraft.angle, 
        1, 1, 
        self.screen.spacecraft.origin.x, self.screen.spacecraft.origin.y,
        0, 0
    );
    if self.screen.spacecraft:isEngineOn() then
        love.graphics.draw(
            self.screen.spacecraft.flameSprite, 
            self.screen.spacecraft.position.x, self.screen.spacecraft.position.y, 
            self.screen.spacecraft.angle, 
            1, 1, 
            self.screen.spacecraft.origin.x, self.screen.spacecraft.origin.y,
            0, 0
        );
    end

    if self.debug then
        love.graphics.print(self.screen.spacecraft:getSpeed(), 0 , 10)
        love.graphics.print(self.screen.spacecraft.angle, 0 , 20)
        love.graphics.print(self.screen.spacecraft.state, 0 , 30)
        love.graphics.print(tostring(self.isColliding), 0 , 40)
        local left = self.screen.spacecraft:getLeft()
        local top = self.screen.spacecraft:getTop()

        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("line", left, top, self.screen.spacecraft:getRight() - left, self.screen.spacecraft:getBottom() - top)
        love.graphics.rectangle("line", self.screen.platform.position.x, self.screen.platform.position.y, self.screen.platform.width, self.screen.platform.height)
        love.graphics.setColor(255,255,255)
    end

end

function PlayingState:isSpaceCraftAndPlatformColliding()
    return self.screen.spacecraft:getLeft() < self.screen.platform:getRight() and
        self.screen.spacecraft:getRight() > self.screen.platform:getLeft() and
        self.screen.spacecraft:getTop() < self.screen.platform:getBottom() and
        self.screen.spacecraft:getBottom() > self.screen.platform:getTop();
end

function PlayingState:keyPressed(key)
    if (key == "d") then
        self.debug = not(self.debug)
    end

    if (key == "escape") then
        self.screen.currentGameState = self.screen.gameStates.pause
    end
end