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
    for i = 1, #(self.items) do
        local text = Lang[self.items[i].translation][CurrentLang];
        if self.index == i then 
            text = "> "..text
        end
        love.graphics.printf(text, (window.x - self.menuWidth) / 2, window.y * 2 / 3 + (i-1) * self.rowSize, self.menuWidth, "center");
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