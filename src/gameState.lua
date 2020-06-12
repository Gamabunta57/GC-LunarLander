require("src/gameScreen")
require("src/titleScreen")

GameState = {
    titleScreen = TitleScreen:new(),
    gameScreen = GameScreen:new()
}

function GameState:new()
    local state = {
        currentState = {},
        newState = {},
    }
    setmetatable(state, self)
    self.__index = self;
    return state;
end

function GameState:setState(state)
    self.currentState = state;
    self.newState = state;
end

function GameState:setNewState(newState)
    self.newState = newState;
end