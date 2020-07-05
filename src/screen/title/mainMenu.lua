MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new(screen)
    local state = {
        screen = screen,
        menu = Menu.new({
            items = {
                MenuItem.new({
                    name = "newGame",
                    translation = "newGame",
                    callback = function() gameState:goToGameState() end
                }),
                MenuItem.new({
                    name = "instruction",
                    translation = "instruction",
                    callback = function () screen:showInstruction() end
                }),
                MenuItem.new({
                    name = "Lang",
                    translation = "switchlang",
                    callback = MainMenu.switchLanguage
                }),
                MenuItem.new({
                    name = "quit",
                    translation = "quit",
                    callback = MainMenu.quitGame
                })
            },
            menuWidth = 250,
            rowSize = 30
        }),
        title = love.graphics.newImage("assets/images/title.png"),
    }
    setmetatable(state, MainMenu)
    return state
end

function MainMenu:reset()
    self.index = 1;
end

function MainMenu:draw()
    love.graphics.draw(self.title, 20, 20)
    self.menu:draw()

    local yPos = window.y * 2 / 3 + self.menu.rowSize * 2
    local xPos = (window.x - self.menu.menuWidth) / 2 + self.menu.menuWidth - 20

    if ("en" == CurrentLang) then
        love.graphics.setColor(colors.selected)
    else
        love.graphics.setColor(colors.unselected)
    end
    love.graphics.printf("en", xPos, yPos, 30)

    if ("fr" == CurrentLang) then
        love.graphics.setColor(colors.selected)
    else
        love.graphics.setColor(colors.unselected)
    end
    love.graphics.printf("fr", xPos - 30, yPos, 30)
end

function MainMenu:keyPressed(key)
    if key == "down" then
        self.menu:next()
    elseif key == "up" then
        self.menu:prev()
    end

    if key == "return" then
        self.menu:confirm()
    end

    if self.menu.index ~= 3 then
        return;
    end

    if key == "left" or key == "right" then
        MainMenu.switchLanguage()
    end
end

function MainMenu.quitGame()
    love.event.quit()
end

function MainMenu.switchLanguage()
    AvailableLanguage.currentIndex = AvailableLanguage.currentIndex + 1
    if (AvailableLanguage.currentIndex > #AvailableLanguage) then
        AvailableLanguage.currentIndex = 1
    end
    CurrentLang = AvailableLanguage[AvailableLanguage.currentIndex]
end