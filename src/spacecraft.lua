require("src/lib/vector")

Spacecraft = {}

function Spacecraft:new()
    local spacecraft = {
        position = Vector:new(),
        angle = 0,
        origin = Vector:new(),
        velocity = Vector:new(),
        angularSpeed = 3,
        thrustPower = 5,
        isEngineOn = false,
        sprite = love.graphics.newImage("assets/images/ship.png"),
        flameSprite = love.graphics.newImage("assets/images/engine.png"),
        maxSpeed = 5
    }

    setmetatable(spacecraft, self);
    self.__index = self

    spacecraft.origin.x = spacecraft:getWidth() / 2;
    spacecraft.origin.y = spacecraft:getHeight() / 2;

    return spacecraft;
end

function Spacecraft:getWidth()
    return self.sprite:getWidth()
end

function Spacecraft:getHeight()
    return self.sprite:getHeight()
end