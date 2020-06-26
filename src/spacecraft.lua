require("src/lib/vector")
require("src/lib/animatedSprite")

Spacecraft = {
    availableStates = {"flying", "crashed", "landed", "engineOn"}
}

Spacecraft.__index = Spacecraft

function Spacecraft.new()
    local spacecraft = {
        position = Vector.new(),
        angle = 0,
        origin = Vector.new(),
        velocity = Vector.new(),
        angularSpeed = 3,
        thrustPower = 5,
        state = "flying",
        sprite = love.graphics.newImage("assets/images/rocket_very_small.png"),
        flameSprite = love.graphics.newImage("assets/images/engine.png"),
        flameAnimated = AnimatedSprite.new(love.graphics.newImage("assets/images/rocket_burst.png"), 60, 25, 30, 1/60, Vector.new(0 ,0)),
        crashAnimation = AnimatedSprite.new(love.graphics.newImage("assets/images/rocket_crash.png"), 155, 150, 42, 1/60, Vector.new(155/2 -  30, 150 / 2 - 10)),
        maxSpeed = 5,
        dyingTime = 1/60 * 42,
        currentDyingTime = 1/60 * 42,
        collider = {}
    }

    setmetatable(spacecraft, Spacecraft);

    spacecraft.origin.x = spacecraft.sprite:getWidth() / 2;
    spacecraft.origin.y = spacecraft.sprite:getHeight() / 2;
    spacecraft.dyingTime = spacecraft.crashAnimation.timePerFrame * spacecraft.crashAnimation.frameCount;
    spacecraft.currentDyingTime = spacecraft.dyingTime;
    spacecraft.collider = Rectangle.new(6, 8, 10, 14)

    return spacecraft;
end

function Spacecraft:getWidth()
    return self.sprite:getWidth()
end

function Spacecraft:getHeight()
    return self.sprite:getHeight()
end

function Spacecraft:getLeft()
    return self.position.x + self.collider:getLeft() - self.origin.x
end

function Spacecraft:getRight()
    return self.position.x + self.collider:getRight() - self.origin.x
end

function Spacecraft:getBottom()
    return self.position.y + self.collider:getBottom() - self.origin.y
end

function Spacecraft:getTop()
    return self.position.y + self.collider:getTop() - self.origin.y
end

function Spacecraft:getSpeed()
    return self.velocity:length()
end

function Spacecraft:isEngineOn()
    return self.state == "engineOn"
end

function Spacecraft:isDestroying()
    return self.state == "crashed" and self.currentDyingTime > 0
end

function Spacecraft:hasDisapear()
    return self.state == "crashed" and self.currentDyingTime <= 0;
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
        love.event.push("spaceshipEngineOn")
    else
        self.state = "flying"
        love.event.push("spaceshipEngineOff")
    end   
end

function Spacecraft:setAsLanded()
    self.state = "landed"
    love.event.push("spaceshipLanded")
    love.event.push("spaceshipEngineOff")
end

function Spacecraft:setAsDestroyed()
    self.state = "crashed"
    love.event.push("spaceshipCrashed")
    love.event.push("spaceshipEngineOff")
end