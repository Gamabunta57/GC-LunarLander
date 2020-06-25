require("src/screen/screen")
require("src/lib/menu")
require("src/sound/audioEngine")

TitleScreen = {}
setmetatable(TitleScreen, Screen)
TitleScreen.__index = TitleScreen

function TitleScreen.new()
    local screen = {
        menu = Menu.new({
            items = {
                MenuItem.new({
                    name = "newGame",
                    translation = "newGame",
                    callback = function() gameState:goToGameState() end
                }),
                MenuItem.new({
                    name = "quit",
                    translation = "quit",
                    callback = TitleScreen.quitGame
                })
            },
            menuWidth = 200,
            rowSize = 30
        })
    }
    setmetatable(screen, TitleScreen);
    return screen;
end

function TitleScreen:draw()
    self.menu:draw()
end

function TitleScreen:reset()
    love.event.push("startBgMusic")
    self.index = 1;
end

function TitleScreen:keyPressed(key)
    if key == "down" then
        self.menu:next()
    elseif key == "up" then
        self.menu:prev()
    end

    if key == "return" then
        self.menu:confirm()
    end
end

function TitleScreen.quitGame()
    love.event.quit()
end