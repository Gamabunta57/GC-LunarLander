require("src/screen/screen")

TitleScreen = {}
setmetatable(TitleScreen, Screen)
TitleScreen.__index = TitleScreen

function TitleScreen:new()
    local screen = {
        menu = {"newGame", "quit"},
        index = 1,
        menuWidth = 200,
        rowSize = 30
    }
    setmetatable(screen, self);
    self.__index = self
    return screen;
end

function TitleScreen:draw()
    for i = 1, table.getn(self.menu) do
        local text = Lang[self.menu[i]][CurrentLang];
        if self.index == i then 
            text = "> "..text
        end
        love.graphics.printf(text, (window.x - self.menuWidth) / 2, window.y * 2 / 3 + (i-1) * self.rowSize, self.menuWidth, "center");
    end
end

function TitleScreen:reset()
    self.index = 1;
end

function TitleScreen:keyPressed(key)
    if key == "down" and self.index < #(self.menu)then
        self.index = self.index + 1;
    elseif key == "up" and self.index > 1 then
        self.index = self.index - 1;
    end

    if key == "return" then
        if (self.menu[self.index] == "newGame") then
            gameState:setNewState(gameState.gameScreen)
        elseif (self.menu[self.index] == "quit") then
            love.event.quit()
        end
    end
end