require("src/screen/game/gameScreen")
require("src/screen/victoryScreen")
require("src/screen/failScreen")
require("src/screen/title/titleScreen")
require("src/screen/bgScreen")

local askForStateChange = false

GameState = {}
GameState.__index = GameState;

function GameState.new()
    local state = {
        currentState = {},
        newState = {},
        askForStateChange = false
    }
    setmetatable(state, GameState)
    return state;
end

function GameState:init()
    self.titleScreen = TitleScreen.new()
    self.gameScreen = GameScreen.new()
    self.victoryScreen = VictoryScreen.new(self.gameScreen)
    self.failScreen = FailScreen.new(self.gameScreen)
    self.bgScreen = BGScreen.new()
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

function GameState:goToGameState()
    self:setNewState(self.gameScreen)
end

function GameState:goToTitleScreenState()
    self:setNewState(self.titleScreen)
end

function GameState:goToVictoryState()
    self:setNewState(self.victoryScreen)
end

function GameState:goToFailState()
    self:setNewState(self.failScreen)
end