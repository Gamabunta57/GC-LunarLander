local vector = require("src/vector")
local platform = {}

platform.new = function()
    local platform = {
        position = vector.new(),
        size = vector.new()
    }
    return platform
end

return platform