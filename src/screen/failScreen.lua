require("assets/lang/strings")
require("src/screen/screen")

FailScreen = {}
setmetatable(FailScreen, Screen)
FailScreen.__index = FailScreen;

function FailScreen.new()
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
    setmetatable(screen, FailScreen)
    return screen
end

function FailScreen:reset()
    self.currentIndex = 1
end

function FailScreen:draw()
    love.graphics.setColor({0,0,0,0.6})
    love.graphics.rectangle("fill",0,0,window.x, window.y)

    local string = Lang.fail[CurrentLang];
    love.graphics.setFont(fonts.title)
    love.graphics.setColor(colors.failed)
    love.graphics.printf(string, 0 , window.y / 3 , window.x, "center", 0, 1, 1)
    
    self.menu:draw()
end

function FailScreen:keyPressed(key)
    if(key == "down") then
        self.menu:next()
    elseif (key == "up") then
        self.menu:prev()
    end

    if (key == "return") then
        self.menu:confirm()
    end
end