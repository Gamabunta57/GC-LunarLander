PlayingState = {}
PlayingState.__index = PlayingState;

function PlayingState:new(gameScreen)
    local state = {
        screen = gameScreen,
        gravity = Vector.new(0, 2),
        debug = false,
        isColliding = false,
        angleThreshold = 2,
        speedThreshold = 0.7,
    }
    setmetatable(state, PlayingState)
    return state
end

function PlayingState:reset()
    self.screen.spacecraft.position = Vector.new((window.x - self.screen.spacecraft:getWidth()) / 2, (window.y - self.screen.spacecraft:getHeight()) / 2)
    self.screen.spacecraft.velocity = Vector.new();
    self.screen.spacecraft:setEngineOn(false);
    self.screen.spacecraft.angle = math.rad(270);
    self.screen.spacecraft.currentDyingTime = self.screen.spacecraft.dyingTime;
    self.screen.spacecraft.fuel = 100

    self.screen.platform.position.y = window.y - self.screen.platform.height;
    self.screen.platform.position.x = love.math.random( 0, window.x - self.screen.platform.width )
end

function PlayingState:update(dt)
    if (self.screen.spacecraft:isDestroying()) then
        self.screen.spacecraft.crashAnimation:update(dt)
        self.screen.spacecraft.currentDyingTime = self.screen.spacecraft.currentDyingTime - dt
    end

    if(self.screen.spacecraft:hasDisapear()) then
        gameState:setNewState(gameState.failScreen)
    end

    if (not(self.screen.spacecraft:isFlying())) then
        return;
    end

    self.screen.spacecraft.velocity.x = self.screen.spacecraft.velocity.x + self.gravity.x * dt
    self.screen.spacecraft.velocity.y = self.screen.spacecraft.velocity.y + self.gravity.y * dt

    if (love.keyboard.isDown("space") and self.screen.spacecraft.fuel > 0) then
        self.screen.spacecraft:setEngineOn(true);
        self.screen.spacecraft.velocity.x = self.screen.spacecraft.velocity.x + math.cos(self.screen.spacecraft.angle) * self.screen.spacecraft.thrustPower * dt;
        self.screen.spacecraft.velocity.y = self.screen.spacecraft.velocity.y + math.sin(self.screen.spacecraft.angle) * self.screen.spacecraft.thrustPower * dt;
        self.screen.spacecraft.flameAnimated:update(dt)
        self.screen.spacecraft.fuel = self.screen.spacecraft.fuel - dt * 20
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
                love.event.push("victory")
                gameState:setNewState(gameState.victoryScreen)
            else
                self.screen.spacecraft:setAsDestroyed();
            end
        else
            self.isColliding = false
    end

    if(self.screen.spacecraft:getBottom() > window.y) then
        self.screen.spacecraft:setAsDestroyed()
    end
end

function PlayingState:draw()
    self.screen.platform:draw()
    if self.screen.spacecraft:isEngineOn() then
        self.screen.spacecraft.flameAnimated:draw(self.screen.spacecraft.position, self.screen.spacecraft.angle);
    end
    if (self.screen.spacecraft:isDestroying()) then
        self.screen.spacecraft.crashAnimation:draw(self.screen.spacecraft.position)
        return;
    end
    if not(self.screen.spacecraft:hasDisapear()) then
        love.graphics.draw(
            self.screen.spacecraft.sprite, 
            self.screen.spacecraft.position.x, self.screen.spacecraft.position.y, 
            self.screen.spacecraft.angle, 
            1, 1, 
            self.screen.spacecraft.origin.x, self.screen.spacecraft.origin.y,
            0, 0
        );
        love.graphics.setColor(colors.fuelBg)
        love.graphics.rectangle("fill", window.x - 50, (window.y - 100) / 2, 20, 100)
        love.graphics.setColor(colors.fuel)
        love.graphics.rectangle("fill", window.x - 50, (window.y - 100) / 2 + (100-self.screen.spacecraft.fuel), 20, self.screen.spacecraft.fuel)
    end
end

function PlayingState:isSpaceCraftAndPlatformColliding()
    return self.screen.spacecraft:getLeft() < self.screen.platform:getRight() and
        self.screen.spacecraft:getRight() > self.screen.platform:getLeft() and
        self.screen.spacecraft:getTop() < self.screen.platform:getBottom() and
        self.screen.spacecraft:getBottom() > self.screen.platform:getTop();
end

function PlayingState:keyPressed(key)
    if (key == "escape") then
        self.screen.currentGameState = self.screen.gameStates.pause
    end
end