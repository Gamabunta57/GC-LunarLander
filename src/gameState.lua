require("src/screen/game/gameScreen")
require("src/screen/victoryScreen")
require("src/screen/failScreen")
require("src/screen/titleScreen")

local askForStateChange = false

GameState = {
    titleScreen = TitleScreen:new(),
    gameScreen = GameScreen:new(),
    victoryScreen = VictoryScreen:new(),
    failScreen = FailScreen:new()
}

function GameState:new()
    local state = {
        currentState = {},
        newState = {},
        askForStateChange = false
    }
    setmetatable(state, self)
    self.__index = self;
    return state;
end

function GameState:setState(state)
    self.currentState = state;
    self.newState = state;
    askForStateChange = false
end

function GameState:setNewState(newState)
    askForStateChange = true;
    self.newState = newState;
end

function GameState:hasAskForStateChange()
    return askForStateChange;
end