require("src/lib/vector")
require("src/spacecraft")
require("src/platform")

GameScreen = {}

GameScreen.__index = GameScreen

function GameScreen:new()
    local screen = {
        spacecraft = Spacecraft:new(),
        platform = Platform:new(),
        gravity = Vector:new(0, 2),
        debug = false,
        isDPressed = false,
        isRPressed = false,
        isColliding = false,
        angleThreshold = 5,
        speedThreshold = 1
    };

    setmetatable(screen, self);
    return screen;
end

function GameScreen:reset()
    self.spacecraft.position = Vector:new((window.x - self.spacecraft:getWidth()) / 2, (window.y - self.spacecraft:getHeight()) / 2)
    self.spacecraft.velocity = Vector:new();
    self.spacecraft:setEngineOn(false);
    self.spacecraft.angle = math.rad(270);

    self.platform.position.y = window.y - self.platform.height;
    self.platform.position.x = math.random( 0, window.x - self.platform.width )
end

function GameScreen:update(dt)

    if (love.keyboard.isDown("d") and not(self.isDPressed)) then
        self.debug = not(self.debug)
    end
    
    self.isDPressed = love.keyboard.isDown("d")

    if (love.keyboard.isDown("r") and not(self.isRPressed)) then
        self.isRPressed = true
        self:reset();
        return
    end
    
    self.isRPressed = love.keyboard.isDown("r")

    if (not(self.spacecraft:isFlying())) then
        return;
    end

    self.spacecraft.velocity.x = self.spacecraft.velocity.x + self.gravity.x * dt
    self.spacecraft.velocity.y = self.spacecraft.velocity.y + self.gravity.y * dt

    if (love.keyboard.isDown("space")) then
        self.spacecraft:setEngineOn(true);
        self.spacecraft.velocity.x = self.spacecraft.velocity.x + math.cos(self.spacecraft.angle) * self.spacecraft.thrustPower * dt;
        self.spacecraft.velocity.y = self.spacecraft.velocity.y + math.sin(self.spacecraft.angle) * self.spacecraft.thrustPower * dt;
    else
        self.spacecraft:setEngineOn(false);
    end

    if (love.keyboard.isDown("left")) then
        self.spacecraft.angle = self.spacecraft.angle - self.spacecraft.angularSpeed * dt
    elseif (love.keyboard.isDown("right")) then
        self.spacecraft.angle = self.spacecraft.angle + self.spacecraft.angularSpeed * dt
    end

    if (self.spacecraft.angle < 0) then
        self.spacecraft.angle = self.spacecraft.angle + math.pi * 2
    elseif self.spacecraft.angle > math.pi * 2 then
        self.spacecraft.angle = self.spacecraft.angle - math.pi * 2
    end

    if (self.spacecraft.velocity:squareLength() > self.spacecraft.maxSpeed * self.spacecraft.maxSpeed) then
        self.spacecraft.velocity = self.spacecraft.velocity:normalize();
        self.spacecraft.velocity.x = self.spacecraft.velocity.x * self.spacecraft.maxSpeed;
        self.spacecraft.velocity.y = self.spacecraft.velocity.y * self.spacecraft.maxSpeed;
    end

    self.spacecraft.position.x = self.spacecraft.position.x + self.spacecraft.velocity.x;
    self.spacecraft.position.y = self.spacecraft.position.y + self.spacecraft.velocity.y;

    if(self:isSpaceCraftAndPlatformColliding()) then
        self.isColliding = true
        if (math.abs(self.spacecraft.angle - math.rad(270)) < self.angleThreshold
            and self.spacecraft:getSpeed() < self.speedThreshold) then
                self.spacecraft:setAsLanded();
            else
                self.spacecraft:setAsDestroyed();
            end
        else
            self.isColliding = false
    end

    if(self.spacecraft:getBottom() > window.y) then
        self.spacecraft:setAsDestroyed()
    end
end

function GameScreen:draw()
    love.graphics.rectangle("fill", self.platform.position.x, self.platform.position.y, self.platform.width, self.platform.height)
    love.graphics.draw(
        self.spacecraft.sprite, 
        self.spacecraft.position.x, self.spacecraft.position.y, 
        self.spacecraft.angle, 
        1, 1, 
        self.spacecraft.origin.x, self.spacecraft.origin.y,
        0, 0
    );
    if self.spacecraft:isEngineOn() then
        love.graphics.draw(
            self.spacecraft.flameSprite, 
            self.spacecraft.position.x, self.spacecraft.position.y, 
            self.spacecraft.angle, 
            1, 1, 
            self.spacecraft.origin.x, self.spacecraft.origin.y,
            0, 0
        );
    end

    if self.debug then
        love.graphics.print(self.spacecraft:getSpeed(), 0 , 10)
        love.graphics.print(self.spacecraft.angle, 0 , 20)
        love.graphics.print(self.spacecraft.state, 0 , 30)
        love.graphics.print(tostring(self.isColliding), 0 , 40)
        local left = self.spacecraft:getLeft()
        local top = self.spacecraft:getTop()

        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("line", left, top, self.spacecraft:getRight() - left, self.spacecraft:getBottom() - top)
        love.graphics.rectangle("line", self.platform.position.x, self.platform.position.y, self.platform.width, self.platform.height)
        love.graphics.setColor(255,255,255)
    end

end

function GameScreen:isSpaceCraftAndPlatformColliding()
    return self.spacecraft:getLeft() < self.platform:getRight() and
        self.spacecraft:getRight() > self.platform:getLeft() and
        self.spacecraft:getTop() < self.platform:getBottom() and
        self.spacecraft:getBottom() > self.platform:getTop();
end