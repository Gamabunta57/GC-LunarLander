require("src/lib/vector")
require("src/spacecraft")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    print("debug on")
    require("lldebugger").start()
    io.stdout:setvbuf('no')
end

local spacecraft;
local screen;
local gravity = Vector:new(0, 2);

function love.load()
    screen = Vector:new(love.graphics.getWidth(), love.graphics.getHeight());
    spacecraft = Spacecraft:new();
    resetScene();
end

function love.update(dt)
    spacecraft.velocity.x = spacecraft.velocity.x + gravity.x * dt
    spacecraft.velocity.y = spacecraft.velocity.y + gravity.y * dt

    if (love.keyboard.isDown("space")) then
        spacecraft.isEngineOn = true;
        spacecraft.velocity.x = spacecraft.velocity.x + math.cos(spacecraft.angle) * spacecraft.thrustPower * dt;
        spacecraft.velocity.y = spacecraft.velocity.y + math.sin(spacecraft.angle) * spacecraft.thrustPower * dt;
    else
        spacecraft.isEngineOn = false;
    end

    if (love.keyboard.isDown("left")) then
        spacecraft.angle = spacecraft.angle - spacecraft.angularSpeed * dt
    elseif (love.keyboard.isDown("right")) then
        spacecraft.angle = spacecraft.angle + spacecraft.angularSpeed * dt
    end

    if (spacecraft.velocity:squareLength() > spacecraft.maxSpeed * spacecraft.maxSpeed) then
        spacecraft.velocity = spacecraft.velocity:normalize();
        spacecraft.velocity.x = spacecraft.velocity.x * spacecraft.maxSpeed;
        spacecraft.velocity.y = spacecraft.velocity.y * spacecraft.maxSpeed;
    end

    spacecraft.position.x = spacecraft.position.x + spacecraft.velocity.x;
    spacecraft.position.y = spacecraft.position.y + spacecraft.velocity.y;
end

function love.draw()
    love.graphics.draw(
        spacecraft.sprite, 
        spacecraft.position.x, spacecraft.position.y, 
        spacecraft.angle, 
        1, 1, 
        spacecraft.origin.x, spacecraft.origin.y,
        0, 0
    );
    if spacecraft.isEngineOn then
        love.graphics.draw(
            spacecraft.flameSprite, 
            spacecraft.position.x, spacecraft.position.y, 
            spacecraft.angle, 
            1, 1, 
            spacecraft.origin.x, spacecraft.origin.y,
            0, 0
        );
    end
end

function resetScene()
    spacecraft.position = Vector:new((screen.x - spacecraft:getWidth()) / 2, (screen.y - spacecraft:getHeight()) / 2)
    spacecraft.velocity = Vector:new();
    spacecraft.isEngineOn = false;
    spacecraft.angle = math.rad(270);
end