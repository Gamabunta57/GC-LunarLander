require("assets/lang/strings")
require("src/lib/menu")

PauseState = {}
PauseState.__index = PauseState

function PauseState:new(gameScreen)
    local state = {
        screen = gameScreen,
        currentIndex = 1,
        menu = Menu.new({
            items = {
                MenuItem.new({
                    name = "resume",
                    translation = "resume",
                    callback = function() gameScreen.currentGameState = gameScreen.gameStates.playing; end
                }),
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

    love.graphics.setFont(fonts.title)
    love.graphics.printf(Lang.pause[CurrentLang], 0 , window.y / 3 , window.x, "center", 0, 1, 1)

    love.graphics.setFont(fonts.main)
    self.menu:draw()
end

function PauseState:keyPressed(key)
    if(key == "escape") then
        self.screen.currentGameState = self.screen.gameStates.playing
        love.event.push("menuCancel")
    end

    if(key == "down") then
        self.menu:next()
    elseif (key == "up") then
        self.menu:prev()
    end

    if (key == "return") then
        self.menu:confirm()
    end
end