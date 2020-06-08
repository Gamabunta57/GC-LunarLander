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
        angle = -90,
        angularSpeed = 90,
        isEngineActive = false
    }

    lander.center.x = lander.sprite.spacecraft:getWidth() / 2
    lander.center.y = lander.sprite.spacecraft:getHeight() / 2

    return lander
end

return  landerFactory