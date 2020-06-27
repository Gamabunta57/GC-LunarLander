require("src/screen/screen")

BGScreen = {}
setmetatable(BGScreen, Screen)
BGScreen.__index = BGScreen;

function BGScreen.new()
    local s = {
        dots = {},
        dotCount = 130,
        colors = {
            rgb(176, 185, 214),
            rgb(255, 222, 217),
            rgb(215, 207, 227),
            rgb(215, 207, 227),
        },
        bgSprite = love.graphics.newImage("assets/images/moon.png")
    }
    setmetatable(s, BGScreen)
    return s;
end

function BGScreen:reset()
    self.dots = {}
    for i=0, self.dotCount do
        local dot =  {
            pos = Vector.new(
                love.math.random(0, window.x),
                love.math.random(0, window.y)
            ),
            size = 1,
            color = love.math.random(1, #(self.colors))
        }


        if (love.math.random(0, 100) > 90) then
            dot.size = 2
        end        

        table.insert(self.dots, dot)
    end
end

function BGScreen:draw()
    love.graphics.setColor(colors.spaceBg)
    love.graphics.rectangle("fill",0 ,0, window.x, window.y)
    for i=0, self.dotCount do
        local dot = self.dots[i + 1];
        love.graphics.setColor(self.colors[dot.color])
        love.graphics.circle("fill", dot.pos.x, dot.pos.y, dot.size)
    end
    love.graphics.setColor({1,1,1})
    for i = 0, window.x, self.bgSprite:getWidth() do
        love.graphics.draw(self.bgSprite, i, window.y - self.bgSprite:getHeight());
    end
end

function BGScreen:keyPressed(key)
    if(key == "down") then
        self.dotCount = self.dotCount - 10
        self:reset()
    end

    if(key == "up") then
        self.dotCount = self.dotCount + 10
        self:reset()
    end

    if(key == "r") then
        self:reset()
    end
end

function rgb(r, g, b)
    return {r / 255, g /255, b / 255}
end