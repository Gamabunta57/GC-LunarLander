require("assets/lang/strings")
require("src/screen/screen")
require("src/lib/menu")

VictoryScreen = {}
setmetatable(VictoryScreen, Screen)
VictoryScreen.__index = VictoryScreen;

function VictoryScreen.new()
    local screen = {
        menu = Menu.new({
            items = {
                MenuItem.new({
                    name = "restart",
                    translation = "restart",
                    callback = function() gameState:goToGameState() end
                }),
                MenuItem.new({
                    name = "quitToTitle",
                    translation = "quitToTitle",
                    callback = function() gameState:goToTitleScreenState() end
                })
            },
            menuWidth = 200,
            rowSize = 30
        })
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

    self.menu:draw()
end

function VictoryScreen:keyPressed(key)
    if(key == "down") then
        self.menu:next()
    elseif (key == "up") then
        self.menu:prev()
    end

    if (key == "return") then
        self.menu:confirm()
    end
end