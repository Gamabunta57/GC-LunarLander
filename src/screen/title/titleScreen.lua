require("src/screen/screen")
require("src/lib/menu")
require("src/sound/audioEngine")
require("src/screen/title/mainMenu")
require("src/screen/title/instruction")

TitleScreen = {}
setmetatable(TitleScreen, Screen)
TitleScreen.__index = TitleScreen

function TitleScreen.new()
    local screen = {
        states = {
            main = nil,
            instruction = nil
        }
    }
    setmetatable(screen, TitleScreen);
    screen.states.main = MainMenu.new(screen)
    screen.states.instruction = Instruction.new(screen)
    screen.currentState = screen.states.main
    return screen;
end

function TitleScreen:draw()
    self.currentState:draw()
end

function TitleScreen:reset()
    self.currentState = self.states.main
    self.currentState:reset()
    love.event.push("startBgMusic")
end

function TitleScreen:keyPressed(key)
    self.currentState:keyPressed(key)
end


function TitleScreen:showInstruction()
    self.currentState = self.states.instruction
    self.currentState:reset()
end

function TitleScreen:goToMainMenu()
    self.currentState = self.states.main
end