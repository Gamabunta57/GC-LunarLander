io.stdout:setvbuf('no')

local vector = require("src/vector")
local landerUtil = require("src/lander")
local screen = vector.new()
local gravity = vector.new()

function love.load()
    screen.x = love.graphics.getWidth()
    screen.y = love.graphics.getHeight()
    lander  = landerUtil.new()
    resetScene()
end

function love.update(dt)
    lander.velocity.y = lander.velocity.y + gravity.y * dt

    lander.position.x = lander.position.x + lander.velocity.x
    lander.position.y = lander.position.y + lander.velocity.y
end

function love.draw()
    love.graphics.draw(lander.sprite.spacecraft, lander.position.x, lander.position.y, math.rad(lander.angle), 1, 1, lander.center.x, lander.center.y)
end

function resetScene()
    lander.position.x = screen.x / 2;
    lander.position.y = screen.y / 2;

    gravity.y = 1
end