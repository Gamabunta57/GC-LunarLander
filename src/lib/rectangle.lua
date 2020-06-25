Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle.new(x, y, width, height)
    local r = {
        x = x or 0,
        y = y or 0,
        width = width or 1,
        height = height or 1
    }
    setmetatable(r, Rectangle)
    return r
end

function Rectangle:getLeft()
    return self.x
end

function Rectangle:getRight()
    return self.x + self.width
end

function Rectangle:getBottom()
    return self.y + self.height
end

function Rectangle:getTop()
    return self.y
end
