require("assets/lang/strings")
require("src/screen/screen")

VictoryScreen = {}
setmetatable(VictoryScreen, Screen)
VictoryScreen.__index = VictoryScreen;

function VictoryScreen.new()
    local screen = {
        menu = {"restart", "quitToTitle"},
        currentIndex = 1,
        menuWidth = 200
    }
    setmetatable(screen, VictoryScreen)
    return screen
end

function VictoryScreen:reset()
    self.currentIndex = 1
end

function VictoryScreen:draw()
    local string = Lang.victory[CurrentLang];
    love.graphics.printf(string, 0 , window.y / 3 , window.x, "center", 0, 1, 1)

    for i = 1, #(self.menu) do
        local menuItemString = Lang[self.menu[i]][CurrentLang]
        if(self.currentIndex == i) then
            menuItemString = "> "..menuItemString;
        end
        love.graphics.printf(menuItemString, (window.x - self.menuWidth)/ 2, window.y * 2 / 3 + (i-1) * 20, self.menuWidth, "center")
    end
end

function VictoryScreen:keyPressed(key)
    if(key == "down" and self.currentIndex < #(self.menu)) then
        self.currentIndex = self.currentIndex + 1
    elseif (key == "up" and self.currentIndex > 1) then
        self.currentIndex = self.currentIndex - 1
    end

    if (key ~= "return") then
        return;
    end

    local currentMenu = self.menu[self.currentIndex]
    if (currentMenu == "restart") then
        gameState:setNewState(gameState.gameScreen)
    elseif (currentMenu == "quitToTitle") then
        gameState:setNewState(gameState.titleScreen)
    end
end