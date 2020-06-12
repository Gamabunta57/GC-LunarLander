Vector = {};

function Vector:new(x, y)
    local Vector = {
        x = x or 0,
        y = y or 0
    };
    setmetatable(Vector, self);
    self.__index = self;
    return Vector;
end

function Vector:copy()
    local copy = Vector:new();
    copy.x = self.x;
    copy.y = self.y;
    return copy;
end

function Vector:squareLength() 
    return self.x * self.x + self.y * self.y;
end

function Vector:length() 
    return math.sqrt(self:squareLength());
end

function Vector:normalize() 
    local length = self:length();
    local vector = self:copy();
    vector.x = vector.x / length;
    vector.y = vector.y / length;
    return vector;
end