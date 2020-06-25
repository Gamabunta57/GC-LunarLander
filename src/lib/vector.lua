Vector = {};
Vector.__index = Vector;

function Vector.new(x, y)
    local v = {
        x = x or 0,
        y = y or 0
    };
    setmetatable(v, Vector);
    return v;
end

function Vector:squareLength() 
    return self.x * self.x + self.y * self.y;
end

function Vector:length() 
    return math.sqrt(self:squareLength());
end

function Vector:normalize() 
    local length = self:length();
    local vector = Vector.new(self.x, self.y);
    vector.x = vector.x / length;
    vector.y = vector.y / length;
    return vector;
end