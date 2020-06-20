require("assets/lang/strings")

PauseState = {}
PauseState.__index = PauseState

function PauseState:new(gameScreen)
    local state = {
        screen = gameScreen,
        currentIndex = 1,
        menu = {"resume", "restart", "quitToTitle"},
        menuWidth = 200
    }
    setmetatable(state, PauseState)
    return state
end

function PauseState:reset()
    self.currentIndex = 1
end

function PauseState:update(dt)
end

function PauseState:draw()
    self.screen.gameStates.playing:draw();
    love.graphics.setColor({0,0,0,0.6})
    love.graphics.rectangle("fill",0,0,window.x, window.y)

    love.graphics.setColor({1,1,1,1})
    love.graphics.printf(Lang.pause[CurrentLang], 0 , window.y / 3 , window.x, "center", 0, 1, 1)

    for i = 1, #(self.menu) do
        local menuItemString = Lang[self.menu[i]][CurrentLang]
        if(self.currentIndex == i) then
            menuItemString = "> "..menuItemString;
        end
        love.graphics.printf(menuItemString, (window.x - self.menuWidth)/ 2, window.y * 2 / 3 + (i-1) * 20, self.menuWidth, "center")
    end

end

function PauseState:keyPressed(key)
    if(key == "escape") then
        self.screen.currentGameState = self.screen.gameStates.playing
    end

    if(key == "down" and self.currentIndex < #(self.menu)) then
        self.currentIndex = self.currentIndex + 1
    elseif (key == "up" and self.currentIndex > 1) then
        self.currentIndex = self.currentIndex - 1
    end

    if (key ~= "return") then
        return;
    end

    local currentMenu = self.menu[self.currentIndex]
    if (currentMenu == "resume") then
        self.screen.currentGameState = self.screen.gameStates.playing
    elseif (currentMenu == "restart") then
        gameState:setNewState(gameState.gameScreen)
    elseif (currentMenu == "quitToTitle") then
        gameState:setNewState(gameState.titleScreen)
    end
end