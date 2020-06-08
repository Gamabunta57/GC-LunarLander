local vector = require("./src/vector")
local assetPath = "assets/images/"

local landerFactory = {}

landerFactory.new = function()
    local lander = {
        position = vector.new(),
        velocity = vector.new(),
        sprite = {
            spacecraft = love.graphics.newImage(assetPath.."ship.png"),
            engine = love.graphics.newImage(assetPath.."engine.png")
        },
        center = vector.new(),
        angle = math.rad(270),
        angularSpeed = 3,
        thrustPower = 3,
        isEngineActive = false
    }

    lander.center.x = lander.sprite.spacecraft:getWidth() / 2
    lander.center.y = lander.sprite.spacecraft:getHeight() / 2

    return lander
end

return  landerFactory