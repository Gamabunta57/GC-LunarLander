require("src/lib/vector")

Spacecraft = {
    availableStates = {"flying", "crashed", "landed", "engineOn"}
}

function Spacecraft:new()
    local spacecraft = {
        position = Vector:new(),
        angle = 0,
        origin = Vector:new(),
        velocity = Vector:new(),
        angularSpeed = 3,
        thrustPower = 5,
        state = "flying",
        sprite = love.graphics.newImage("assets/images/ship.png"),
        flameSprite = love.graphics.newImage("assets/images/engine.png"),
        maxSpeed = 5
    }

    setmetatable(spacecraft, self);
    self.__index = self;

    print(spacecraft)
    spacecraft.origin.x = spacecraft.sprite:getWidth() / 2;
    spacecraft.origin.y = spacecraft.sprite:getHeight() / 2;

    return spacecraft;
end

function Spacecraft:getWidth()
    return self.sprite:getWidth()
end

function Spacecraft:getHeight()
    return self.sprite:getHeight()
end

function Spacecraft:getLeft()
    return self.position.x - self:getWidth() / 2
end

function Spacecraft:getRight()
    return self.position.x + self:getWidth() / 2
end

function Spacecraft:getBottom()
    return self.position.y + self:getHeight() / 2
end

function Spacecraft:getTop()
    return self.position.y - self:getHeight() / 2
end

function Spacecraft:getSpeed()
    return self.velocity:length()
end

function Spacecraft:isEngineOn()
    return self.state == "engineOn"
end

function Spacecraft:isCrashed()
    return self.state == "crashed"
end

function Spacecraft:isLanded()
    return self.state == "landed"
end

function Spacecraft:isFlying()
    return self.state == "flying" or self:isEngineOn()
end

function Spacecraft:setEngineOn(isEngineOn)
    if (isEngineOn) then
        self.state = "engineOn"
    else
        self.state = "flying"
    end   
end

function Spacecraft:setAsLanded()
    self.state = "landed"
end

function Spacecraft:setAsDestroyed()
    self.state = "crashed"
end