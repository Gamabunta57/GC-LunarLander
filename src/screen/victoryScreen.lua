require("assets/lang/strings")
require("src/screen/screen")
require("src/lib/menu")

VictoryScreen = {}
setmetatable(VictoryScreen, Screen)
VictoryScreen.__index = VictoryScreen;

function VictoryScreen.new(gameScreen)
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
        }),
        gameScreen = gameScreen
    }
    setmetatable(screen, VictoryScreen)
    return screen
end

function VictoryScreen:reset()
    self.currentIndex = 1
end

function VictoryScreen:draw()
    self.gameScreen:draw()
    love.graphics.setColor({0,0,0,0.6})
    love.graphics.rectangle("fill",0,0,window.x, window.y)

    love.graphics.setColor(colors.success)
    love.graphics.setFont(fonts.title)
    local string = Lang.victory[CurrentLang];
    love.graphics.printf(string, 0 , window.y / 3 , window.x, "center", 0, 1, 1)
    
    love.graphics.setFont(fonts.main)
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