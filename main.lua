io.stdout:setvbuf('full')

local vector = require("src/vector")
local landerUtil = require("src/lander")
local screen = vector.new()
local gravity = vector.new()
local debug = false
local dPressed = false
local tau = math.pi * 2

function love.load()
    screen.x = love.graphics.getWidth()
    screen.y = love.graphics.getHeight()
    lander  = landerUtil.new()
    resetScene()
end

function love.update(dt)
    local isDPressing = love.keyboard.isDown("d")
    if(isDPressing and not dPressed) then
        dPressed = true
        debug = not debug
    end
    dPressed = isDPressing

    lander.velocity.y = lander.velocity.y + gravity.y * dt

    if(love.keyboard.isDown("right")) then
        lander.angle = lander.angle + lander.angularSpeed * dt
        if (lander.angle >= tau) then
            lander.angle = lander.angle - tau
        end
    elseif (love.keyboard.isDown("left")) then
        lander.angle = lander.angle - lander.angularSpeed * dt
        if (lander.angle < 0) then
            lander.angle = lander.angle + tau
        end
    end
    
    if(love.keyboard.isDown("space")) then
        lander.isEngineActive = true
        lander.velocity.y = lander.velocity.y + math.sin(lander.angle) * lander.thrustPower * dt
        lander.velocity.x = lander.velocity.x + math.cos(lander.angle) * lander.thrustPower * dt
    else
        lander.isEngineActive = false
    end

    lander.velocity = limitSpeedToMaximum(lander.velocity, lander.maxSpeed)

    lander.position.x = lander.position.x + lander.velocity.x
    lander.position.y = lander.position.y + lander.velocity.y
end

function love.draw()
    love.graphics.draw(lander.sprite.spacecraft, lander.position.x, lander.position.y, lander.angle, 1, 1, lander.center.x, lander.center.y)
    if(lander.isEngineActive) then
        love.graphics.draw(lander.sprite.engine, lander.position.x, lander.position.y, lander.angle, 1, 1, lander.center.x, lander.center.y)
    end

    if (debug) then
        love.graphics.print("Engine: "..tostring(lander.isEngineActive), 0, 0)
        love.graphics.print("Velocity: "..round(vectorLength(lander.velocity)), 0, 10)
        love.graphics.print("Angle: "..math.deg(lander.angle), 0, 20)
    end
end

function resetScene()
    lander.position.x = screen.x / 2;
    lander.position.y = screen.y / 2;

    gravity.y = 1
end

function vectorLength(vector)
    return math.sqrt(vector.x * vector.x + vector.y * vector.y)
end

function vectorSquareLength(vector)
    return vector.x * vector.x + vector.y * vector.y
end

function round(number)
    return math.floor(number * 100 +0.5) / 100
end

function limitSpeedToMaximum(vector, maxLength)
    local squareLength = vectorSquareLength(vector);
    if(squareLength > maxLength * maxLength) then
        local length = math.sqrt( squareLength )
        vector.x = vector.x / length * maxLength
        vector.y = vector.y / length * maxLength
    end
    return vector
end