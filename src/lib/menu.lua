require("src/sound/AudioEngine")

Menu = {}
Menu.__index = Menu

function Menu.new(menu)
    menu = menu or {
        items = {},
        menuWidth = 200,
        rowSize = 30
    }
    menu.index = 1;
    menu.selector = love.graphics.newImage("assets/images/selector.png")
    setmetatable(menu, Menu)
    return menu
end

function Menu:next()
    if (self.index < #(self.items)) then
        self.index = self.index + 1
        love.event.push("menuChangeItem")
    end
end

function Menu:prev()
    if (self.index > 1) then
        self.index = self.index - 1
        love.event.push("menuChangeItem")
    end
end

function Menu:confirm()
    love.event.push("menuConfirm")
    self.items[self.index].callback()
end

function Menu:draw()
    local hmargin = 30
    local vmargin = 20
    local topPos = window.y * 2 / 3 - vmargin;
    local leftPos = (window.x - self.menuWidth) / 2 - hmargin;
    local menuHeight = self.rowSize * #(self.items) + 1.5 * vmargin
    love.graphics.setColor({0,0,0,0.8})
    love.graphics.rectangle("fill", leftPos, topPos, self.menuWidth + 2 * hmargin, menuHeight)
    love.graphics.setColor(colors.main)
    love.graphics.setFont(fonts.main)
    for i = 1, #(self.items) do
        local text = Lang[self.items[i].translation][CurrentLang];
        local yPos =  window.y * 2 / 3 + (i-1) * self.rowSize;
        local xPos = (window.x - self.menuWidth) / 2;
        if self.index == i then 
            love.graphics.setColor(colors.selected)
            love.graphics.draw(self.selector, xPos - 24, yPos + 1)
        else
            love.graphics.setColor(colors.unselected)
        end
        love.graphics.printf(text, xPos, yPos, self.menuWidth, "left");
    end
end

MenuItem = {}
MenuItem.__index = MenuItem

function MenuItem.new(menuItem)
    menuItem = menuItem or {
        name = "item",
        translation = "item",
        callback = function()
            print("item has been selected, nothing to do with it")
        end
    }
    setmetatable(menuItem, MenuItem)
    return menuItem
end