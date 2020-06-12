require("src/lib/vector")
require("src/spacecraft")

GameScreen = {}

function GameScreen:new()
    local screen = {
        spacecraft = Spacecraft:new(),
        gravity = Vector:new(0, 2);
    };

    setmetatable(screen, self);
    self.__index = self;
    return screen;
end


function GameScreen:update(dt)
    self.spacecraft.velocity.x = self.spacecraft.velocity.x + self.gravity.x * dt
    self.spacecraft.velocity.y = self.spacecraft.velocity.y + self.gravity.y * dt

    if (love.keyboard.isDown("space")) then
        self.spacecraft.isEngineOn = true;
        self.spacecraft.velocity.x = self.spacecraft.velocity.x + math.cos(self.spacecraft.angle) * self.spacecraft.thrustPower * dt;
        self.spacecraft.velocity.y = self.spacecraft.velocity.y + math.sin(self.spacecraft.angle) * self.spacecraft.thrustPower * dt;
    else
        self.spacecraft.isEngineOn = false;
    end

    if (love.keyboard.isDown("left")) then
        self.spacecraft.angle = self.spacecraft.angle - self.spacecraft.angularSpeed * dt
    elseif (love.keyboard.isDown("right")) then
        self.spacecraft.angle = self.spacecraft.angle + self.spacecraft.angularSpeed * dt
    end

    if (self.spacecraft.velocity:squareLength() > self.spacecraft.maxSpeed * self.spacecraft.maxSpeed) then
        self.spacecraft.velocity = self.spacecraft.velocity:normalize();
        self.spacecraft.velocity.x = self.spacecraft.velocity.x * self.spacecraft.maxSpeed;
        self.spacecraft.velocity.y = self.spacecraft.velocity.y * self.spacecraft.maxSpeed;
    end

    self.spacecraft.position.x = self.spacecraft.position.x + self.spacecraft.velocity.x;
    self.spacecraft.position.y = self.spacecraft.position.y + self.spacecraft.velocity.y;
end

function GameScreen:draw()
    love.graphics.draw(
        self.spacecraft.sprite, 
        self.spacecraft.position.x, self.spacecraft.position.y, 
        self.spacecraft.angle, 
        1, 1, 
        self.spacecraft.origin.x, self.spacecraft.origin.y,
        0, 0
    );
    if self.spacecraft.isEngineOn then
        love.graphics.draw(
            self.spacecraft.flameSprite, 
            self.spacecraft.position.x, self.spacecraft.position.y, 
            self.spacecraft.angle, 
            1, 1, 
            self.spacecraft.origin.x, self.spacecraft.origin.y,
            0, 0
        );
    end
end

function GameScreen:reset()
    self.spacecraft.position = Vector:new((window.x - self.spacecraft:getWidth()) / 2, (window.y - self.spacecraft:getHeight()) / 2)
    self.spacecraft.velocity = Vector:new();
    self.spacecraft.isEngineOn = false;
    self.spacecraft.angle = math.rad(270);
end