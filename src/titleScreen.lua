TitleScreen = {}

local newGame = "New game";
local quit = "Quit";

function TitleScreen:new()
    local screen = {
        menu = {newGame, quit},
        index = 1,
        menuWidth = 200,
        rowSize = 30,
        isKDownDown = false,
        isKUpDown = false,
        isKReturnDown = false,
    }
    setmetatable(screen, self);
    self.__index = self
    return screen;
end

function TitleScreen:update(dt)
    local isKDownDown = love.keyboard.isDown("down");
    local isKUpDown = love.keyboard.isDown("up");
    local isKReturnDown = love.keyboard.isDown("return");
    
    if not(self.isKDownDown) and isKDownDown and self.index < table.getn(self.menu) then
        self.isKDownDown = true;
        self.index = self.index + 1;
    elseif not(self.isKUpDown) and isKUpDown and self.index > 1 then
        self.isKUpDown = true;
        self.index = self.index - 1;
    end

    if not(self.isKReturnDown) and isKReturnDown then
        if (self.menu[self.index] == newGame) then
            gameState:setNewState(gameState.gameScreen)
        else
            love.event.quit()
        end
    end

    self.isKDownDown = isKDownDown;
    self.isKUpDown = isKUpDown;
    self.isKReturnDown = isKReturnDown;
end

function TitleScreen:draw()
    for i = 1, table.getn(self.menu) do
        local text = self.menu[i];
        if self.index == i then 
            text = "> "..text
        end
        love.graphics.printf(text, (window.x - self.menuWidth) / 2, window.y * 2 / 3 + (i-1) * self.rowSize, self.menuWidth, "center");
    end
end

function TitleScreen:reset()
    self.index = 1;
end