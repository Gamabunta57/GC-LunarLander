Instruction = {}
Instruction.__index = Instruction

function Instruction.new(screen)
    local state = {
        screen = screen,
        paddingH = 30,
        paddingV = 30,
        landed = love.graphics.newImage("assets/images/rocketLanded.png"),
        boom = love.graphics.newImage("assets/images/boom.png"),
        fuel  = love.graphics.newImage("assets/images/gauge.png")
    }
    setmetatable(state, Instruction)
    return state
end

function Instruction:reset()
end

function Instruction:draw()
    love.graphics.setColor(colors.spaceBg)
    love.graphics.rectangle("fill", 0,0,window.x,window.y)

    self:drawTitle(Lang.commands[CurrentLang], 30)
    self:drawLeftRightKey()
    self:drawSpaceKey()
    self:drawEscKey()
    self:drawTitle(Lang.your_mission[CurrentLang], window.y / 2)
    self:drawFrame(Lang.guideSpacecraft[CurrentLang], 0, self.landed)
    self:drawFrame(Lang.youMust[CurrentLang], 1, self.boom)
    self:drawFrame(Lang.beCareful[CurrentLang], 2, self.fuel)
end

function Instruction:drawTitle(string, yPos)
    love.graphics.setColor(colors.success)
    love.graphics.setFont(fonts.title)
    love.graphics.printf(string, 0, yPos, window.x, "center")
    love.graphics.setColor(colors.main)
end

function Instruction:drawLeftRightKey()
    love.graphics.setFont(fonts.main)
    local yPos = self.paddingV + 70
    local yPosText = yPos + (36 - 15) / 2
    love.graphics.rectangle("line", self.paddingH, yPos, 38, 38)
    love.graphics.printf("<", self.paddingH, yPosText, 38, "center")

    love.graphics.rectangle("line", self.paddingH + 10 + 38, yPos, 38, 38)
    love.graphics.printf(">", self.paddingH + 10 + 38, yPosText, 38, "center")

    love.graphics.printf(Lang.leftRightCommand[CurrentLang], self.paddingH + 2 * 38 + 10 + 20, yPosText, window.x, "left")
end

function Instruction:drawSpaceKey()
    love.graphics.setFont(fonts.main)
    local yPos = self.paddingV + 70 + 38 + 20
    local yPosText = yPos + (36 - 15) / 2
    love.graphics.rectangle("line", self.paddingH, yPos, 38 * 8, 38)
    love.graphics.printf(Lang.spaceKey[CurrentLang], self.paddingH, yPosText, 38 * 8, "center")

    love.graphics.printf(Lang.spaceCommand[CurrentLang], self.paddingH + 38 * 8 + 20, yPosText,  38 * 8, "left")
end

function Instruction:drawEscKey()
    love.graphics.setFont(fonts.main)
    local yPos = self.paddingV + 70 + 38 * 2 + 20 *2
    local yPosText = yPos + (36 - 15) / 2
    love.graphics.rectangle("line", self.paddingH, yPos, 38, 38)
    love.graphics.printf(Lang.escapeKey[CurrentLang], self.paddingH, yPosText, 38, "center")

    love.graphics.printf(Lang.escapeCommand[CurrentLang], self.paddingH + 38 + 20, yPosText,  window.x, "left")
end

function Instruction:drawFrame(strings, frameNumber, sprite)
    love.graphics.setFont(fonts.main)
    love.graphics.setColor(colors.main)
    local frameWidth = (window.x - self.paddingH * 2) / 3 - 20
    local frameX = self.paddingH + (frameNumber * frameWidth) + (frameNumber * 40)
    love.graphics.printf(strings, frameX, window.y /2 + 70, frameWidth, "left")
    love.graphics.setColor({1,1,1,1})
    love.graphics.draw(sprite, (frameWidth - sprite:getWidth())/2 + frameX - 30, window.y - self.paddingV - sprite:getHeight())
end


function Instruction:keyPressed(key)
    self.screen:goToMainMenu()
end