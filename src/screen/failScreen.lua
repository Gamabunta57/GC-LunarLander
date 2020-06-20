require("assets/lang/strings")
require("src/screen/screen")

FailScreen = {}
setmetatable(FailScreen, Screen)
FailScreen.__index = FailScreen;

function FailScreen.new()
    local screen = {
        menu = {"restart", "quitToTitle"},
        currentIndex = 1,
        menuWidth = 200
    }
    setmetatable(screen, FailScreen)
    return screen
end

function FailScreen:reset()
    self.currentIndex = 1
end

function FailScreen:draw()
    local string = Lang.fail[CurrentLang];
    love.graphics.printf(string, 0 , window.y / 3 , window.x, "center", 0, 1, 1)

    for i = 1, #(self.menu) do
        local menuItemString = Lang[self.menu[i]][CurrentLang]
        if(self.currentIndex == i) then
            menuItemString = "> "..menuItemString;
        end
        love.graphics.printf(menuItemString, (window.x - self.menuWidth)/ 2, window.y * 2 / 3 + (i-1) * 20, self.menuWidth, "center")
    end
end

function FailScreen:keyPressed(key)
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