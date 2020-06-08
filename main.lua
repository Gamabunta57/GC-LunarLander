io.stdout:setvbuf('full')

local vector = require("src/vector")
local landerUtil = require("src/lander")
local plateformUtil = require("src/platform")
local screen = vector.new()
local gravity = vector.new()
local debug = false
local keyPressed = {
    d = false,
    r = false
}
local tau = math.pi * 2

local lander
local platform
local state = "Ok"

function love.load()
    screen.x = love.graphics.getWidth()
    screen.y = love.graphics.getHeight()
    lander = landerUtil.new()
    platform = plateformUtil.new()
    resetScene()
end

function love.update(dt)
    local isDPressing = love.keyboard.isDown("d")
    if(isDPressing and not keyPressed.d) then
        debug = not debug
    end
    keyPressed.d = isDPressing

    local isRPressing = love.keyboard.isDown("r")
    if(isRPressing and not keyPressed.r) then
        keyPressed.r = true
        resetScene()
        return
    end
    keyPressed.r = isRPressing

    if (state ~= "Ok") then
        return
    end

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

    if (lander.position.y + lander.center.y < 0) then
        state = "out of gravity"
    elseif (lander.position.y + lander.center.y > screen.y) or
            (lander.position.x + lander.center.x > screen.x) or
            (lander.position.x - lander.center.x < 0) then
        state = "crash"
    end
end

function love.draw()
    love.graphics.draw(lander.sprite.spacecraft, lander.position.x, lander.position.y, lander.angle, 1, 1, lander.center.x, lander.center.y)
    love.graphics.rectangle("fill", platform.position.x, platform.position.y, platform.size.x, platform.size.y)
    if(lander.isEngineActive) then
        love.graphics.draw(lander.sprite.engine, lander.position.x, lander.position.y, lander.angle, 1, 1, lander.center.x, lander.center.y)
    end

    if (debug) then
        love.graphics.print("Engine: "..tostring(lander.isEngineActive), 0, 0)
        love.graphics.print("Velocity: "..round(vectorLength(lander.velocity)), 0, 10)
        love.graphics.print("Angle: "..math.deg(lander.angle), 0, 20)
        love.graphics.print("Position: (x:"..lander.position.x..", y:"..lander.position.y..")", 0, 30)
        love.graphics.print("State: "..state, 0, 45)
    end
end

function resetScene()
    lander.position.x = screen.x / 2;
    lander.position.y = screen.y / 2;
    lander.velocity.x = 0;
    lander.velocity.y = 0;

    platform.size.x = 30;
    platform.size.y = 5;
    platform.position.x = math.random( screen.x + 1) - platform.size.x
    platform.position.y = screen.y - platform.size.y

    state = "Ok"

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

function limitPosition(position, minX, minY, maxX, maxY)
    if(position.x > maxX) then
        position.x = maxX
    elseif (position.x < minX) then
        position.x = minX
    end

    if(position.y > maxY) then
        position.y = maxY
    elseif (position.y < minY) then
        position.y = minY
    end

    return position
end