local vectorFactory = {}

vectorFactory.new = function()
    return {
        x = 0,
        y = 0
    }
end

return vectorFactory